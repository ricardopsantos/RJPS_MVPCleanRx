//
//  GoodToGo
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
        public static func startTimmerWith(identifier: String="") {
            _times[identifier] = CFAbsoluteTimeGetCurrent()
        }
        
        public static func timeElapsed(identifier: String="", print: Bool) -> Double {
            if let time = _times[identifier] {
                let timeElapsed = CFAbsoluteTimeGetCurrent() - time
                if print {
                    RJS_Logs.message("Operation [\(identifier)] time : \(Double(timeElapsed))" as AnyObject)
                }
                return Double(timeElapsed)
            }
            return 0
        }
        
    }
    
}
