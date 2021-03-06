//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxSwift
import RxCocoa
//
import AppResources
import BaseUI
import AppTheme
import BaseConstants
import Extensions
import DevTools
import PointFreeFunctions
import Designables
import BaseDomain
import BaseCore
import Factory

// swiftlint:disable all

extension VC {
    class RxTesting: BaseViewControllerVIP, NetworkingOperationsUtilsProtocol {
        
        let margin: CGFloat = 10
        let btnHeight: CGFloat = 40
        
        private lazy var topGenericView: TopBar = {
            let some = UIKitFactory.topBar(baseController: self, usingSafeArea: true)
            some.setTitle("RxTesting")
            return some
        }()
        
        private lazy var searchBar: CustomSearchBar = {
            func handle(filter: String, sender: String) {
                guard !filter.isEmpty else { return }
                aux_log(message: "[_searchBar.][handle] from [\(sender)] : [\(filter)]", showAlert: true, appendToTable: true)
            }
            let some = UIKitFactory.searchBar(baseView: self.view, placeholder: Messages.search.localised)
            some.rjsALayouts.setMargin(0, on: .top, from: topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text.subscribe(onNext: { text in
                DevTools.Log.message(text ?? "")
            }).disposed(by: disposeBag)
            some.rx.text
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    let query = self?.searchBar.text?.trim ?? ""
                    handle(filter: query, sender: "[_searchBar][onNext]")
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (query) in
                    let query = self?.searchBar.text?.trim ?? ""
                    if query.count>0 {
                        handle(filter: query, sender: "[_searchBar][textDidEndEditing]")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        private lazy var btnThrottle: UIButton = {
            let throttle = 5
            let some = UIKitFactory.button(baseView: self.view, title: "Throttle \(throttle)s", style: .primary)
            some.rjsALayouts.setMargin(margin, on: .top, from: searchBar)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * margin))
            some.rjsALayouts.setHeight(btnHeight)
            //let trigger = PublishSubject<Bool>()
            some.rx.tap
                .log("_btnThrottle tap")
                .throttle(.milliseconds(throttle*1000), scheduler: MainScheduler.instance)
                .subscribe({ [weak self] _ in
                    self?.aux_log(message: "[_btnThrottle][fired]", showAlert: true, appendToTable: true)
                    
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var btnDebounce: UIButton = {
            let debounce = 3
            let some = UIKitFactory.button(baseView: self.view, title: "Debounce \(debounce)s", style: .primary)
            some.rjsALayouts.setMargin(margin, on: .top, from: searchBar)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * margin))
            some.rjsALayouts.setHeight(btnHeight)
            some.rx.tap
                .log("_btnDebounce tap")
                .debounce(.milliseconds(debounce*1000), scheduler: MainScheduler.instance)
                .subscribe({ [weak self] _ in
                    some.bumpAndPerform(disableUserInteractionFor: AppConstants.Dev.tapDefaultDisableTime, block: {
                        self?.aux_log(message: "[_btnDebounce][fired]", showAlert: true, appendToTable: true)
                    })
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        /*
         [PublishRelay] have parameters (optional)
         [PublishRelay] "fires" on [accept]
         [PublishRelay] is a good replacement for NSLocalNotications
         [PublishRelay] can do stuff before on [.do(onNext: { _ in DevTools.Log.message("stuff") })]

         [BehaviorRelay] have parameters (mandatory)
         [BehaviorRelay] can be "connected" to a property of some UI thing
         [BehaviorRelay] can be connected to other [BehaviorRelay]
         [BehaviorRelay] can do stuff before on [.do(onNext: { _ in DevTools.Log.message("stuff") })]
         [BehaviorRelay] The event "fires" on [accept]
         
         [BehaviorRelay/BehaviorSubject] model a State (hence it replays its latest value) and so does a Driver (models State).
         [PublishRelay/PublishSubject] model Events (hence it does not replay latest value)
         
         [PublishSubject] can have parameters, but does not need to have one on start with
         [PublishSubject] fire with [onNext(someValue)]
         [PublishSubject] Good to bing with stuff (animations?)
         [PublishSubject] A Subject is a reactive type that is both an Observable Sequence and an Observer
         [PublishSubject] Is concerned only with emitting new events to its subscribers.
         
        */

        var rxPublishRelay_a: PublishRelay  = PublishRelay<Void>()
        var rxPublishRelay_b: PublishRelay  = PublishRelay<String>()
        
        var rxBehaviorRelay_a: BehaviorRelay = BehaviorRelay<String>(value: "")
        var rxBehaviorRelay_b: BehaviorRelay = BehaviorRelay<String>(value: "")
        var rxBehaviorRelay_c: BehaviorRelay = BehaviorRelay<Int>(value: 0)
        
        private lazy var btnRxRelays: UIButton = {
        
            rxPublishRelay_a.asSignal() // PublishRelay (to model events) without param
                .debug("rxPublishRelay_a")
                .do(onNext: { _ in DevTools.Log.message("_rxPublishRelay_a : do.onNext_1") })
                .do(onNext: { _ in DevTools.Log.message("_rxPublishRelay_a : do.onNext_2") })
                .emit(onNext: { [weak self] in
                    self?.aux_log(message: "[_rxPublishRelay_a][emit]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            rxPublishRelay_b.asSignal() // PublishRelay (to model events) with param
                .debug("_rxPublishRelay_b")
                .do(onNext: { _ in DevTools.Log.message("_rxPublishRelay_b : do.onNext_1") })
                .do(onNext: { _ in DevTools.Log.message("_rxPublishRelay_b : do.onNext_2") })
                .emit(onNext: { [weak self] some in
                    self?.aux_log(message: "[_rxPublishRelay_b][emit] with param [\(some)]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            rxBehaviorRelay_a // BehaviorRelay (to models states) connected to Label
                .asDriver()
                .debug("_rxBehaviorRelay_a")
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_a : do.onNext_1") })
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_a : do.onNext_2") })
                .drive(searchBar.rx.text)
                .disposed(by: disposeBag)
            
            rxBehaviorRelay_b  // BehaviorRelay (to models states) connected  to other BehaviorRelay
                .log("_rxBehaviorRelay_b")
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_b : do.onNext_1") })
                .bind(to: rxBehaviorRelay_a)
                .disposed(by: disposeBag)
            
            rxBehaviorRelay_c // BehaviorRelay (to models states) doing random stuff
                .asObservable()
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_c : do.onNext_1") })
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_c : do.onNext_2") })
                .map { some -> Int in return some / 2 }
                .do(onNext: { _ in DevTools.Log.message("_rxBehaviorRelay_c : do.onNext_3") })
                .subscribe(onNext: { self.searchBar.text = "\($0)" })
                .disposed(by: disposeBag)
            
            let some = UIKitFactory.button(baseView: self.view, title: "[Publish|Behavior]Relay", style: .primary)
            some.rjsALayouts.setMargin(margin, on: .top, from: btnDebounce)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * margin))
            some.rjsALayouts.setHeight(btnHeight)
            some.onTouchUpInside {
                let someInt = (Date.utcNow.seconds)
                let random = Int.random(in: 0 ... 5)
                if random==1 {
                    self.aux_log(message: "[_rxBehaviorRelay_a]", showAlert: false, appendToTable: true)
                    self.rxBehaviorRelay_a.accept(self.rxBehaviorRelay_a.value + "|" + "VALUE_A_\(someInt)")
                }
                if random==2 {
                    self.aux_log(message: "[_rxBehaviorRelay_b]", showAlert: false, appendToTable: true)
                    self.rxBehaviorRelay_b.accept("\(someInt)")
                }
                if random==3 {
                    self.aux_log(message: "[_rxBehaviorRelay_c]", showAlert: false, appendToTable: true)
                    self.rxBehaviorRelay_c.accept(someInt)
                }
                if random==4 {
                    self.aux_log(message: "[_rxPublishRelay_a]", showAlert: false, appendToTable: true)
                    self.rxPublishRelay_a.accept(())
                }
            }
            return some
        }()
  
        private lazy var btnZip: UIButton = {
            let some = UIKitFactory.button(baseView: self.view, title: "Zip vs combineLatest", style: .primary)
            some.rjsALayouts.setMargin(margin, on: .top, from: btnRxRelays)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * margin))
            some.rjsALayouts.setHeight(btnHeight)
            
            var rxPublishRelay1 = PublishRelay<String?>()
            var rxPublishRelay2 = PublishRelay<String?>()
            var rxPublishRelay3 = PublishRelay<String?>()

            // http://adamborek.com/combinelatest-withlatestfrom-zip/

            // CombineLatest emits an item whenever any of the source Observables
            // emits an item (so long as each of the source Observables has emitted at least one item)
            
            Observable.combineLatest(rxPublishRelay1, rxPublishRelay2, rxPublishRelay3,
                resultSelector: { return "\($0 ?? "nil")|\($1 ?? "nil")|\($2 ?? "nil")" })
                .observeOn(MainScheduler.instance)
                .subscribe( onNext: { self.aux_log(message: "[combineLatest][onNext] \($0)", showAlert: true, appendToTable: true) })
                .disposed(by: disposeBag)
            
            // Waiting for both responses
            // ZIP operator combine the emissions of multiple Observables together via a
            // specified closure and emit single items for each combination based on the results of this closure.
            //
            
            Observable.zip(rxPublishRelay1, rxPublishRelay2, rxPublishRelay3,
                                     resultSelector: { return "\($0 ?? "nil")|\($1 ?? "nil")|\($2 ?? "nil")" })
                .observeOn(MainScheduler.instance)
                .subscribe( onNext: { self.aux_log(message: "[zip][onNext] \($0)", showAlert: true, appendToTable: true) })
                .disposed(by: disposeBag)
            
            some.onTouchUpInside {
 
                rxPublishRelay1.accept("1.1")
                rxPublishRelay2.accept("2.1")
                rxPublishRelay3.accept("3.1") // Zip fires
                
                rxPublishRelay1.accept("1.2")
                rxPublishRelay2.accept("2.2")
                rxPublishRelay3.accept("3.2")  // Zip fires
                
                //_rxPublishRelay1.accept("1.3")
                rxPublishRelay2.accept("2.3")
                rxPublishRelay3.accept("3.3")

                rxPublishRelay1.accept("1.4")  // Zip fires
                //_rxPublishRelay2.accept("2.4")
                //_rxPublishRelay3.accept("3.4")
                
            }
            return some
        }()
     
        private lazy var btnAsyncRequest: UIButton = {
            func doRequest() {
                rxObservableAsyncRequest
                    .subscribe(
                        onNext: { [weak self] _ in
                            self?.aux_log(message: "[Observable<T>][onNext]", showAlert: true, appendToTable: true)
                        },
                        onError: { [weak self] error in
                            self?.aux_log(message: "[Observable<T>][onError]", showAlert: true, appendToTable: true)
                        }
                    )
                    .disposed(by: disposeBag)
            }
            let some = UIKitFactory.button(baseView: self.view, title: "Observable<T>", style: .primary)
            some.rjsALayouts.setMargin(margin, on: .top, from: btnDebounce)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * margin))
            some.rjsALayouts.setHeight(btnHeight)
            some.onTouchUpInside { doRequest() }
            return some
        }()
        
        private var rxBehaviorRelay_tableDataSource = BehaviorRelay<[String]>(value: [])
        private lazy var tableView: UITableView = {
            let some = UIKitFactory.tableView(baseView: self.view)
            some.rjsALayouts.setMargin(margin, on: .top, from: btnZip)
            some.rjsALayouts.setMargin(margin, on: .right)
            some.rjsALayouts.setMargin(margin, on: .left)
            some.rjsALayouts.setMargin(margin, on: .bottom)
            some.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.reuseIdentifier)
            some.rx.setDelegate(self).disposed(by: disposeBag) // To manage heightForRowAt
            some.rx
                .modelSelected(String.self) // The type off the object we are binding on the tableview
                .throttle(.milliseconds(0), scheduler: MainScheduler.instance)
                .debounce(.milliseconds(0), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self]  item in
                    self?.aux_log(message: "[_tableView][modelSelected] : [\(item)]", showAlert: true, appendToTable: false)
                })
                .disposed(by: disposeBag)
            rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: DefaultTableViewCell.reuseIdentifier, cellType: DefaultTableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                _ = row
                guard let self = self else { return }
                cell.set(title: element)
                }.disposed(by: disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            aux_prepare()
        }
        
        func delay(_ delay: Double, block: @escaping () -> Void) {
            DispatchQueue.executeWithDelay(delay: delay) {
                block()
            }
        }
           
        override func viewDidLoad() {
            super.viewDidLoad()
            if DevTools.onSimulator {
                DispatchQueue.executeOnce(token: "\(VC.RxTesting.self).info") {
                    let message = """
                    Testing stuff with RxSwift/RxCocoa
                    """
                    DevTools.makeToast(message, duration: 5)
                }
            }
        }
    }
}

//
// MARK: - RxRelated
//
extension VC.RxTesting {
    
