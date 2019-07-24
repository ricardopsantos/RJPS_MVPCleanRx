//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import RxSwift
import RxCocoa

//
//MARK: Presenter_Protocol & View_Protocol
//

protocol SampleTableView_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol?      { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                    { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.SampleTableView_ViewModel?   { get set } // Mandatory in ALL Presenters
    var router      : SampleTableView_RouterProtocol! { get }     // Mandatory in ALL Presenters
    var tableView   : GenericTableView_Protocol!      { get }
    
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }    // PublishRelay model Events
    
}

protocol SampleTableView_ViewProtocol : class {
    func viewNeedsToDisplay(list:[E.Employee])
    func setNetworkViewVisibilityTo(_ value:Bool) 
}

//
//MARK: Presenter Declaration
//

extension Presenter {
    class SampleTableView_Presenter {
        weak var generic      : GenericPresenter_Protocol?
        weak var genericView  : GenericView?
        weak var view   : SampleTableView_ViewProtocol!
        var viewModel   : VM.SampleTableView_ViewModel? {
            didSet {
                AppLogs.DLog(code: .vmChanged)
                if let vm = viewModel {
                    view.viewNeedsToDisplay(list: vm.employeesList)
                }
                else {
                    view.viewNeedsToDisplay(list: [])
                }
            }
        }
        var router      : SampleTableView_RouterProtocol!
        var tableView   : GenericTableView_Protocol!

        var sampleA_UseCase : SampleA_UseCaseProtocol!
        var sampleB_UseCase : SampleB_UseCaseProtocol!
        
        // BehaviorRelay model a State
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[E.Employee]>(value: [])

        var disposeBag = DisposeBag()
        var reachabilityService = try! DefaultReachabilityService()

    }
}

extension P.SampleTableView_Presenter : GenericTableView_Protocol {
    
    func numberOfRows(_ section:Int) -> Int {
        return viewModel?.employeesList.count ?? 0
    }
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) -> Void {
        if let someCell = cell as? Sample_TableViewCellProtocol {
            let employee = viewModel!.employeesList[indexPath.row]
            let title = "\(employee.employeeName) | \(employee.employeeSalary)"
            //someCell.set(title:title)
            someCell.rxBehaviorRelay_title.accept(title)
            AppSimpleNetworkClient.downloadImageFrom(employee.profileImage, caching: .nsCache) { (image, _) in
                if let image = image {
                    //someCell.set(image:image)
                    someCell.rxBehaviorRelay_image.accept(image)
                }
                else {
                    //someCell.set(image:AppImages.notFound)
                    someCell.rxBehaviorRelay_image.accept(AppImages.notFound)
                }
            }
        }
        else {
            AppGlobal.assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object:Any) {
        AppLogs.DLog("\(object)")
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        AppLogs.DLog("\(indexPath)")
    }
    
}

//
//MARK: SampleTableView_PresenterProtocol
//

extension P.SampleTableView_Presenter : SampleTableView_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
}

//
//MARK: GenericPresenter_Protocol
//

extension P.SampleTableView_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void {
        viewModel = VM.SampleTableView_ViewModel()
    }
    func viewWillAppear() -> Void {
        setupPresenter()
    }
}

//
//MARK: Presenter Private Stuff
//

extension P.SampleTableView_Presenter {
    
    func setupPresenter() {
        
        rxObservable_GetEmployees()
            .subscribe(
                onNext: { [weak self] employeeList in
                    guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                    strongSelf.viewModel?.employeesList = employeeList
                },
                onError: { [weak self] error in
                    guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                    strongSelf.genericView?.displayMessage(error.localizedDescription, type: .error)
                }
            )
            .disposed(by: disposeBag)
        
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                strongSelf.view.setNetworkViewVisibilityTo(some.reachable)
            }
            ).disposed(by: disposeBag)
    }
    
    func rxObservable_GetEmployees() -> Observable<[E.Employee]> {
        return Observable.create { observer -> Disposable in
            do {
                let apiRequest: WebAPIRequest_Protocol = try RN.GetEmployees_APIRequest()
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<[E.Employee]>>) in
                    switch result {
                    case .success(let some):
                        let employeeList = some.entity
                        observer.onNext(employeeList)
                        break
                    case .failure(let error):
                        RJS_Logs.DLogError(error)
                        observer.onError(error)
                        break
                    }
                })
            }
            catch {
                RJS_Logs.DLogError(error)
                observer.onError(error)
            }
            return Disposables.create()
            }.retry(RN.GetEmployees_APIRequest.maxNumberOfRetrys)
            .retryOnBecomesReachable([], reachabilityService: reachabilityService)
    }
}
