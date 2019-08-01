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

protocol Pet_ViewModelProtocol {
    var name: String { get }
    var image: UIImage { get }
    var ageText: String { get }
    var adoptionFeeText: String { get }
    var sampleUseCase: Sample_UseCaseProtocol! { get }
}

protocol Pet_ViewProtocol {
    var petView: V.Pet_View { get }
    var viewModel : Pet_ViewModelProtocol? { get set }
}

extension VM {

    public class Pet_ViewModel : Pet_ViewModelProtocol {
        
        private var _pet: M.Pet?
        private var _calendar: Calendar?
        var sampleUseCase : Sample_UseCaseProtocol!

        public init() {
            _pet = nil
            _calendar = nil
        }
        
        public init(pet: M.Pet?) {
            guard pet != nil else {
                return
            }
            self._pet = pet
            self._calendar = Calendar(identifier: .gregorian)
        }
        
        // 2
        public var name : String { return _pet?.name ?? "" }
        public var image: UIImage {
            print(sampleUseCase)
            //sampleUseCase.operation1(canUseCache: true) { (result) in
            //    print(result)
            //}
            return _pet?.image ?? UIImage()
        }
        
        // 3
        public var ageText: String {
            guard let calendar = _calendar, let pet = _pet else { return "" }
            let today      = calendar.startOfDay(for: Date())
            let birthday   = calendar.startOfDay(for: pet.birthday )
            let components = calendar.dateComponents([.year], from: birthday, to: today)
            return "\(components.year!) years old"
        }
        
        // 4
        public var adoptionFeeText: String {
            guard _pet != nil else { return "" }
            switch _pet!.rarity {
            case .common   : return "$50.00"
            case .uncommon : return "$75.00"
            case .rare     : return "$150.00"
            case .veryRare : return "$500.00"
            }
        }
    }
}
