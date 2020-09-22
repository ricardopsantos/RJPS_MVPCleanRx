//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class DIAssemblerScenes {
    
    class var assembler: Assembler {
        let assemblyList: [Assembly] = [
            DIAssemblyContainerCore(),
            DIAssemblyContainerCarTrack(),
            DIAssemblyContainerGalleryApp()
        ]
        return Assembler(assemblyList)
    }
}
