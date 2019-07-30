//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//
// Generate by https://app.quicktype.io/
//

extension E.Bliss {
    
    // MARK: - ResponseElement
    struct QuestionElement: Codable {
        let id: Int
        let question: Question
        let imageURL: String
        let thumbURL: String
        let publishedAt: PublishedAt
        let choices: [ChoiceElement]
        
        enum CodingKeys: String, CodingKey {
            case id, question
            case imageURL = "image_url"
            case thumbURL = "thumb_url"
            case publishedAt = "published_at"
            case choices
        }
    }
    

    // MARK: - ChoiceElement
    struct ChoiceElement: Codable {
        let choice: ChoiceEnum
        let votes: Int
    }
    
    enum ChoiceEnum: String, Codable {
        case objectiveC = "Objective-C"
        case python = "Python"
        case ruby = "Ruby"
        case swift = "Swift"
    }
    
    enum PublishedAt: String, Codable {
        case the20150805T084051620Z = "2015-08-05T08:40:51.620Z"
    }
    
    enum Question: String, Codable {
        case favouriteProgrammingLanguage = "Favourite programming language?"
    }
}




extension E.Bliss.QuestionElement {
    static func make() -> E.Bliss.QuestionElement {
        let question = E.Bliss.Question.favouriteProgrammingLanguage
        let choices1 = E.Bliss.ChoiceElement(choice: E.Bliss.ChoiceEnum.python, votes: 0)
        let choices2 = E.Bliss.ChoiceElement(choice: E.Bliss.ChoiceEnum.objectiveC, votes: 0)
        let choices  = [choices1, choices2]
        let imageURL = "www.google.pt"
        let thumbURL = "www.google.pt"
        let questionElement = E.Bliss.QuestionElement(id: 0, question: question, imageURL: imageURL, thumbURL: thumbURL, publishedAt: .the20150805T084051620Z, choices: choices)
        return questionElement
    }
}


extension E.Bliss {

    struct NewQuestionResponse: Codable {
        let id: Int
        let imageURL: String
        let thumbURL: String
        let question, publishedAt: String
        let choices: [Choice]
        
        enum CodingKeys: String, CodingKey {
            case id
            case imageURL = "image_url"
            case thumbURL = "thumb_url"
            case question
            case publishedAt = "published_at"
            case choices
        }
    }
    
    // MARK: - Choice
    struct Choice: Codable {
        let choice: String
        let votes: Int
    }
}
