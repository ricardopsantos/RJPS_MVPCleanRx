//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
/*
typealias KeyboardEventAction = (CGRect) -> ()

fileprivate var _keyboardManager = RJSLib.KeyboardManager()

protocol KeyboardDelegate: class {
    func keyboardWillShow(with keyboardFrame: CGRect)
    func keyboardWillHide(with keyboardFrame: CGRect)
}

extension RJSLib {
    
    class KeyboardManager {
        
        private var listenersWillShow = [String: KeyboardEventAction]()
        private var listenersWillHide = [String: KeyboardEventAction]()
        
        class var shared: RJSLib.KeyboardManager { return _keyboardManager }
        
        deinit { Typist.shared.stop() }
        
        fileprivate init() {
            Typist.shared.on(event: .willShow, do: { (options) in
                UIView.animate(withDuration: options.animationDuration, delay: 0, options: .curveEaseOut, animations: {
                    self.listenersWillShow.values.forEach { $0(options.endFrame) }
                })
            }).on(event: .willHide, do: { (options) in
                UIView.animate(withDuration: options.animationDuration, delay: 0, options: .curveEaseOut, animations: {
                    self.listenersWillHide.values.forEach { $0(options.endFrame) }
                })
            }).start()
        }
        
        func register<T>(target: T.Type, willShow: @escaping KeyboardEventAction) {
            self.listenersWillShow[String(describing: target)] = willShow
        }
        
        func register<T>(target: T.Type, willHide: @escaping KeyboardEventAction) {
            self.listenersWillHide[String(describing: target)] = willHide
        }
        
        func unregister<T>(target: T.Type) {
            let lock = NSLock()
            lock.lock()
            let key = String(describing: target)
            self.listenersWillHide.removeValue(forKey: key)
            self.listenersWillShow.removeValue(forKey: key)
            lock.unlock()
        }
    }

}
*/
