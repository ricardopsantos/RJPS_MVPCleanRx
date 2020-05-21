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
import Domain_Bliss

//
// MARK: - Presenter_Protocol & View_Protocol
//

protocol BlissQuestionsList_PresenterProtocol: class {
    var generic: BasePresenterVMPProtocol? { get }              // Mandatory in ALL Presenters
    var genericView: BaseViewControllerMVPProtocol? { get }     // Mandatory in ALL Presenters
    var viewModel: VM.BlissQuestionsList_ViewModel? { get set } // Mandatory in ALL Presenters
    var router: BlissQuestionsList_RouterProtocol! { get }      // Mandatory in ALL Presenters
    var tableView: GenericTableView_Protocol! { get }
    
    func userPretendDoSearchWith(filter: String)
    func viewNeedsMoreData(filter: String)
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }
}

protocol BlissQuestionsList_ViewProtocol: class {
    func viewNeedsToDisplay(list: [Bliss.QuestionElementResponseDto])
    func setSearch(text: String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class BlissQuestionsList_Presenter: BasePresenterMVP {
        weak var generic: BasePresenterVMPProtocol?
        weak var genericView: BaseViewControllerMVPProtocol?
        weak var view: BlissQuestionsList_ViewProtocol!
        var router: BlissQuestionsList_RouterProtocol!
        var tableView: GenericTableView_Protocol!
        var blissQuestions_UseCase: BlissQuestionsAPIUseCaseProtocol!
        var blissGeneric_UseCase: BlissGenericAppBusinessUseCaseProtocol!
        var viewModel: VM.BlissQuestionsList_ViewModel? {
            didSet { DevTools.Log.appCode(.vmChanged); viewModelChanged() }
        }

        private var lastFilder: String?
        private var lastOffSet: Int?

    }
}

//
// MARK: - GenericTableView_Protocol
//

extension P.BlissQuestionsList_Presenter: GenericTableView_Protocol {
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) {
        if let someCell = cell as? Sample_TableViewCellProtocol {
            let question = viewModel!.questionsList[indexPath.row]
            let title = "\(question.question.description)"
            someCell.rxBehaviorRelay_title.accept(title)
            downloadImage(imageURL: question.thumbURL, onFail: Images.notFound.image) { (image) in
                someCell.rxBehaviorRelay_image.accept(image)
            }
        } else {
            DevTools.assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object: Any) {
        DevTools.Log.message("\(object)")
        guard existsInternetConnection, let question = object as? Bliss.QuestionElementResponseDto else {
            return
        }
        router.goToDetails(vm: VM.BlissDetails_ViewModel(question: question))
    }
    
}

//
// MARK: - BlissQuestionsList_PresenterProtocol
//

extension P.BlissQuestionsList_Presenter: BlissQuestionsList_PresenterProtocol {

    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    func userPretendDoSearchWith(filter: String) {
        guard existsInternetConnection else { return }
        updateData(filter: filter, offSet: 0)
    }

    func viewNeedsMoreData(filter: String) {
        guard existsInternetConnection else { return }
        updateData(filter: filter, offSet: lastOffSet != nil ? lastOffSet! + 1 : 1)
    }
    
    func rxObservable_GetList(filter: String, offSet: Int) -> Observable<[Bliss.QuestionElementResponseDto]> {
        return Single.create { [weak self] observer -> Disposable in
            if let self = self {
                self.blissQuestions_UseCase.getQuestions(limit: 10, filter: filter, offSet: offSet, checkHealth: true, completionHandler: { (result) in
                    switch result {
                    //case .success(let questionsList): observer.onNext(questionsList)
                    //case .failure(let error) : observer.onError(error)
                    case .success(let questionsList): observer(.success(questionsList))
                    case .failure(let error) : observer(.error(error))
                        
                    }
                })
            } else {
                DevTools.Log.appCode( .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable([], reachabilityService: reachabilityService)
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.BlissQuestionsList_Presenter: BasePresenterVMPProtocol {
    func view_deinit() {
        NotificationCenter.default.removeObserver(self)
    }
    func loadView() {
        rxSetup()
    }
    func viewDidAppear() { }
    func viewDidLoad() {
        viewModel = VM.BlissQuestionsList_ViewModel()
        lastFilder = nil
        lastOffSet = nil
        updateData(filter: "", offSet: 0)
    }
    func viewWillAppear() { }
}

//
// MARK: - Presenter Private Stuff
//

extension P.BlissQuestionsList_Presenter {
  
    private func viewModelChanged() {
        if let vm = viewModel {
            view.viewNeedsToDisplay(list: vm.questionsList)
        } else {
            view.viewNeedsToDisplay(list: [])
        }
    }
    
    private func updateData(filter: String, offSet: Int) {
        let filter = filter.trim
        
        // Not pretty, but very efective in avoind duplicated repeated server calls
        if lastFilder != nil && lastOffSet != nil {
            guard "\(lastFilder!)|\(lastOffSet!)" != "\(filter)|\(offSet)" else {
                DevTools.Log.warning("Ignored. Same filter and offset")
                return
            }
        }
        lastFilder = filter
        lastOffSet = offSet
        genericView?.setActivityState(true)
        rxObservable_GetList(filter: filter, offSet: offSet)
            .debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            .throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] questionsList in
                    guard let self = self else { return }
                    if self.lastOffSet == 0 {
                        self.viewModel?.questionsList = questionsList
                    } else {
                        self.viewModel?.questionsList.append(contentsOf: questionsList)
                    }
                    self.genericView?.setActivityState(false)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.genericView?.displayMessage(Messages.pleaseTryAgainLater.localised, type: .error)
                    self.genericView?.setActivityState(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func rxSetup() {
    
        func checkDataToHandle() {
            if let data = blissGeneric_UseCase.screenHaveDataToHandle(screen: V.BlissQuestionsList_View.className) {
                let key   = data.0
                let value = data.1
                if key == AppConstants.Bliss.DeepLinks.questionsFilter {
                    if value.count > 0 {
                        view.setSearch(text: value)
                        userPretendDoSearchWith(filter: value)
                    }
                    blissGeneric_UseCase.screenHaveHandledData(screen: V.BlissQuestionsList_View.className)
                }
            } else if blissGeneric_UseCase.screenHaveDataToHandle(screen: V.BlissDetails_View.className) != nil {
                #warning("comentado nos deeplinks. apagar depois a variavel")
                //if self.genericView!.isVisible {
                //    // If we are on the list, jump to details screen
                //    router.goToDetails()
                //}
            }
        }
        
        blissGeneric_UseCase.rxPublishRelayApplicationDidReceivedData.asSignal()
            .emit(onNext: {
                _ = checkDataToHandle()
            }).disposed(by: disposeBag)
        
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let self = self else { return }
                self.genericView?.setNoConnectionViewVisibility(to: !some.reachable, withMessage: Messages.noInternet.localised)
            }
            ).disposed(by: disposeBag)
    }
}
