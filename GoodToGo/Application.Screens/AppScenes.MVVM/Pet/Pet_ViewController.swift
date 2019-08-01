//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

extension VC {

    public class Pet_ViewController : GenericView, Pet_ViewProtocol {

        var viewModel: Pet_ViewModelProtocol?

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
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            prepareLayout()
            self.view.backgroundColor = AppColors.appDefaultBackgroundColor
            petView.lazyLoad()
        }
        
        override func prepareLayout() {
            super.prepareLayout()
        
            if viewModel == nil {
                viewModel = VM.Pet_ViewModel(pet: M.Pet.makeOne(name: "Dog_B"))
            }
            
            if let vm = viewModel {
                petView.lblName.text        = vm.name
                petView.imageView.image     = vm.image
                petView.lblAge.text         = vm.ageText
                petView.lblAdoptionFee.text = vm.adoptionFeeText
            }
        }
    }
   
}
