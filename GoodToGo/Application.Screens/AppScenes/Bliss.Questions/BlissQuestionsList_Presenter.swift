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

protocol BlissQuestionsList_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol?         { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                       { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.BlissQuestionsList_ViewModel?   { get set } // Mandatory in ALL Presenters
    var router      : BlissQuestionsList_RouterProtocol! { get }     // Mandatory in ALL Presenters
    var tableView   : GenericTableView_Protocol!         { get }
    
    func userPretendDoSearchWith(filter:String)
    func viewNeedsMoreData(filter:String)
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }
}

protocol BlissQuestionsList_ViewProtocol : class {
    func viewNeedsToDisplay(list:[E.Bliss.QuestionElement])
    func setSearch(text:String)
}

//
// MARK: - Presenter Declaration
//

extension Presenter {
    class BlissQuestionsList_Presenter : GenericPresenter {
        weak var generic           : GenericPresenter_Protocol?
        weak var genericView       : GenericView?
        weak var view              : BlissQuestionsList_ViewProtocol!
        var router                 : BlissQuestionsList_RouterProtocol!
        var tableView              : GenericTableView_Protocol!
        var blissQuestions_UseCase : BlissQuestionsAPI_UseCaseProtocol!
        var blissGeneric_UseCase   : BlissGenericAppBussiness_UseCaseProtocol!
        var viewModel         : VM.BlissQuestionsList_ViewModel? {
            didSet { AppLogs.DLog(appCode: .vmChanged); viewModelChanged() }
        }

        private var _lastFilder : String?
        private var _lastOffSet : Int? 

    }
}

//
// MARK: - GenericTableView_Protocol
//

extension P.BlissQuestionsList_Presenter : GenericTableView_Protocol {
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) -> Void {
        if let someCell = cell as? Sample_TableViewCellProtocol {
            let question = viewModel!.questionsList[indexPath.row]
            let title = "\(question.question.description)"
            //someCell.set(title:title)
            someCell.rxBehaviorRelay_title.accept(title)
            downloadImage(imageURL: question.thumbURL, onFail: AppImages.notFound) { (image) -> (Void) in
                someCell.rxBehaviorRelay_image.accept(image)
            }
        }
        else {
            AppGlobal.assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object:Any) {
        AppLogs.DLog("\(object)")
        guard existsInternetConnection, let question = object as? E.Bliss.QuestionElement else {
            return
        }
        router.goToDetails(vm: VM.BlissDetails_ViewModel(question: question))
    }
    
}

//
// MARK: - BlissQuestionsList_PresenterProtocol
//

extension P.BlissQuestionsList_Presenter : BlissQuestionsList_PresenterProtocol {

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
        updateData(filter: filter, offSet: _lastOffSet != nil ? _lastOffSet! + 1 : 1)
    }
    
    func rxObservable_GetList(filter:String, offSet:Int) -> Observable<[E.Bliss.QuestionElement]> {
        return Observable.create { [weak self] observer -> Disposable in
            if let strongSelf = self {
                strongSelf.blissQuestions_UseCase.getQuestions(limit: 10, filter: filter, offSet: offSet, checkHealth: true, completionHandler: { (result) in
                    switch result {
                    case .success(let questionsList): observer.onNext(questionsList)
                    case .failure(let error) : observer.onError(error)
                    }
                })
            } else {
                AppLogs.DLog(appCode: .referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable([], reachabilityService: reachabilityService)
    }
}

//
// MARK: - GenericPresenter_Protocol
//

extension P.BlissQuestionsList_Presenter : GenericPresenter_Protocol {
    func view_deinit() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    func loadView()  -> Void {
        setupPresenter()
    }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void {
        viewModel = VM.BlissQuestionsList_ViewModel()
        _lastFilder = nil
        _lastOffSet = nil
        updateData(filter: "", offSet: 0)
    }
    func viewWillAppear() -> Void { }
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
    
    private func updateData(filter:String, offSet:Int) {
        let filter = filter.trim
        
        // Not pretty, but very efective in avoind duplicated repeated server calls
        if _lastFilder != nil && _lastOffSet != nil {
            guard "\(_lastFilder!)|\(_lastOffSet!)" != "\(filter)|\(offSet)" else {
                AppLogs.DLogWarning("Ignored. Same filter and offset")
                return
            }
        }
        _lastFilder = filter
        _lastOffSet = offSet
        genericView?.setActivityState(true)
        rxObservable_GetList(filter: filter, offSet: offSet)
            .debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            .throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] questionsList in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    if strongSelf._lastOffSet == 0 {
                        strongSelf.viewModel?.questionsList = questionsList
                    } else {
                        strongSelf.viewModel?.questionsList.append(contentsOf: questionsList)
                    }
                    strongSelf.genericView?.setActivityState(false)
                },
                onError: { [weak self] error in
                    guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                    strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                    strongSelf.genericView?.setActivityState(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func setupPresenter() {
    
        func checkDataToHandle() -> Void {
            /*
             FREQ-02: Questions List Screen - Deep links
             */
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
            } else if let _ = blissGeneric_UseCase.screenHaveDataToHandle(screen: V.BlissDetails_View.className) {
                if self.genericView!.isVisible {
                    // If we are on the list, jump to details screen
                    router.goToDetails()
                }
            }
        }
        
        blissGeneric_UseCase.rxPublishRelayAppicationDidReceivedData.asSignal()
            .emit(onNext: {
                _ = checkDataToHandle()
            }).disposed(by: disposeBag)
        
        reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let strongSelf = self else { AppLogs.DLog(appCode: .referenceLost); return }
                strongSelf.genericView?.setNoConnectionViewVisibity(to: !some.reachable)
            }
            ).disposed(by: disposeBag)
    }
}
