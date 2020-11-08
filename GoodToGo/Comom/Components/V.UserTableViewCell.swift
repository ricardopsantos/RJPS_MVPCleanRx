//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import Designables
import UIBase

//
// MARK: - UserTableViewCell
//

extension V {
    class UserTableViewCell: DefaultTableViewCell {
        public override class var cellSize: CGFloat {
            return Designables.Sizes.TableView.defaultHeightForCell
        }
    }
}