    var rxReturnOnError: UIImage { return Images.noInternet.image }
    var rxObservableAsyncRequest: Observable<UIImage> {
        return Observable.create { [weak self] observer -> Disposable in
            let address = Bool.random() ? "https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg" : "lalal"
            self?.networkingUtilsDownloadImage(imageURL: address, completion: { (image) in
                if image != nil {
                    self?.aux_log(message: "[rxObservableAsyncRequest][onNext]", showAlert: false, appendToTable: true)
                    observer.onNext(image!)
                } else {
                    self?.aux_log(message: "[rxObservableAsyncRequest][onError]", showAlert: false, appendToTable: true)
                    observer.onError(Factory.Errors.with(appCode: .invalidURL))
                }
            })
            return Disposables.create()
            }
            .retry()
            .retryOnBecomesReachable(rxReturnOnError, reachabilityService: DevTools.reachabilityService)
    }
}

//
// MARK: - Auxiliar
//
extension VC.RxTesting {
    
    func aux_prepare() {
        self.view.backgroundColor = ComponentColor.background
        searchBar.lazyLoad()
        btnThrottle.lazyLoad()
        btnDebounce.lazyLoad()
        btnRxRelays.lazyLoad()
        btnAsyncRequest.lazyLoad()
        btnZip.lazyLoad()
        tableView.lazyLoad()
    }
    
