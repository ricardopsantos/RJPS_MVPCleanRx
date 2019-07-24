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
    class RxTesting: GenericView {
        
        let _margin    : CGFloat = 10
        let _btnHeight : CGFloat = 40

        private var _rxReachabilityService = try! DefaultReachabilityService()
        
        private lazy var _topGenericView: V.TopBar = {
            let some = AppFactory.UIKit.topBar(baseController: self)
            some.setTitle("RxTesting")
            return some
        }()
        
        private lazy var _lblTitle1: UILabel = {
            let some = UILabel()
            self.view.addSubview(some)
            some.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
            some.font = AppFonts.light(size: .regular)
            some.textAlignment = .center
            some.rjsALayouts.setMargin(0, on: .top)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setWidth(AppGlobal.screenWidth/3)
            some.rjsALayouts.setHeight(V.TopBar.defaultHeight)
            return some
        }()
        
        private lazy var _lblTitle2: UILabel = {
            let some = UILabel()
            self.view.addSubview(some)
            some.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
            some.font = AppFonts.light(size: .regular)
            some.textAlignment = .center
            some.rjsALayouts.setMargin(0, on: .top)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setWidth(AppGlobal.screenWidth/3)
            some.rjsALayouts.setHeight(V.TopBar.defaultHeight)
            return some
        }()
        
        private lazy var _searchBar: CustomSearchBar = {
            func handle(filter:String, sender:String) {
                aux_log(message: "[_searchBar.][handle] from [\(sender)] : [\(filter)]", showAlert: true, appendToTable: true)
            }
            let some = AppFactory.UIKit.searchBar(baseView: self.view)
            some.rjsALayouts.setMargin(0, on: .top, from: _topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .throttle(.milliseconds(AppConstants.Rx.textFieldsDefaultThrottle), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    let query = self?._searchBar.text?.trim ?? ""
                    handle(filter: query, sender:"[_searchBar][onNext]")
                })
                .disposed(by: disposeBag)
            some.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (query) in
                    let query = self?._searchBar.text?.trim ?? ""
                    if(query.count>0) {
                        handle(filter: query, sender:"[_searchBar][textDidEndEditing]")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        private lazy var _btnThrottle: UIButton = {
            let throttle = 5
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Throttle \(throttle) seconds", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _searchBar)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (2 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.rx.tap
                .throttle(.milliseconds(throttle*1000), scheduler: MainScheduler.instance)
                .subscribe({ [weak self] _ in
                    some.bumpAndPerformBlock {
                        self?.aux_log(message: "[_btnThrottle][fired]", showAlert: true, appendToTable: true)
                    }
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        private lazy var _btnDebounce: UIButton = {
            let debounce = 3
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Debounce \(debounce) seconds", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _searchBar)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (2 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.rx.tap
                .debounce(.milliseconds(debounce*1000), scheduler: MainScheduler.instance)
                .subscribe({ [weak self] _ in
                    some.bumpAndPerformBlock {
                        self?.aux_log(message: "[_btnDebounce][fired]", showAlert: true, appendToTable: true)
                    }
                })
                .disposed(by: disposeBag)
            return some
        }()
        
        /*
         [PublishRelay] have parameters (optional)
         [PublishRelay] "fires" on [accept]
         [PublishRelay] is a good replacement for NSLocalNotications
         [PublishRelay] can do stuff before on [.do(onNext: { _ in print("stuff") })]

         [BehaviorRelay] have parameters (mandatory)
         [BehaviorRelay] can be "connected" to a property of some UI thing
         [BehaviorRelay] can be connected to other [BehaviorRelay]
         [BehaviorRelay] can do stuff before on [.do(onNext: { _ in print("stuff") })]
         [BehaviorRelay] The event "fires" on [accept]
         
         [BehaviorRelay/BehaviorSubject] model a State (hence it replays its latest value) and so does a Driver (models State).
         [PublishRelay/PublishSubject] model Events (hence it does not replay latest value)
         
        */
        var _rxPublishRelay_a  : PublishRelay  = PublishRelay<Void>()
        var _rxPublishRelay_b  : PublishRelay  = PublishRelay<String>()
        var _rxBehaviorRelay_a : BehaviorRelay = BehaviorRelay<String>(value: "")
        var _rxBehaviorRelay_b : BehaviorRelay = BehaviorRelay<String>(value: "")
        var _rxBehaviorRelay_c : BehaviorRelay = BehaviorRelay<Int>(value: 0)
        private lazy var _btnRxRelays: UIButton = {
            
            _rxPublishRelay_a.asSignal() // PublishRelay (to model events) without param
                .do(onNext: { _ in print("_rxPublishRelay_a : 1") })
                .do(onNext: { _ in print("_rxPublishRelay_a : 2") })
                .emit(onNext: { [weak self] in
                    self?.aux_log(message: "[_rxPublishRelay_a][emit]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            _rxPublishRelay_b.asSignal() // PublishRelay (to model events) with param
                .do(onNext: { _ in print("_rxPublishRelay_b : 1") })
                .do(onNext: { _ in print("_rxPublishRelay_b : 2") })
                .emit(onNext: { [weak self] some in
                    self?.aux_log(message: "[_rxPublishRelay_b][emit] with param [\(some)]", showAlert: true, appendToTable: true)
                })
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_a // BehaviorRelay (to models states) connected to Label
                .asDriver()
                .do(onNext: { _ in print("_rxBehaviorRelay_a") })
                .do(onNext: { _ in print("_rxBehaviorRelay_a") })
                .drive(_lblTitle1.rx.text)
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_b  // BehaviorRelay (to models states) connected  to other BehaviorRelay
                .do(onNext: { _ in print("_rxPublishRelay_a : 2") })
                .bind(to: _rxBehaviorRelay_a)
                .disposed(by: disposeBag)
            
            _rxBehaviorRelay_c // BehaviorRelay (to models states) doing random stuff
                .asObservable()
                .do(onNext: { _ in print("_rxBehaviorRelay_c: a") })
                .do(onNext: { _ in print("_rxBehaviorRelay_c: b") })
                .map { some -> Int in return some / 2 }
                .do(onNext: { _ in print("_rxBehaviorRelay_c: c") })
                .subscribe(onNext: { self._lblTitle1.text = "\($0)" })
                .disposed(by: disposeBag)
            
            let some = AppFactory.UIKit.button(baseView: self.view, title: "[Publish|Behavior]", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnDebounce)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (2 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.onTouchUpInside {
                let someInt = (Date.utcNow().seconds)
                let random = Int.random(in: 0 ... 5)
                if(random==1) {
                    self.aux_log(message: "[_rxBehaviorRelay_a]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_a.accept(self._rxBehaviorRelay_a.value + "|" + "VALUE_A_\(someInt)")
                }
                if(random==2) {
                    self.aux_log(message: "[_rxBehaviorRelay_b]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_b.accept("\(someInt)")
                }
                if(random==3) {
                    self.aux_log(message: "[_rxBehaviorRelay_c]", showAlert: false, appendToTable: true)
                    self._rxBehaviorRelay_c.accept(someInt)
                }
                if(random==4) {
                    self.aux_log(message: "[_rxPublishRelay_a]", showAlert: false, appendToTable: true)
                    self._rxPublishRelay_a.accept(())
                }
            }
            return some
        }()
        /*
        private lazy var _btnRxBehaviorRelay: UIButton = {
            let some = AppFactory.UIKit.button(baseView: self.view, title: "Free", style: .regular)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnDebounce)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (2 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.onTouchUpInside {
 
            }
            return some
        }()
        */
        private lazy var _btnAsyncRequest: UIButton = {
            func doRequest() {
                rxObservableAssyncRequest
                    .subscribe(
                        onNext: { [weak self] some in
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
            some.rjsALayouts.setWidth((UIScreen.main.bounds.width / 2.0) - (2 * _margin))
            some.rjsALayouts.setHeight(_btnHeight)
            some.onTouchUpInside { doRequest() }
            return some
        }()
        
        private var _rxBehaviorRelay_tableDataSource = BehaviorRelay<[String]>(value: [])
        private lazy var _tableView: UITableView = {
            let some = AppFactory.UIKit.tableView(baseView: self.view)
            some.rjsALayouts.setMargin(_margin, on: .top, from: _btnAsyncRequest)
            some.rjsALayouts.setMargin(_margin, on: .right)
            some.rjsALayouts.setMargin(_margin, on: .left)
            some.rjsALayouts.setMargin(_margin, on: .bottom)
            some.register(Sample_TableViewCell.self, forCellReuseIdentifier: Sample_TableViewCell.reuseIdentifier)
            some.rx
                .modelSelected(String.self) // The type off the object we are binding on the tableview
                .throttle(.milliseconds(0), scheduler: MainScheduler.instance)
                .debounce(.milliseconds(0), scheduler: MainScheduler.instance)
                .subscribe(onNext:  { [weak self]  item in
                    self?.aux_log(message: "[_tableView][modelSelected] : [\(item)]", showAlert: true, appendToTable: false)
                })
                .disposed(by: disposeBag)
            _rxBehaviorRelay_tableDataSource.bind(to: some.rx.items(cellIdentifier: Sample_TableViewCell.reuseIdentifier, cellType: Sample_TableViewCell.self)) { [weak self] (row, element, cell) in
                guard let _ = self else { AppLogs.DLogWarning(AppConstants.Dev.referenceLost); return }
                cell.set(title:element)
                }.disposed(by: disposeBag)
            return some
        }()
        
        override func loadView() {
            super.loadView()
            aux_prepare()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            sampleObservables()
        }
        
        func sampleObservables() {

            ///////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
            
            // 3 ways to do same thing
            
            Observable<String>.of("2","3","3","5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("completed s1") }
                ).disposed(by: disposeBag)
            
            Observable<String>.of("2","3","3","5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({
                    switch $0 {
                    case .next(let value): print(value)
                    case .error(let error): print(error)
                    case .completed: print("completed s2")
                    }
                }).disposed(by: disposeBag)
            
            Observable<String>.of("2","3","3","5")
                .map { return Int($0)! * 10 }
                .filter { $0 > 25 }
                .subscribe({ event in
                    switch event {
                    case .next(let value): print(value)
                    case .error(let error): print(error)
                    case .completed: print("completed s3")
                    }
                }).disposed(by: disposeBag)
            
            ///////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
            
            func rxObservableSimpleWithParans(some: String) -> Observable<String> {
                return Observable.create { observer -> Disposable in
                    DispatchQueue.executeWithDelay (delay:1) { observer.onNext(some) }
                    return Disposables.create()
                }
            }
            
            var rxObservableSimpleVar : Observable<Int> {
                return Observable.create { observer -> Disposable in
                    DispatchQueue.executeWithDelay (delay:1) { observer.onNext(Date.utcNow().seconds) }
                    return Disposables.create()
                }
            }
            
            rxObservableSimpleWithParans(some: "Hi")
                .subscribe( onNext: { print("After 1s : \($0)") } )
                .disposed(by: disposeBag)
            
            rxObservableSimpleVar
                .subscribe( onNext: { print("After 1s : \($0)") } )
                .disposed(by: disposeBag)

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
}

//
//MARK: RxRelated
//
extension AppView.RxTesting {
    
    var rxReturnOnError : UIImage { return AppImages.notInternet }
    var rxObservableAssyncRequest : Observable<UIImage> {
        return Observable.create { [weak self] observer -> Disposable in
            let adress = Bool.random() ? "https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg" : "lalal"
            AppSimpleNetworkClient.downloadImageFrom(adress, completion: { (image) in
                if(image != nil) {
                    self?.aux_log(message: "[rxObservableAssyncRequest][onNext]", showAlert: false, appendToTable: true)
                    observer.onNext(image!)
                }
                else {
                    self?.aux_log(message: "[rxObservableAssyncRequest][onError]", showAlert: false, appendToTable: true)
                    observer.onError(AppFactory.Errors.with(code: .invalidURL))
                }
            })
            return Disposables.create()
            }
            /* If [retry]==[0], will never work; and ignore everything. If [retry]==[1], will execute ONCE and never retries. Min value : [retry]==[2]
             If we have [retry] and [retryOnBecomesReachable], will never retry, will allways return var [rxReturnOnError] by [retryOnBecomesReachable] */
            .retry(3)
        /* [retryOnBecomesReachable], will actually return [rxReturnOnError] var if we dont have internet connection
           BUT ALSO, if the requests fails on [observer.onError], the subscriber will receive [rxReturnOnError]
             on event [onNext]. If we dont have the [retryOnBecomesReachable], the subscriber will receive the error on [onError] */
        .retryOnBecomesReachable(rxReturnOnError, reachabilityService: _rxReachabilityService)
    }
}

//
//MARK: Auxiliar
//
extension AppView.RxTesting {
    
    func aux_prepare() {
        self.view.backgroundColor = AppColors.appDefaultBackgroundColor
        _topGenericView.lazyLoad()
        _searchBar.lazyLoad()
        _btnThrottle.lazyLoad()
        _btnDebounce.lazyLoad()
        _btnRxRelays.lazyLoad()
        _tableView.lazyLoad()
        _lblTitle1.lazyLoad()
        _lblTitle2.lazyLoad()
    }
    
    func aux_log(message:String, showAlert:Bool, appendToTable:Bool) {
        _searchBar.resignFirstResponder()
        print("\(message)")
        if(appendToTable) {
            let time = "\(Date.utcNow().hours):\(Date.utcNow().minutes):\(Date.utcNow().seconds)"
            _rxBehaviorRelay_tableDataSource.accept(["\(time) : \(message)"] + _rxBehaviorRelay_tableDataSource.value)
        }
        if(showAlert) {
            displayMessage(message, type: .sucess)
        }
    }
}
