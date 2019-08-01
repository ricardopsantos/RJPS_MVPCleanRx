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


extension VM {

    public class Pet_ViewModel : Pet_ViewModelProtocol {
        
        private let _pet: M.Pet
        private let _calendar: Calendar
        
        public init(pet: M.Pet) {
            self._pet = pet
            self._calendar = Calendar(identifier: .gregorian)
        }
        
        // 2
        public var name : String { return _pet.name }
        public var image: UIImage { return _pet.image }
        
        // 3
        public var ageText: String {
            let today      = _calendar.startOfDay(for: Date())
            let birthday   = _calendar.startOfDay(for: _pet.birthday)
            let components = _calendar.dateComponents([.year], from: birthday, to: today)
            return "\(components.year!) years old"
        }
        
        // 4
        public var adoptionFeeText: String {
            switch _pet.rarity {
            case .common   : return "$50.00"
            case .uncommon : return "$75.00"
            case .rare     : return "$150.00"
            case .veryRare : return "$500.00"
            }
        }
    }
}
