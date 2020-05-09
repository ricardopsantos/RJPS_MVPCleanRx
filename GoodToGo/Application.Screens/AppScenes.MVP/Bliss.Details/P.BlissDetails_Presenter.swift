//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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
import AppDomain

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol BlissDetails_PresenterProtocol: class {
    var generic: GenericPresenter_Protocol? { get }       // Mandatory in ALL Presenters
    var genericView: GenericViewProtocol? { get }         // Mandatory in ALL Presenters
    var viewModel: VM.BlissDetails_ViewModel? { get set } // Mandatory in ALL Presenters
    var router: BlissDetails_RouterProtocol! { get }      // Mandatory in ALL Presenters
    var tableView: GenericTableView_Protocol! { get }
    
    func userDidPretendToShareInApp()
    func userDidPretendToShareByEmail()
    
    func checkDataToHandle() -> Bool
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }  // PublishRelay model Events
}

protocol BlissDetails_ViewProtocol: class {
    func viewNeedsToDisplay(list: [Bliss.ChoiceElementResponseDto])
    func set(image: UIImage)
    func set(title: String)
    func displayShareOptionsWith(text: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class BlissDetails_Presenter: BasePresenter {
        weak var generic: GenericPresenter_Protocol?
        weak var genericView: GenericViewProtocol?
        weak var view: BlissDetails_ViewProtocol!
        var router: BlissDetails_RouterProtocol!
        var blissQuestions_UseCase: BlissQuestionsAPI_UseCaseProtocol!
        var blissGeneric_UseCase: BlissGenericAppBussiness_UseCaseProtocol!
        var tableView: GenericTableView_Protocol!
        var viewModel: VM.BlissDetails_ViewModel? { didSet { AppLogger.log(appCode: .vmChanged); viewModelChanged() } }
    }
}

//
// MARK: - BlissDetails_PresenterProtocol
//

extension P.BlissDetails_Presenter: BlissDetails_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    func rxObservable_DoVote() -> Observable<Bliss.QuestionElementResponseDto?> {
        return Observable.create { [weak self] observer -> Disposable in
            if let self = self {
                self.blissQuestions_UseCase.updateQuestion(question: self.viewModel!.question!, checkHealth: true) {  (result) in
                    switch result {
                    case .success(let some) : observer.onNext(some)
                    case .failure(let error): observer.onError(error)
                    }
                }
            } else {
                AppLogger.log(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: reachabilityService)
    }
    
    func userDidPretendToShareInApp() {
        self.view.displayShareOptionsWith(text: linkToShare)
    }
    
    func userDidPretendToShareByEmail() {
        guard existsInternetConnection else { return }
        genericView?.setActivityState(true)
        blissQuestions_UseCase.shareQuestionBy(email: "www.meumail@gmail.com", url: linkToShare, checkHealth: true) { [weak self] (result) in
            guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
            self.genericView?.setActivityState(false)
            switch result {
            case .success(let some):
                if some.success {
                    self.genericView?.displayMessage(AppMessages.Bliss.sharedWithSucess, type: .sucess, asAlert: false)
                } else {
                    self.genericView?.displayMessage(AppMessages.pleaseTryAgainLater.localised, type: .error, asAlert: false)
                }
            case .failure(let error):
                AppLogger.error(error)
                self.genericView?.displayMessage(AppMessages.pleaseTryAgainLater.localised, type: .error, asAlert: false)
            }
        }
    }
}

//
// MARK: - GenericTableView_Protocol
//

extension P.BlissDetails_Presenter: GenericTableView_Protocol {
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) {
        guard viewModel != nil, viewModel?.question != nil else {
            return
        }
        if let someCell = cell as? Sample_TableViewCellProtocol {
            let choice = viewModel!.question!.choices[indexPath.row]
            let title = "\(choice.choice) | \(choice.votes)"
            //someCell.set(title:"\(choice.choice) | \(choice.votes)")
            someCell.rxBehaviorRelay_title.accept(title)
        } else {
            assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object: Any) {
        AppLogger.log("\(object)")
 
        guard existsInternetConnection else { return }
        
        genericView?.setActivityState(true)
 
        rxObservable_DoVote()
            //.debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            //.throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance) 
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.genericView?.setActivityState(false)
                    self.genericView?.displayMessage(AppMessages.success.localised, type: .sucess, asAlert: false)
                },
                onError: { [weak self] error in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.genericView?.displayMessage(AppMessages.pleaseTryAgainLater.localised, type: .error, asAlert: false)
                    self.genericView?.setActivityState(false)
                }
            )
            .disposed(by: disposeBag)
        
    }
    
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.BlissDetails_Presenter: GenericPresenter_Protocol {
    func view_deinit() {
        NotificationCenter.default.removeObserver(self)
    }
    func loadView() {
        if viewModel == nil {
            viewModel = VM.BlissDetails_ViewModel()
        }
    }
    func viewDidAppear() { }
    func viewDidLoad() {
        _ = checkDataToHandle()
        rxSetup()
    }
    func viewWillAppear() { }
}

//
// MARK: - Presenter Private Stuff
//

extension P.BlissDetails_Presenter {
    
    private var linkToShare: String {
        return "myappdeeplink://questions?question_id=\(viewModel!.question!.id)"
    }
    
    private func viewModelChanged() {
        guard viewModel != nil, viewModel?.question != nil else {
            AppLogger.log(appCode: AppCodes.notPredicted)
            return
        }
        view.set(title: (viewModel!.question!.question.description))
        view.viewNeedsToDisplay(list: viewModel!.question!.choices)
        downloadImage(imageURL: viewModel!.question!.imageURL, onFail: AppImages.notFound) { [weak self] (image) in
            self?.view.set(image: image!)
        }
    }
    
    internal func checkDataToHandle() -> Bool {
        /*
         FREQ-02: Questions List Screen - Deep links
         */
        
        if let data = blissGeneric_UseCase.screenHaveDataToHandle(screen: V.BlissDetails_View.className) {
            let key   = data.0
            let value = data.1
            if key == AppConstants.Bliss.DeepLinks.questionId {
                 if let someInt = Int(value) {
                    AppLogger.log("Handling data!")
                    blissQuestions_UseCase.getQuestionBy(id: someInt, checkHealth: true) { [weak self] (result) in
                        guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                        switch result {
                        case .success(let some): self.viewModel!.question = some
                        case .failure          : self.genericView?.displayMessage(AppMessages.pleaseTryAgainLater.localised, type: .error, asAlert: false)
                        }
                    }
                    return true
                } else {
                    let message = "Invalid param\n\(AppMessages.pleaseTryAgainLater)"
                    genericView?.displayMessage(message, type: .error, asAlert: false)
                }
                blissGeneric_UseCase.screenHaveHandledData(screen: V.BlissDetails_View.className)
            }
        }
        return false
    }
    
    func rxSetup() {
        
        blissGeneric_UseCase.rxPublishRelayAppicationDidReceivedData.asSignal()
            .emit(onNext: { [weak self] in
                _ = self?.checkDataToHandle()
            }).disposed(by: disposeBag)
        
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.genericView?.setNoConnectionViewVisibility(to: !some.reachable, withMessage: AppMessages.noInternet.localised)
            }
            ).disposed(by: disposeBag)
    }
}
