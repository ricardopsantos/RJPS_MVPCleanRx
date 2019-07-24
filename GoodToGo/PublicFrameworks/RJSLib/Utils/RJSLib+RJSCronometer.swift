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
    public struct RJSCronometer {
        
        public static func nthPrimeNumber(_ nth: Int) -> Int {
            return -1
        }
        
        /**
         * RJSCronometer.printTimeElapsedWhenRunningCode("nthPrimeNumber")
         * {
         *    print(RJSCronometer.nthPrimeNumber(10000))
         * }
         */
        public static func printTimeElapsedWhenRunningCode(_ title:String, operation:()->()) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            NSLog("Time elapsed for \(title): \(timeElapsed) s")
            return timeElapsed
        }
        
        public static func timeElapsedInSecondsWhenRunningCode(_ operation:()->()) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            return Double(timeElapsed)
        }
        
        private static var _times : [String:CFAbsoluteTime] = [:]
        public static func startTimmerWith(id:String="") {
            _times[id] = CFAbsoluteTimeGetCurrent()
        }
        
        public static func timeElapsed(id:String="", print:Bool) -> Double {
            if let time = _times[id] {
                let timeElapsed = CFAbsoluteTimeGetCurrent() - time
                if(print) {
                    RJS_Logs.DLog("Operation [\(id)] time : \(Double(timeElapsed))" as AnyObject)
                }
                return Double(timeElapsed)
            }
            return 0
        }
        
    }

}




