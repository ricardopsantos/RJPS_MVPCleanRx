//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

protocol Bliss_NetWorkRepositoryProtocol : class {
    func getHealth(completionHandler: @escaping (_ result: Result<NetworkClientResponse<E.Bliss.ServerHealth>>) -> Void)
    func getQuestions(limit:Int, filter:String, offSet:Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<[E.Bliss.QuestionElement]>>) -> Void)
    func getQuestionBy(id:Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void)
    func makeQuestion(question:E.Bliss.QuestionElement, completionHandler: @escaping (_ result: Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void)
    func updateQuestion(question:E.Bliss.QuestionElement, completionHandler: @escaping (_ result: Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void)
    func shareQuestionBy(email:String, url:String, completionHandler: @escaping (_ result: Result<NetworkClientResponse<E.Bliss.ShareByEmail>>) -> Void)
}
