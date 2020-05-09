//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import AppDomain

protocol BlissQuestionsAPI_UseCaseProtocol: class {
    func getHealth(completionHandler: @escaping (_ result: Result<Bliss.ServerHealth>) -> Void)
    func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth: Bool, completionHandler: @escaping (Result<[Bliss.QuestionElement]>) -> Void)
    func getQuestionBy(id: Int, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElement>) -> Void)
    func makeQuestion(question: Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElement>) -> Void)
    func updateQuestion(question: Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElement>) -> Void)
    func shareQuestionBy(email: String, url: String, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.ShareByEmail>) -> Void)
    
}
