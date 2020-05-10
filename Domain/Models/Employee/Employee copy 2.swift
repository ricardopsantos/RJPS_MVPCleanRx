//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

extension Employee {
    public struct ResponseDto: Codable {
        public let id, employeeName, employeeSalary, employeeAge: String
        public let profileImage: String
        enum CodingKeys: String, CodingKey {
            case id
            case employeeName   = "employee_name"
            case employeeSalary = "employee_salary"
            case employeeAge    = "employee_age"
            case profileImage   = "profile_image"
        }
    }
}
