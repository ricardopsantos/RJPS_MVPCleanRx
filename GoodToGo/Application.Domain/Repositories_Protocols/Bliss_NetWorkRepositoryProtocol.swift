//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

protocol Bliss_NetWorkRepositoryProtocol: class {
    func getHealth(completionHandler: @escaping (_ result: Result<NetworkClientResponse<Bliss.ServerHealth>>) -> Void)
    func getQuestions(limit: Int, filter: String, offSet: Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<[Bliss.QuestionElement]>>) -> Void)
    func getQuestionBy(id: Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<Bliss.QuestionElement>>) -> Void)
    func makeQuestion(question: Bliss.QuestionElement, completionHandler: @escaping (_ result: Result<NetworkClientResponse<Bliss.QuestionElement>>) -> Void)
    func updateQuestion(question: Bliss.QuestionElement, completionHandler: @escaping (_ result: Result<NetworkClientResponse<Bliss.QuestionElement>>) -> Void)
    func shareQuestionBy(email: String, url: String, completionHandler: @escaping (_ result: Result<NetworkClientResponse<Bliss.ShareByEmail>>) -> Void)
}
