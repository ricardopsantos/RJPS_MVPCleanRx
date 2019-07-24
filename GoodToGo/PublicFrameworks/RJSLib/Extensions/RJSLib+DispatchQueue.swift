//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension RJSLibExtension where Target == DispatchQueue {
    
    static let defaultDelay : Double = 0.3

    enum Tread { case main, background }
    
    private static var _onceTracker = [String]()
    static func onceTrackerClean() -> Void {
        RJSLib.Logs.DLogWarning("DispatchQueue._onceTracker cleanned")
        _onceTracker = []
    }
    
    func synced(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    @discardableResult static func executeOnce(token: String, block:()->Void) -> Bool {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard !_onceTracker.contains(token) else { return false }
        _onceTracker.append(token)
        block()
        return true
    }
    
    static func executeWithDelay(tread:Tread=Tread.main, delay:Double=defaultDelay, block:@escaping ()->()) {
        if(tread == .main) { DispatchQueue.main.asyncAfter(deadline: .now() + delay) { block() } }
        else { DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: .now() + delay) { block() } }
    }
    
    static func executeIn(tread:Tread, block:@escaping ()->Void) {
        if(tread == .main) { inMainTread(block); }
        else { inBackgroundTread(block); }
    }

    static func inMainTread(_ block:@escaping ()->Void) {
        DispatchQueue.main.async(execute: { block() })
    }
  
    static func inBackgroundTread(_ block:@escaping ()->Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { block(); })
    }
    
}
