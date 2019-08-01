//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

extension VC {

    public class Pet_ViewController : GenericView {

        lazy var petView: V.Pet_View = {
            let some = V.Pet_View()
            self.view.addSubview(some)
            let margin : CGFloat = 50
            some.rjsALayouts.setMarginFromSuper(top: margin, bottom: margin, left: margin, right: margin)
            return some
        }()
  
        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = AppConstants_UITests.UIViewControllers.genericAccessibilityIdentifier(self)
            prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor.withAlphaComponent(0.5)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            prepareLayout()
        }
        
        override func prepareLayout() {
            super.prepareLayout()

            let birthday = Date.utcNow().add(days: -2*360)
            let image    = UIImage(named: "notInternet")!
            let somePet = M.Pet(name: "Stuart", birthday: birthday, rarity: .veryRare, image: image)
            
            // 2
            let viewModel : Pet_ViewModelProtocol = VM.Pet_ViewModel(pet: somePet)
            
            // 4
            petView.lblName.text        = viewModel.name
            petView.imageView.image     = viewModel.image
            petView.lblAge.text         = viewModel.ageText
            petView.lblAdoptionFee.text = viewModel.adoptionFeeText
            
        }
    }
   
}
