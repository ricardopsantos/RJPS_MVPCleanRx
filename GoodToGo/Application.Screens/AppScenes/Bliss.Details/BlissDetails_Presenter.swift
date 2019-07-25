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

protocol BlissDetails_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol?   { get }     // Mandatory in ALL Presenters
    var genericView : GenericView?                 { get }     // Mandatory in ALL Presenters
    var viewModel   : VM.BlissDetails_ViewModel?   { get set } // Mandatory in ALL Presenters
    var router      : BlissDetails_RouterProtocol! { get }     // Mandatory in ALL Presenters
    var tableView   : GenericTableView_Protocol!   { get }
    
    func userDidPretendToShareInApp()
    func userDidPretendToShareByEmail()
    
    func checkDataToHandle() -> Bool
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }  // PublishRelay model Events
}

protocol BlissDetails_ViewProtocol : class {
    func viewNeedsToDisplay(list: [E.Bliss.ChoiceElement])
    func set(image:UIImage)
    func set(title:String)
    func displayShareOptionsWith(text:String)
}

//
//MARK: Presenter Declaration
//

extension Presenter {
    class BlissDetails_Presenter : GenericPresenter {
        weak var generic           : GenericPresenter_Protocol?
        weak var genericView       : GenericView?
        weak var view              : BlissDetails_ViewProtocol!
        var router                 : BlissDetails_RouterProtocol!
        var blissQuestions_UseCase : BlissQuestionsAPI_UseCaseProtocol!
        var blissGeneric_UseCase   : BlissGenericAppBussiness_UseCaseProtocol!
        var tableView              : GenericTableView_Protocol!
        var viewModel              : VM.BlissDetails_ViewModel? { didSet { AppLogs.DLog(code: .vmChanged); viewModelChanged() } }
        private var _disposeBag = DisposeBag()
        private var _reachabilityService = try! DefaultReachabilityService()
    }
}


//
//MARK: BlissDetails_PresenterProtocol
//

extension P.BlissDetails_Presenter : BlissDetails_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: router.rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
    
    func rxObservable_DoVote() -> Observable<E.Bliss.QuestionElement?> {
        return Observable.create { [weak self] observer -> Disposable in
            if let strongSelf = self {
                strongSelf.blissQuestions_UseCase.updateQuestion(question: strongSelf.viewModel!.question!, checkHealth: true) {  (result) in
                    switch result {
                    case .success(let some) : observer.onNext(some); break
                    case .failure(let error): observer.onError(error); break
                    }
                }
            }
            else {
                AppLogs.DLogWarning(AppConstants.Dev.referenceLost)
            }
            return Disposables.create()
            }.retry(3)
            .retryOnBecomesReachable(nil, reachabilityService: _reachabilityService)
    }
    
    func userDidPretendToShareInApp() {
        self.view.displayShareOptionsWith(text: linkToShare)
    }
    
    func userDidPretendToShareByEmail() {
        guard existsInternetConnection else { return }
        genericView?.setActivityState(true)
        blissQuestions_UseCase.shareQuestionBy(email: "www.meumail@gmail.com", url: linkToShare, checkHealth: true) { [weak self] (result) in
            guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
            strongSelf.genericView?.setActivityState(false)
            switch result {
            case .success(let some):
                if(some.sucess) {
                    strongSelf.genericView?.displayMessage(AppMessages.Bliss.sharedWithSucess, type: .sucess)
                }
                else {
                    strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                }
            case .failure(let error):
                AppLogs.DLogError(error)
                strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
            }
        }
    }
}

//
//MARK: GenericTableView_Protocol
//

extension P.BlissDetails_Presenter : GenericTableView_Protocol {
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) -> Void {
        guard viewModel != nil, viewModel?.question != nil else {
            return
        }
        if let someCell = cell as? Sample_TableViewCellProtocol {
            let choice = viewModel!.question!.choices[indexPath.row]
            let title = "\(choice.choice) | \(choice.votes)"
            //someCell.set(title:"\(choice.choice) | \(choice.votes)")
            someCell.rxBehaviorRelay_title.accept(title)
        }
        else {
            AppGlobal.assert(false, message: RJS_Constants.notPredicted + "\(cell)")
        }
    }
    
    func didSelect(object:Any) {
        AppLogs.DLog("\(object)")
 
        guard existsInternetConnection else { return }
        
        genericView?.setActivityState(true)
 
        rxObservable_DoVote()
            //.debounce(.milliseconds(AppConstants.Rx.servicesDefaultDebounce), scheduler: MainScheduler.instance)
            //.throttle(.milliseconds(AppConstants.Rx.servicesDefaultThrottle), scheduler: MainScheduler.instance) 
            .subscribe(
                onNext: { [weak self] some in
                    guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                    strongSelf.genericView?.setActivityState(false)
                    strongSelf.genericView?.displayMessage(AppMessages.sucess, type: .sucess)
                },
                onError: { [weak self] error in
                    guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                    strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                    strongSelf.genericView?.setActivityState(false)
                }
            )
            .disposed(by: _disposeBag)
        
    }
    
}

//
//MARK: GenericPresenter_Protocol
//

extension P.BlissDetails_Presenter : GenericPresenter_Protocol {
    func view_deinit() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    func loadView()       -> Void {
        if viewModel == nil {
            viewModel = VM.BlissDetails_ViewModel()
        }
    }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void {
        let _ = checkDataToHandle()
        setupPresenter()
    }
    func viewWillAppear() -> Void { }
}

//
//MARK: Presenter Private Stuff
//

extension P.BlissDetails_Presenter {
    
    private var linkToShare : String {
        return "myappdeeplink://questions?question_id=\(viewModel!.question!.id)"
    }
    
    private func viewModelChanged() {
        guard viewModel != nil, viewModel?.question != nil else {
            AppLogs.DLogWarning(AppConstants.Dev.referenceLost + " " + "or not prepared")
            return
        }
        view.set(title: (viewModel!.question!.question.description))
        view.viewNeedsToDisplay(list: viewModel!.question!.choices)
        downloadImage(imageURL: viewModel!.question!.imageURL, onFail: AppImages.notFound) { [weak self] (image) -> (Void) in
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
            if(key == AppConstants.Bliss.DeepLinks.questionId) {
                 if let someInt = Int(value) {
                    AppLogs.DLog("Handling data!")
                    blissQuestions_UseCase.getQuestionBy(id: someInt, checkHealth: true) { [weak self] (result) in
                        guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                        switch result {
                        case .success(let some): strongSelf.viewModel!.question = some; break
                        case .failure(_): strongSelf.genericView?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error); break
                        }
                    }
                    return true
                }
                else {
                    let message = "Invalid param\n\(AppMessages.pleaseTryAgainLater)"
                    genericView?.displayMessage(message, type: .error)
                }
                blissGeneric_UseCase.screenHaveHandledData(screen: V.BlissDetails_View.className)
            }
        }
        return false
    }
    
    private func setupPresenter() {
        
        blissGeneric_UseCase.rxPublishRelayAppicationDidReceivedData.asSignal()
            .emit(onNext: { [weak self] in
                let _ = self?.checkDataToHandle()
            }).disposed(by: disposeBag)
        
        _reachabilityService.reachability.subscribe(
            onNext: { [weak self] some in
                guard let strongSelf = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                strongSelf.genericView?.setNoConnectionViewVisibity(to: !some.reachable)
            }
            ).disposed(by: _disposeBag)
    }
    
}


