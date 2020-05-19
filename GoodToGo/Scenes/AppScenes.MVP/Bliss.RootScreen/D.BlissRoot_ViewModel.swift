//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit

import Domain
import Domain_Bliss

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

public extension VM {
    struct BlissRoot_ViewModel {
        var questionsList: [Bliss.QuestionElementResponseDto] = []
    }
}
