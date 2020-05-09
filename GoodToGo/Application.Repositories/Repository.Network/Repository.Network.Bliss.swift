//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import AppDomain

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
 
        func shareQuestionBy(email: String, url: String, completionHandler: @escaping (Result<NetworkClientResponse<Bliss.ShareByEmail>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.Share_APIRequest(email: email, url: url)
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<Bliss.ShareByEmail>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func updateQuestion(question: Bliss.QuestionElementResponseDto, completionHandler: @escaping (Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.UpdateQuestion_APIRequest(question: question)
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func makeQuestion(question: Bliss.QuestionElementResponseDto, completionHandler: @escaping (Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.NewQuestion_APIRequest(question: question)
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getQuestionBy(id: Int, completionHandler: @escaping (Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.QuestionById_APIRequest(id: id)
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getQuestions(limit: Int, filter: String, offSet: Int, completionHandler: @escaping (_ result: Result<NetworkClientResponse<[Bliss.QuestionElementResponseDto]>>) -> Void) {
            do {
             
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.ListQuestions_APIRequest(limit: limit, filter: filter, offSet: offSet)
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<[Bliss.QuestionElementResponseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func getHealth(completionHandler: @escaping (Result<NetworkClientResponse<Bliss.ServerHealth>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Bliss.GetHealthStatus_APIRequest()
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<Bliss.ServerHealth>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
