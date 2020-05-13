//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions
import Domain
import AppResources
import UIBase
import Factory

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol BlissRoot_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }          // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get } // Mandatory in ALL Presenters
    var viewModel: VM.BlissRoot_ViewModel? { get set }      // Mandatory in ALL Presenters
    var router: BlissRoot_RouterProtocol! { get }           // Mandatory in ALL Presenters
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }
    func userDidReadBadServerHealthMessage()
}

protocol BlissRoot_ViewProtocol: class {
    func viewNeedsToDisplayBadServerMessage()
    func set(image: UIImage?)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class BlissRoot_Presenter: BasePresenterMVP {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
        weak var view: BlissRoot_ViewProtocol!
        var router: BlissRoot_RouterProtocol!
        var blissQuestions_UseCase: BlissQuestionsAPIUseCaseProtocol!
        var blissGeneric_UseCase: BlissGenericAppBusinessUseCaseProtocol!
        var viewModel: VM.BlissRoot_ViewModel? {
            didSet { AppLogger.log(appCode: .vmChanged); viewModelChanged() }
        }
    }
}

//
// MARK: - BlissRoot_PresenterProtocol
//

extension P.BlissRoot_Presenter: BlissRoot_PresenterProtocol {
    
    func userDidReadBadServerHealthMessage() {
        DispatchQueue.executeWithDelay(delay: AppConstants.defaultAnimationsTime) { [weak self] in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            self.checkServerStatus()
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

extension P.BlissRoot_Presenter: BasePresenterVMPProtocol {
    func view_deinit() { }
    func loadView() { }
    func viewDidAppear() { }
    func viewDidLoad() {
        viewModel = VM.BlissRoot_ViewModel()
    }
    func viewWillAppear() {
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
        
        let delayToHaveTimeToEnjoyMainScreen: Double = 2
        DispatchQueue.executeWithDelay(delay: delayToHaveTimeToEnjoyMainScreen) { [weak self] in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }

            let handleFail = { self.view.viewNeedsToDisplayBadServerMessage() }
            
            let handleSucess = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.router.goToList(asNavigationController: true)
            }
            self.genericView?.setActivityState(true)
            self.blissQuestions_UseCase.getHealth { (some) in
                self.genericView?.setActivityState(false)
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
                    if some.reachable {
                        self?.genericView?.setNoConnectionViewVisibility(to: false, withMessage: "")
                        self?.rxObservableAssyncRequest
                            .subscribe(
                                onNext: { [weak self] some in self?.view.set(image: some); self?.checkServerStatus() },
                                onError: { [weak self] _ in self?.view.set(image: Images.notFound.image) }
                            )
                            .disposed(by: self!.disposeBag)
                    } else {
                        self?.genericView?.setNoConnectionViewVisibility(to: true, withMessage: Messages.noInternet.localised)
                        self?.view.set(image: Images.noInternet.image)
                    }
            }
            ).disposed(by: disposeBag)
    }
    
}

//
// MARK: - RxRelated
//
extension P.BlissRoot_Presenter {
    var rxReturnOnError: UIImage { return Images.noInternet.image }
    var rxObservableAssyncRequest: Observable<UIImage> {
        return Observable.create { observer -> Disposable in
            self.downloadImage(imageURL: AppConstants.Bliss.logoURL, completion: { (image) in
                if image != nil {
                    observer.onNext(image!)
                } else { observer.onError(Factory.Errors.with(appCode: .unknownError)) }
            })
            return Disposables.create() }
            .retry(3)
            .retryOnBecomesReachable(rxReturnOnError, reachabilityService: reachabilityService)
    }
}
