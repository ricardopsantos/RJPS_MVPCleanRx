//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class ApplicationAssembly {
    
    class var assembler: Assembler {
        let assemblyList: [Assembly] = [
            RootAssemblyContainer(),
            AS.SearchUser_AssemblyContainer(),
            AS.UserDetais_AssemblyContainer(),
            //AS.SampleMinMVP_AssemblyContainer(),
            //AS.SampleMVPWithMethodsAndUseCases_AssemblyContainer(),
            AS.SampleView_AssemblyContainer(),
            AS.SampleTableView_AssemblyContainer(),
            AS.BlissQuestionsList_AssemblyContainer(),
            AS.BlissRoot_AssemblyContainer(),
            AS.BlissDetails_AssemblyContainer()
        ]
        return Assembler(assemblyList)
    }
}
