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
// MARK: - Presenter_Protocol & View_Protocol
//

protocol BlissRoot_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol? { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?               { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.BlissRoot_ViewModel?    { get set } // Mandatory in ALL Presenters
    var router      : BlissRoot_RouterProtocol!  { get }     // Mandatory in ALL Presenters
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }
    func userDidReadBadServerHealthMessage()
}

protocol BlissRoot_ViewProtocol : class {
    func viewNeedsToDisplayBadServerMessage()
    func set(image:UIImage?)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class BlissRoot_Presenter : GenericPresenter {
        weak var generic           : GenericPresenter_Protocol?
        weak var genericView       : GenericView?
        weak var view              : BlissRoot_ViewProtocol!
        var router                 : BlissRoot_RouterProtocol!
        var blissQuestions_UseCase : BlissQuestionsAPI_UseCaseProtocol!
        var blissGeneric_UseCase   : BlissGenericAppBussiness_UseCaseProtocol!
        var viewModel         : VM.BlissRoot_ViewModel? {
            didSet { AppLogs.DLog(appCode: .vmChanged); viewModelChanged() }
        }
    }
}

//
// MARK: - BlissRoot_PresenterProtocol
//

extension P.BlissRoot_Presenter : BlissRoot_PresenterProtocol {
    
    func userDidReadBadServerHealthMessage() {
        DispatchQueue.executeWithDelay (delay:AppConstants.defaultAnimationsTime) { [weak self] in
            guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
            strongSelf.checkServerStatus()
        }
    }
    
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

extension P.BlissRoot_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void {
        viewModel = VM.BlissRoot_ViewModel()
    }
    func viewWillAppear() -> Void {
        rxSetup()
    }
}

//
// MARK: - Presenter Private Stuff
//

extension P.BlissRoot_Presenter {
    
    private func viewModelChanged() {
        
    }
    
    private func checkServerStatus() {
        
        let delayToHaveTimeToEnjoyMainScreen : Double = 2
        DispatchQueue.executeWithDelay(delay:delayToHaveTimeToEnjoyMainScreen) { [weak self] in
            guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }

            let handleFail = { strongSelf.view.viewNeedsToDisplayBadServerMessage() }
            
            let handleSucess = { [weak self] in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.router.goToList(asNavigationController: true)
            }
            strongSelf.genericView?.setActivityState(true)
            strongSelf.blissQuestions_UseCase.getHealth { (some) in
                strongSelf.genericView?.setActivityState(false)
                switch some {
                case .success(let some):
                    if some.isOK {
                        handleSucess()
                    } else {
                        handleFail()
                    }
                case .failure:
                    handleFail()
                }
            }
        }
    }
    
    func rxSetup() {
   
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                    if some.reachable  {
                        self?.genericView?.setNoConnectionViewVisibity(to: false)
                        self?.rxObservableAssyncRequest
                            .subscribe(
                                onNext : { [weak self] some in self?.view.set(image: some); self?.checkServerStatus() },
                                onError: { [weak self] _ in self?.view.set(image: AppImages.notFound) }
                            )
                            .disposed(by: self!.disposeBag)
                    } else {
                        self?.genericView?.setNoConnectionViewVisibity(to: true)
                        self?.view.set(image: AppImages.notInternet)
                    }
            }
            ).disposed(by: disposeBag)
    }
    
}

//
// MARK: - RxRelated
//
extension P.BlissRoot_Presenter {
    var rxReturnOnError : UIImage { return AppImages.notInternet }
    var rxObservableAssyncRequest : Observable<UIImage> {
        return Observable.create { observer -> Disposable in
            self.downloadImage(imageURL: AppConstants.Bliss.logoURL, completion: { (image) in
                if image != nil {
                    observer.onNext(image!)
                } else { observer.onError(AppFactory.Errors.with(appCode: .unknownError)) }
            })
            return Disposables.create() }
            .retry(3)
            .retryOnBecomesReachable(rxReturnOnError, reachabilityService: reachabilityService)
    }
}