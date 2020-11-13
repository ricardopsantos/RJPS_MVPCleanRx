//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

/**
 * Não associar a nenhuma class! Assim estão acessiveis a partir de qualquer ponto da aplicação.
 * Usar apenas para funcoes muito importantes!
 */

//import UIKit

private func synced<T>(_ lock: Any, closure: () -> T) -> T {
    objc_sync_enter(lock)
    let r = closure()
    objc_sync_exit(lock)
    return r
}

extension RJSLib {
    public struct Cronometer {
        
        /**
         * RJSCronometer.printTimeElapsedWhenRunningCode("nthPrimeNumber")
         * {
         *    log(RJSCronometer.nthPrimeNumber(10000))
         * }
         */
        public static func printTimeElapsedWhenRunningCode(_ title: String, operation: () -> Void) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            Logger.message("Time elapsed for \(title): \(timeElapsed) s")
            return timeElapsed
        }
        
        public static func timeElapsedInSecondsWhenRunningCode(_ operation:() -> Void) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            return Double(timeElapsed)
        }
        
        private static var _times: [String: CFAbsoluteTime] = [:]
        public static func startTimerWith(identifier: String="") {
            synced(_times) {
                _times.removeValue(forKey: identifier)
                _times[identifier] = CFAbsoluteTimeGetCurrent()
            }
        }
        
        public static func timeElapsed(identifier: String="", print: Bool) -> Double? {
            var result: Double?
            synced(_times) {
                if let time = _times[identifier] {
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - time
                    if print {
                        RJS_Logs.message("Operation [\(identifier)] time : \(Double(timeElapsed))" as AnyObject)
                    }
                    result = Double(timeElapsed)
                }
            }
            return result ?? 0
        }

        public static func remove(identifier: String) {
            _ = synced(_times) {
                _times.removeValue(forKey: identifier)
            }
        }
        
    }
    
}
