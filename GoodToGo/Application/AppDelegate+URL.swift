//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RJPSLib
//
import DevTools
import Domain
import Domain_Bliss

extension AppDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        DevTools.Log.log("App is handling URL : \(url)")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        DevTools.Log.log("App is opening URL [\(url)] with option [\(options)]")
        
        var blissGenericAppBusiness_UseCase: BlissGenericAppBusinessUseCaseProtocol { return container.resolve(AppProtocols.blissGenericAppBusiness_UseCase)! }
        
        blissGenericAppBusiness_UseCase.handle(url: url)
        return true
    }
}
