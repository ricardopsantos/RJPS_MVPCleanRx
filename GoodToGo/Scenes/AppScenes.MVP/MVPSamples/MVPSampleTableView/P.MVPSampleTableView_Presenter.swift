//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions
import Designables
import Domain
import Repositories_WebAPI

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol MVPSampleTableView_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }              // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get }     // Mandatory in ALL Presenters
    var viewModel: VM.MVPSampleTableView_ViewModel? { get set } // Mandatory in ALL Presenters
    var router: MVPSampleTableView_RouterProtocol! { get }      // Mandatory in ALL Presenters
    var tableView: GenericTableView_Protocol! { get }
    
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }    // PublishRelay model Events
    
}

protocol MVPSampleTableView_ViewProtocol: class {
    func viewNeedsToDisplay(list: [Employee.ResponseDto])
    func setNetworkViewVisibilityTo(_ value: Bool)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class MVPSampleTableView_Presenter {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
        weak var view: MVPSampleTableView_ViewProtocol!
        var viewModel: VM.MVPSampleTableView_ViewModel? {
            didSet { DevTools.Log.appCode(.vmChanged); viewModelChanged() }
        }
        var router: MVPSampleTableView_RouterProtocol!
        var tableView: GenericTableView_Protocol!

        var sample_UseCase: Sample_UseCaseProtocol!
        var sampleB_UseCase: SampleB_UseCaseProtocol!
        
        // BehaviorRelay model a State
        private var rxBehaviorRelay_tableDataSource = BehaviorRelay<[Employee.ResponseDto]>(value: [])

        var disposeBag = DisposeBag()
        public var reachabilityService: ReachabilityService! = DevTools.reachabilityService

    }
}

extension P.MVPSampleTableView_Presenter: GenericTableView_Protocol {
    
    func numberOfRows(_ section: Int) -> Int {
        return viewModel?.employeesList.count ?? 0
    }
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) {
        if let someCell = cell as? DefaultTableViewCellProtocol {
            let employee = viewModel!.employeesList[indexPath.row]
            let title = "\(employee.employeeName) | \(employee.employeeSalary)"
            someCell.rxBehaviorRelay_title.accept(title)
            downloadImage(imageURL: employee.profileImage, onFail: Images.notFound.image) { (image) in
                someCell.rxBehaviorRelay_image.accept(image)
            }
        } else {
            DevTools.assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object: Any) {
        DevTools.Log.message("\(object)")
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        DevTools.Log.message("\(indexPath)")
    }
    
}

//
// MARK: - SampleTableView_PresenterProtocol
//

extension P.MVPSampleTableView_Presenter: MVPSampleTableView_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.MVPSampleTableView_Presenter: BasePresenterVMPProtocol {
    func view_deinit() { }
    func loadView() { }
    func viewDidAppear() { }
    func viewDidLoad() {
        viewModel = VM.MVPSampleTableView_ViewModel()
    }
    func viewWillAppear() {
        rxSetup()
    }
}

//
// MARK: - Presenter Private Stuff
//

extension P.MVPSampleTableView_Presenter {
    
    private func viewModelChanged() {
        updateViewWith(vm: viewModel)
    }
    
    private func updateViewWith(vm: VM.MVPSampleTableView_ViewModel?) {
        guard vm != nil else { DevTools.Log.appCode(.ignored); return }
        if let vm = vm {
            view.viewNeedsToDisplay(list: vm.employeesList)
        } else {
            view.viewNeedsToDisplay(list: [])
        }
    }
    
    func rxSetup() {
        
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let self = self else { return }
                self.view.setNetworkViewVisibilityTo(some.reachable)
            }
        ).disposed(by: disposeBag)
        
        getEmployeesObservable()
            .subscribe(
                onNext: { [weak self] employeeList in
                    guard let self = self else { return }
                    self.viewModel?.employeesList = employeeList
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.genericView?.displayMessage(error.localizedDescription, type: .error)
                }
        )
            .disposed(by: disposeBag)
        
    }
    
    func getEmployeesObservable() -> Observable<[Employee.ResponseDto]> {
        return Observable.create { observer -> Disposable in
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.EmployeesAPIRequest.GetEmployees_APIRequest()
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<[Employee.ResponseDto]>>) in
                    switch result {
                    case .success(let some):
                        let employeeList = some.entity
                        observer.onNext(employeeList)
                    case .failure(let error):
                        DevTools.Log.error(error)
                        observer.onError(error)
                    }
                })
            } catch {
                DevTools.Log.error(error)
                observer.onError(error)
            }
            return Disposables.create()
        }.retry(API.EmployeesAPIRequest.GetEmployees_APIRequest.maxNumberOfRetrys)
            .retryOnBecomesReachable([], reachabilityService: reachabilityService)
    }
}
