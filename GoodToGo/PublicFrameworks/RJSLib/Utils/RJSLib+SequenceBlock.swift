//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

typealias CallbackSimple = () -> ()
typealias ResponseCallback<T> = (T) -> ()

extension RJSLib {
    class SequenceBlock {
        
        private let dispatchGroup = DispatchGroup()
        private var hasError = false
        private var numRequests: Int = 0
        
        private var operationsStack = [CallbackSimple]()
        
        private var before: CallbackSimple?
        private var after : CallbackSimple?
        
        var description: String { return "Has Errors: \(self.hasError)\nNum Requests: \(self.numRequests)" }
        
        func errorCallback(_ message: String? = nil) -> CallbackSimple {
            return {
                self.fail()
            }
        }
        
        @discardableResult
        func operation(callback: @escaping CallbackSimple) -> SequenceBlock {
            self.operationsStack.append(callback)
            return self
        }
        
        @discardableResult
        func before(_ callback: @escaping CallbackSimple) -> SequenceBlock {
            self.before = callback
            return self
        }
        
        @discardableResult
        func after(_ callback: @escaping CallbackSimple) -> SequenceBlock {
            self.after = callback
            return self
        }
        
        private func executeOperations() {
            if self.operationsStack.count > 0  &&  !self.hasError {
                self.numRequests += 1
                self.dispatchGroup.enter()
                self.operationsStack.removeFirst()()
            }
        }
        
        func success() {
            self.numRequests -= 1
            self.executeOperations()
            self.dispatchGroup.leave()
        }
        
        func fail() {
            self.numRequests -= 1
            self.hasError = true
            self.dispatchGroup.leave()
        }
        
        @discardableResult
        func waitAll(onSuccess: @escaping CallbackSimple, onError: @escaping CallbackSimple) -> SequenceBlock {
            self.before?()
            self.executeOperations()
            self.dispatchGroup.notify(queue: .main) {
                guard self.numRequests == 0 else { return }
                if self.hasError { onError() }
                else { onSuccess() }
                self.after?()
            }
            return self
        }
    }

}

