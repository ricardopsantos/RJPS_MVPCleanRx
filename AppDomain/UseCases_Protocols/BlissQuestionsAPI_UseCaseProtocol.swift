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

public protocol BlissQuestionsAPI_UseCaseProtocol: class {
    func getHealth(completionHandler: @escaping (_ result: Result<Bliss.ServerHealth>) -> Void)
    func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth: Bool, completionHandler: @escaping (Result<[Bliss.QuestionElementResponseDto]>) -> Void)
    func getQuestionBy(id: Int, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElementResponseDto>) -> Void)
    func makeQuestion(question: Bliss.QuestionElementResponseDto, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElementResponseDto>) -> Void)
    func updateQuestion(question: Bliss.QuestionElementResponseDto, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.QuestionElementResponseDto>) -> Void)
    func shareQuestionBy(email: String, url: String, checkHealth: Bool, completionHandler: @escaping (_ result: Result<Bliss.ShareByEmail>) -> Void)
    
}
