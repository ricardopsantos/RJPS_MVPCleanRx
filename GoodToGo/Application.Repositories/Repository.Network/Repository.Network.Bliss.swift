//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

extension RP.Network {
    struct Bliss {
        private init() {}
    }
}

extension RP.Network.Bliss {
    class NetWorkRepository: Bliss_NetWorkRepositoryProtocol {
 
        func shareQuestionBy(email: String, url: String, completionHandler: @escaping (Result<NetworkClientResponse<E.Bliss.ShareByEmail>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.Share_APIRequest(email: email, url: url)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.Bliss.ShareByEmail>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func updateQuestion(question: E.Bliss.QuestionElement, completionHandler: @escaping (Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.UpdateQuestion_APIRequest(question: question)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.Bliss.QuestionElement>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func makeQuestion(question: E.Bliss.QuestionElement, completionHandler: @escaping (Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.NewQuestion_APIRequest(question: question)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.Bliss.QuestionElement>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getQuestionBy(id: Int, completionHandler: @escaping (Result<NetworkClientResponse<E.Bliss.QuestionElement>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.QuestionById_APIRequest(id: id)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.Bliss.QuestionElement>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getQuestions(limit:Int, filter:String, offSet:Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<[E.Bliss.QuestionElement]>>) -> Void) {
            do {
             
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.ListQuestions_APIRequest(limit: limit, filter:filter, offSet:offSet)
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<[E.Bliss.QuestionElement]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getHealth(completionHandler: @escaping (Result<NetworkClientResponse<E.Bliss.ServerHealth>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.GetHealthStatus_APIRequest()
                let apiClient : NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result : Result<NetworkClientResponse<E.Bliss.ServerHealth>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
