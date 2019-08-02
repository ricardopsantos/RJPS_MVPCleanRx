//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//
// MARK: - UserTableViewCell
//

protocol Pet_ViewModelProtocol {
    func configure(view: Pet_ViewProtocol)
    var name           : String { get }
    var image          : UIImage { get }
    var ageText        : String { get }
    var adoptionFeeText: String { get }
    var rxPublishSubject_loading: PublishSubject<Bool> { get }
    var rxPublishRelay_needsToUpdate : PublishRelay<String> { get }

}

protocol Pet_ViewControllerProtocol {
    var viewModelView : Pet_ViewProtocol { get }
    var viewModel     : Pet_ViewModelProtocol? { get set }
}

protocol Pet_ViewProtocol {
    var imageView     : UIImageView { get }
    var lblName       : UILabel { get }
    var lblAge        : UILabel { get }
    var lblAdoptionFee: UILabel { get }
}

//
// MARK: - View Model
//

extension VM {
    
    public class Pet_ViewModel {
        
        private var _viewModel : M.Pet?
        private var _calendar: Calendar?
        #warning("Put in assembly containner")
        var sampleUseCase : Sample_UseCaseProtocol = AppDelegate.shared.container.resolve(AppProtocols.sample_UseCase)!
        
        public var rxPublishSubject_loading: PublishSubject<Bool> = PublishSubject()
        public var rxPublishRelay_needsToUpdate : PublishRelay<String>  = PublishRelay<String>()

        public init() {
            _viewModel = nil
            _calendar  = nil
        }
        
        public init(viewModel: M.Pet?) {
            guard viewModel != nil else { return }
            self._viewModel = viewModel
            self._calendar  = Calendar(identifier: .gregorian)
        }
        
    }
}

//
// MARK: - ViewModelProtocol
//

extension VM.Pet_ViewModel : Pet_ViewModelProtocol {
    
    func configure(view: Pet_ViewProtocol) {
        view.lblName.text        = name
        view.imageView.image     = image
        view.lblAge.text         = ageText
        view.lblAdoptionFee.text = adoptionFeeText
        
        DispatchQueue.executeWithDelay (delay:1) { [weak self] in
            self?.rxPublishSubject_loading.onNext(true)
            DispatchQueue.executeWithDelay (delay:2) { [weak self] in
                self?.rxPublishSubject_loading.onNext(false)
                self?.rxPublishRelay_needsToUpdate.accept("")
            }
        }
    }
    
    func getTimage(success: ((UIImage) -> Void)?) {
        success!(AppImages.notInternet)
    }
    
    func userDidTapX() {
        print("Tap!")
    }
    
    var name : String { return _viewModel?.name ?? "" }
    var image: UIImage {
        print(sampleUseCase)
        return _viewModel?.image ?? UIImage()
    }
    
    var ageText: String {
        guard let calendar = _calendar, let viewModel = _viewModel else { return "" }
        let today      = calendar.startOfDay(for: Date())
        let birthday   = calendar.startOfDay(for: viewModel.birthday )
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        return "\(components.year!) years old"
    }
    
    // 4
    var adoptionFeeText: String {
        guard _viewModel != nil else { return "" }
        switch _viewModel!.rarity {
        case .common   : return "$50.00"
        case .uncommon : return "$75.00"
        case .rare     : return "$150.00"
        case .veryRare : return "$500.00"
        }
    }
}

