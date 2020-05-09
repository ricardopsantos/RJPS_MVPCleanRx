//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

protocol BlissQuestionsAPI_UseCaseProtocol: class {
    func getHealth(completionHandler: @escaping (_ result: Result<E.Bliss.ServerHealth>) -> Void)
    func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth: Bool, completionHandler: @escaping (Result<[E.Bliss.QuestionElement]>) -> Void)
    func getQuestionBy(id: Int, checkHealth: Bool, completionHandler: @escaping (_ result: Result<E.Bliss.QuestionElement>) -> Void)
    func makeQuestion(question: E.Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (_ result: Result<E.Bliss.QuestionElement>) -> Void)
    func updateQuestion(question: E.Bliss.QuestionElement, checkHealth: Bool, completionHandler: @escaping (_ result: Result<E.Bliss.QuestionElement>) -> Void)
    func shareQuestionBy(email: String, url: String, checkHealth: Bool, completionHandler: @escaping (_ result: Result<E.Bliss.ShareByEmail>) -> Void)
    
}
