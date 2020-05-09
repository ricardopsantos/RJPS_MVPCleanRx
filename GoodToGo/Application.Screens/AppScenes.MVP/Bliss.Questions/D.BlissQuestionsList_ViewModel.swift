//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import AppDomain

/*
 * Needs to added AS.Sample_AssemblyContainer() to DependencyInjectionManager.swift
 */

public extension VM {
    struct BlissQuestionsList_ViewModel {
        var questionsList: [Bliss.QuestionElementResponseDto] = []
        var search: String = ""
    }
}
