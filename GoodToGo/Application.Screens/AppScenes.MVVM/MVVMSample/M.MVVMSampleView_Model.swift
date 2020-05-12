//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

//
// MARK: - UserTableViewCell
//

extension M {

    public class MVVMSampleView {
        public enum Rarity {
            case common
            case uncommon
            case rare
            case veryRare
        }
        
        public let name: String
        public let birthday: Date
        public let rarity: Rarity
        public let image: UIImage
        
        public init(name: String,
                    birthday: Date,
                    rarity: Rarity,
                    image: UIImage) {
            self.name = name
            self.birthday = birthday
            self.rarity = rarity
            self.image = image
        }
    }
}

extension M.MVVMSampleView {
    static func makeOne(name: String) -> M.MVVMSampleView {
        let birthday = Date.utcNow.add(days: -2*360)
        let image    = UIImage(named: "notInternet")!
        return M.MVVMSampleView(name: name, birthday: birthday, rarity: .veryRare, image: image)
    }
}
