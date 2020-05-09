//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol GenericTableViewCell_Protocol: ReusableCell_Protocol {
    func set(title: String)     // Mandatory
    func set(image: UIImage?)
    func set(textColor: UIColor)
}

extension GenericTableViewCell_Protocol {
    func set(image: UIImage?) { }
    func set(textColor: UIColor) { }
}

public protocol ReusableCell_Protocol {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell_Protocol {
    static var reuseIdentifier: String { return String(describing: self)+".\(AppConstants.Dev.cellIdentifier)" }
}