    func aux_log(message: String, showAlert: Bool, appendToTable: Bool) {
        searchBar.resignFirstResponder()
        DevTools.Log.message("\(message)")
        if appendToTable {
            let time = "" //"\(Date.utcNow().hours):\(Date.utcNow().minutes):\(Date.utcNow().seconds)"
            rxBehaviorRelay_tableDataSource.accept(["\(time) : \(message)"] + rxBehaviorRelay_tableDataSource.value)
        }
        if showAlert {
            displayStatus(viewModel: BaseDisplayLogicModels.Status(title: message))
        }
    }
}

// MARK: - UITableViewDelegate

extension VC.RxTesting: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Designables.Sizes.TableView.defaultHeightForCell
    }
}

extension VC.RxTesting {
    
    func sampleObservables() {
        
        ///////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////
        
        // 3 ways to do same thing
        if false {
            Observable<String>.of("2", "3", "3", "5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe(
                    onNext: { DevTools.Log.message("\($0)") },
                    onError: { DevTools.Log.message("\($0)") },
                    onCompleted: { DevTools.Log.message("completed s1") }
                ).disposed(by: disposeBag)
            
            Observable<String>.of("2", "3", "3", "5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({
                    switch $0 {
                    case .next(let value): DevTools.Log.message("\(value)")
                    case .error(let error): DevTools.Log.message("\(error)")
                    case .completed: DevTools.Log.message("completed s2")
                    }
                }).disposed(by: disposeBag)
            
            Observable<String>.of("2", "3", "3", "5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({ event in
                    switch event {
                    case .next(let value): DevTools.Log.message("\(value)")
                    case .error(let error): DevTools.Log.message("\(error)")
                    case .completed: DevTools.Log.message("completed s3")
                    }
                }).disposed(by: disposeBag)
        }

        ///////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////
        
        if false {
            //
            // RxSwift provides a method that creates a sequence which returns one element upon subscription.
            // That method is called just. Let's write our own implementation of it:
            //
            func myJust<E>(_ element: E) -> Observable<E> {
                return Observable.create { observer in
                    observer.on(.next(element))
                    observer.on(.completed)
                    return Disposables.create()
                }
            }
            func myFrom<E>(_ sequence: [E]) -> Observable<E> {
                return Observable.create { observer in
                    for element in sequence {
                        observer.on(.next(element))
                    }
                    observer.on(.completed)
                    return Disposables.create()
                }
            }
            //
            // Lets now create an observable that returns elements from an array.
            //
            let just = myJust("## my just ##")
            _ = just.subscribe(onNext: { n in DevTools.Log.message("just_1 : \(n)") })
            _ = just.subscribe(onNext: { n in DevTools.Log.message("just_2 : \(n)") })
    
            let from = myFrom(["## A ##", "## B ##", "## C ##"]).share()
            _ = from.subscribe(onNext: { n in DevTools.Log.message("from_1 : \(n)") })
            _ = from.subscribe(onNext: { n in DevTools.Log.message("from_2 : \(n)") })
        }

        if false {
            let intervalObservable_1 = Observable<NSInteger>
                .interval(0.1, scheduler: MainScheduler.instance)
                .take(5)
                 .map { "\($0)" }
             
             _ = intervalObservable_1
                 . subscribe(onNext: { n in DevTools.Log.message("intervalObservable : \(n)") })
             
             _ = intervalObservable_1
                 .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
                 .elementAt(0)
                 .subscribe(onNext: { n in DevTools.Log.message("intervalObservable_throttle : \(n)") })
        }
        
    }

}
