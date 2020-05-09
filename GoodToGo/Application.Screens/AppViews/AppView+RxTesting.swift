//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension AppView {
    class RxTesting: GenericView, AppUtils_Protocol {
        
        let _margin: CGFloat = 10
        let _btnHeight: CGFloat = 40

        private var _rxReachabilityService = try! DefaultReachabilityService()
        
        private lazy var _topGenericView: V.TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle("RxTesting")
            return some
        }()
        
        private lazy var _searchBar: CustomSearchBar = {
            func handle(filter: String, sender: String) {
                guard !filter.isEmpty else { return }
                aux_log(message: "[_searchBar.][handle] from [\(sender)] : [\(filter)]", showAlert: true, appendToTable: true)
            }
            let some = AppFactory.UIKit.searchBar(baseView: self.view)
            some.rjsALayouts.setMargin(0, on: .top, from: _topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text.subscribe(onNext: { text in
                print(text as Any)
            }).disposed(by: disposeBag)
            some.rx.text
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    let query = self?._searchBar.text?.trim ?? ""
                    handle(filter: query, sender: "[_searchBar][onNext]")
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (query) in
                    let query = self?._searchBar.text?.trim ?? ""
                    if query.count>0 {
                        handle(filter: query, sender: "[_searchBar][textDidEndEditing]")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        private lazy var _btnThrottle: UIButton = {
            let throttle = 5
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Throttle \(throttle)s", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _searchBar)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            //let trigger = PublishSubject<Bool>()
            some.rx.tap
                .debug("_btnThrottle tap")
                .throttle(.milliseconds(throttle*1000), scheduler: MainScheduler.instance)
                .subscribe({ [weak self] _ in
                    self?.aux_log(message: "[_btnThrottle][fired]", showAlert: true, appendToTable: true)
                    
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnDebounce: UIButton = {
            let debounce = 3
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Debounce \(debounce)s", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _searchBar)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.rx.tap
                .debug("_btnDebounce tap")
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
         [PublishRelay] can do stuff before on [.do(onNext: { _ in AppLogger.log("stuff") })]

         [BehaviorRelay] have parameters (mandatory)
         [BehaviorRelay] can be "connected" to a property of some UI thing
         [BehaviorRelay] can be connected to other [BehaviorRelay]
         [BehaviorRelay] can do stuff before on [.do(onNext: { _ in AppLogger.log("stuff") })]
         [BehaviorRelay] The event "fires" on [accept]
         
         [BehaviorRelay/BehaviorSubject] model a State (hence it replays its latest value) and so does a Driver (models State).
         [PublishRelay/PublishSubject] model Events (hence it does not replay latest value)
         
         [PublishSubject] can have parameters, but does not need to have one on start with
         [PublishSubject] fire with [onNext(someValue)]
         [PublishSubject] Good to bing with sutff (amimations?)
         [PublishSubject] A Subject is a reactive type that is both an Observable Sequence and an Observer
         [PublishSubject] Is concerned only with emitting new events to its subscribers.
         
        */
        var _rxPublishSubject_a: PublishSubject  = PublishSubject<Void>()
        
        var _rxPublishRelay_a: PublishRelay  = PublishRelay<Void>()
        var _rxPublishRelay_b: PublishRelay  = PublishRelay<String>()
        
        var _rxBehaviorRelay_a: BehaviorRelay = BehaviorRelay<String>(value: "")
        var _rxBehaviorRelay_b: BehaviorRelay = BehaviorRelay<String>(value: "")
        var _rxBehaviorRelay_c: BehaviorRelay = BehaviorRelay<Int>(value: 0)
        
        private lazy var _btnRxRelays: UIButton = {
        
            _rxPublishRelay_a.asSignal() // PublishRelay (to model events) without param
                .debug("rxPublishRelay_a")
                .do(onNext: { _ in AppLogger.log("_rxPublishRelay_a : do.onNext_1") })
                .do(onNext: { _ in AppLogger.log("_rxPublishRelay_a : do.onNext_2") })
                .emit(onNext: { [weak self] in
                    self?.aux_log(message: "[_rxPublishRelay_a][emit]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            _rxPublishRelay_b.asSignal() // PublishRelay (to model events) with param
                .debug("_rxPublishRelay_b")
                .do(onNext: { _ in AppLogger.log("_rxPublishRelay_b : do.onNext_1") })
                .do(onNext: { _ in AppLogger.log("_rxPublishRelay_b : do.onNext_2") })
                .emit(onNext: { [weak self] some in
                    self?.aux_log(message: "[_rxPublishRelay_b][emit] with param [\(some)]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_a // BehaviorRelay (to models states) connected to Label
                .asDriver()
                .debug("_rxBehaviorRelay_a")
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_a : do.onNext_1") })
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_a : do.onNext_2") })
                .drive(_searchBar.rx.text)
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_b  // BehaviorRelay (to models states) connected  to other BehaviorRelay
                .debug("_rxBehaviorRelay_b")
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_b : do.onNext_1") })
                .bind(to: _rxBehaviorRelay_a)
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_c // BehaviorRelay (to models states) doing random stuff
                .asObservable()
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_c : do.onNext_1") })
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_c : do.onNext_2") })
                .map { some -> Int in return some / 2 }
                .do(onNext: { _ in AppLogger.log("_rxBehaviorRelay_c : do.onNext_3") })
                .subscribe(onNext: { self._searchBar.text = "\($0)" })
                .disposed(by: disposeBag)
            
            let some = AppFactory.UIKit.button(baseView: self.view, title: "[Publish|Behavior]Relay", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnDebounce)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.onTouchUpInside {
                let someInt = (Date.utcNow().seconds)
                let random = Int.random(in: 0 ... 5)
                if random==1 {
                    self.aux_log(message: "[_rxBehaviorRelay_a]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_a.accept(self._rxBehaviorRelay_a.value + "|" + "VALUE_A_\(someInt)")
                }
                if random==2 {
                    self.aux_log(message: "[_rxBehaviorRelay_b]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_b.accept("\(someInt)")
                }
                if random==3 {
                    self.aux_log(message: "[_rxBehaviorRelay_c]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_c.accept(someInt)
                }
                if random==4 {
                    self.aux_log(message: "[_rxPublishRelay_a]", showAlert: false, appendToTable: true)
                    self._rxPublishRelay_a.accept(())
                }
            }
            return some
        }()
  
        private lazy var _btnZip: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Zip vs combineLatest", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnRxRelays)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            
            var _rxPublishRelay1 = PublishRelay<String?>()
            var _rxPublishRelay2 = PublishRelay<String?>()
            var _rxPublishRelay3 = PublishRelay<String?>()

            // http://adamborek.com/combinelatest-withlatestfrom-zip/

            // CombineLatest emits an item whenever any of the source Observables
            // emits an item (so long as each of the source Observables has emitted at least one item)
            
            Observable.combineLatest(_rxPublishRelay1, _rxPublishRelay2, _rxPublishRelay3,
                resultSelector: { return "\($0 ?? "nil")|\($1 ?? "nil")|\($2 ?? "nil")" })
                .observeOn(MainScheduler.instance)
                .subscribe( onNext: { self.aux_log(message: "[combineLatest][onNext] \($0)", showAlert: true, appendToTable: true) })
                .disposed(by: disposeBag)
            
            // Waiting for both responses
            // ZIP operator combine the emissions of multiple Observables together via a
            // specified closure and emit single items for each combination based on the results of this closure.
            //
            
            Observable.zip(_rxPublishRelay1, _rxPublishRelay2, _rxPublishRelay3,
                                     resultSelector: { return "\($0 ?? "nil")|\($1 ?? "nil")|\($2 ?? "nil")" })
                .observeOn(MainScheduler.instance)
                .subscribe( onNext: { self.aux_log(message: "[zip][onNext] \($0)", showAlert: true, appendToTable: true) })
                .disposed(by: disposeBag)
            
            some.onTouchUpInside {
 
                _rxPublishRelay1.accept("1.1")
                _rxPublishRelay2.accept("2.1")
                _rxPublishRelay3.accept("3.1") // Zip fires
                
                _rxPublishRelay1.accept("1.2")
                _rxPublishRelay2.accept("2.2")
                _rxPublishRelay3.accept("3.2")  // Zip fires
                
                //_rxPublishRelay1.accept("1.3")
                _rxPublishRelay2.accept("2.3")
                _rxPublishRelay3.accept("3.3")

                _rxPublishRelay1.accept("1.4")  // Zip fires
                //_rxPublishRelay2.accept("2.4")
                //_rxPublishRelay3.accept("3.4")
                
            }
            return some
        }()
     
        private lazy var _btnAsyncRequest: UIButton = {
            func doRequest() {
                rxObservableAssyncRequest
                    .subscribe(
                        onNext: { [weak self] _ in
                            self?.aux_log(message: "[Observable<T>][onNext]", showAlert: true, appendToTable: true)
                            self?.displayMessage(AppMessages.ok, type: .sucess)
                        },
                        onError: { [weak self] error in
                            self?.aux_log(message: "[Observable<T>][onError]", showAlert: true, appendToTable: true)
                            self?.displayMessage(AppMessages.pleaseTryAgainLater, type: .error)
                        }
                    )
                    .disposed(by: disposeBag)
            }
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Observable<T>", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnDebounce)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (1.5 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.onTouchUpInside { doRequest() }
            return some
        }()
        
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[String]>(value: [])
        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnZip)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .bottom)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx.setDelegate(self).disposed(by: disposeBag) // To manage heightForRowAt
            some.rx
                .modelSelected(String.self) // The type off the object we are binding on the tableview
                .throttle(.milliseconds(0), scheduler: MainScheduler.instance)
                .debounce(.milliseconds(0), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self]  item in
                    self?.aux_log(message: "[_tableView][modelSelected] : [\(item)]", showAlert: true, appendToTable: false)
                })
                .disposed(by: disposeBag)
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                _ = element
                _ = row
                guard self != nil else { AppLogger.log(appCode: .referenceLost); return }
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
        }
    }
}

//
// MARK: - RxRelated
//
extension AppView.RxTesting {
    
    var rxReturnOnError: UIImage { return AppImages.notInternet }
    var rxObservableAssyncRequest: Observable<UIImage> {
        return Observable.create { [weak self] observer -> Disposable in
            let adress = Bool.random() ? "https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg" : "lalal"
            self?.downloadImage(imageURL: adress, completion: { (image) in
                if image != nil {
                    self?.aux_log(message: "[rxObservableAssyncRequest][onNext]", showAlert: false, appendToTable: true)
                    observer.onNext(image!)
                } else {
                    self?.aux_log(message: "[rxObservableAssyncRequest][onError]", showAlert: false, appendToTable: true)
                    observer.onError(AppFactory.Errors.with(appCode: .invalidURL))
                }
            })
            return Disposables.create()
            }
            /* If [retry]==[0], will never work; and ignore everything. If [retry]==[1], will execute ONCE and never retries. Min value : [retry]==[2]
             If we have [retry] and [retryOnBecomesReachable], will never retry, will allways return var [rxReturnOnError] by [retryOnBecomesReachable] */
            .retry()
        /* [retryOnBecomesReachable], will actually return [rxReturnOnError] var if we dont have internet connection
           BUT ALSO, if the requests fails on [observer.onError], the subscriber will receive [rxReturnOnError]
             on event [onNext]. If we dont have the [retryOnBecomesReachable], the subscriber will receive the error on [onError] */
        .retryOnBecomesReachable(rxReturnOnError, reachabilityService: _rxReachabilityService)
    }
}

//
// MARK: - Auxiliar
//
extension AppView.RxTesting {
    
    func aux_prepare() {
        self.view.backgroundColor = AppColors.appDefaultBackgroundColor
        _topGenericView.lazyLoad()
        _searchBar.lazyLoad()
        _btnThrottle.lazyLoad()
        _btnDebounce.lazyLoad()
        _btnRxRelays.lazyLoad()
        _btnAsyncRequest.lazyLoad()
        _btnZip.lazyLoad()
        _tableView.lazyLoad()
    }
    
    func aux_log(message: String, showAlert: Bool, appendToTable: Bool) {
        _searchBar.resignFirstResponder()
        print("\(message)")
        if appendToTable {
            let time = "" //"\(Date.utcNow().hours):\(Date.utcNow().minutes):\(Date.utcNow().seconds)"
            _rxBehaviorRelay_tableDataSource.accept(["\(time) : \(message)"] + _rxBehaviorRelay_tableDataSource.value)
        }
        if showAlert {
            displayMessage(message, type: .sucess)
        }
    }
}

// MARK: - UITableViewDelegate

extension AppView.RxTesting: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return V.Sample_TableViewCell.cellSize() * 0.5
    }
}

extension V.RxTesting {
    
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
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("completed s1") }
                ).disposed(by: disposeBag)
            
            Observable<String>.of("2", "3", "3", "5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({
                    switch $0 {
                    case .next(let value): print(value)
                    case .error(let error): print(error)
                    case .completed: print("completed s2")
                    }
                }).disposed(by: disposeBag)
            
            Observable<String>.of("2", "3", "3", "5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({ event in
                    switch event {
                    case .next(let value): AppLogger.log("\(value)")
                    case .error(let error): AppLogger.log("\(error)")
                    case .completed: AppLogger.log("completed s3")
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
            _ = just.subscribe(onNext: { n in AppLogger.log("just_1 : \(n)") })
            _ = just.subscribe(onNext: { n in AppLogger.log("just_2 : \(n)") })
    
            let from = myFrom(["## A ##", "## B ##", "## C ##"]).share()
            _ = from.subscribe(onNext: { n in AppLogger.log("from_1 : \(n)") })
            _ = from.subscribe(onNext: { n in AppLogger.log("from_2 : \(n)") })
        }

        if false {
            let intervalObservable_1 = Observable<NSInteger>
                 .interval(0.1, scheduler: MainScheduler.instance)
                .take(5)
                 .map { "\($0)" }
             
             _ = intervalObservable_1
                 . subscribe(onNext: { n in print("intervalObservable : \(n)") })
             
             _ = intervalObservable_1
                 .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
                 .elementAt(0)
                 .subscribe(onNext: { n in print("intervalObservable_throttle : \(n)") })
        }
        
    }
    
    func sampleDisposing() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        let subscription = Observable<Int>.interval(.milliseconds(300), scheduler: scheduler)
            .subscribe { event in print(event) }
        Thread.sleep(forTimeInterval: 2.0)
        subscription.dispose()
        // Will print number from 0 to 5
    }
    
}
