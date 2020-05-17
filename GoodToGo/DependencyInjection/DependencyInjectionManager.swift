//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class ApplicationAssembly {
    
    class var assembler: Assembler {
        let assemblyList: [Assembly] = [
            RootAssemblyContainer(),
            AS.SearchUser_AssemblyContainer(),
            AS.UserDetails_AssemblyContainer(),
            AS.MVPSampleView_AssemblyContainer(),
            AS.MVPSampleRxView_AssemblyContainer(),
            AS.MVPSampleTableView_AssemblyContainer(),
            
            AS.BlissQuestionsList_AssemblyContainer(),
            AS.BlissRoot_AssemblyContainer(),
            AS.BlissDetails_AssemblyContainer()

        ]
        return Assembler(assemblyList)
    }
}
