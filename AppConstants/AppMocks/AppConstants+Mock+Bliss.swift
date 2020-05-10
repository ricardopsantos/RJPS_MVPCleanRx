//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib

// swiftlint:disable line_length

extension AppConstants.Mocks {

    public struct Bliss {
        public static var getQuestions_200: String {
            return """
             {
               "id": 1,
               "image_url": "https://dummyimage.com/600x400/000/fff.png&text=question+1+image+(600x400)",
               "thumb_url": "https://dummyimage.com/120x120/000/fff.png&text=question+1+image+(120x120)",
               "question": "Favourite programming language?",
               "published_at": "2015-08-05T08:40:51.620Z",
               "choices": [
                 {
                   "choice": "Swift",
                   "votes": 1
                 },
                 {
                   "choice": "Python",
                   "votes": 0
                 },
                 {
                   "choice": "Objective-C",
                   "votes": 0
                 },
                 {
                   "choice": "Ruby",
                   "votes": 0
                 }
               ]
             }
             """
                }
        }
    }
