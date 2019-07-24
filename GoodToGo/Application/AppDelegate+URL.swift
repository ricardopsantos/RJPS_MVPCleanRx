//
//  Created by Ricardo Santos on 11/02/16.
//  Copyright © 2016 InnoWave. All rights reserved.
//

import UIKit
//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import RJPSLib

extension AppDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        AppLogs.DLog("App is handling URL : \(url)")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        AppLogs.DLog("App is opening URL [\(url)] with option [\(options)]")
        
        var blissGenericAppBussiness_UseCase : BlissGenericAppBussiness_UseCaseProtocol { return container.resolve(AppProtocols.blissGenericAppBussiness_UseCase)! }
        
        blissGenericAppBussiness_UseCase.handle(url: url)
        return true
    }
    
}



