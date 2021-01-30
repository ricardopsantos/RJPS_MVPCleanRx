//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RxSwift
import RJSLibUFBase
//
import BaseDomain

// Must be open in order to be heritaded
open class OperationBase: Operation {
    private var _executing = false {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    public override var isExecuting: Bool { return _executing }
    private var _finished = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    public override var isFinished: Bool { return _finished }
    public func executing(_ executing: Bool) { _executing = executing }
    public func finish(_ finished: Bool) { _finished = finished }
}

public class APIRequestOperation<T: ResponseDtoProtocol>: OperationBase {

    private var block: Observable<T>?
    private var blockList: Observable<[T]>?
    private var disposeBag = DisposeBag()

    public var result: T?
    public var resultList: [T]?
    
    public init(block: Observable<T>) {
      self.block = block
    }

    public init(blockList: Observable<[T]>) {
      self.blockList = blockList
    }

    public var noResultAvailable: Bool {
        return result == nil && resultList == nil
    }

    public override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)

        if let block = block {
            block.asObservable().bind { (some) in
                self.result = some
                self.executing(false)
                self.finish(true)
            }.disposed(by: disposeBag)
        }

        if let blockList = blockList {
            blockList.asObservable().bind { (some) in
                self.resultList = some
                self.executing(false)
                self.finish(true)
            }.disposed(by: disposeBag)
        }
    }
}
