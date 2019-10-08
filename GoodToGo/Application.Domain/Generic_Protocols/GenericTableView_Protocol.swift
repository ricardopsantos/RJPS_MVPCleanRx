//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

protocol GenericTableView_Protocol : class {
    func configure(cell:GenericTableViewCell_Protocol, indexPath: IndexPath) -> Void
    func numberOfRows(_ section:Int) -> Int
    func didSelectRowAt(indexPath: IndexPath) -> Void
    func numberOfSections() ->Int
    func didSelect(object:Any) -> Void
}

extension GenericTableView_Protocol {
    func numberOfRows(_ section:Int) -> Int { return 0 }
    func numberOfSections() ->Int { return 1 }
    func didSelect(object:Any) -> Void { }
    func didSelectRowAt(indexPath: IndexPath) -> Void { }
}
