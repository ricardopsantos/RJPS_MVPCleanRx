//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class ApplicationScenesAssembly {
    
    class var assembler: Assembler {
        let assemblyList: [Assembly] = [
            CoreAssemblyContainer(),
            CarTrackAssemblyContainer(),
            GalleryAppAssemblyContainer()
        ]
        return Assembler(assemblyList)
    }
}
