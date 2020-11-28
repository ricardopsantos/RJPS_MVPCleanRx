//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import Lottie
//
import AppResources

#warning("Put on UIKitFactory")

open class LottieView: UIView {

    let animationView = AnimationView(name: "23038-animatonblue")

    public struct ViewModel {
        public let imageName: String?

        public init(imageName: String?) {
            self.imageName = imageName
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    public func setupViewIn(view: UIView) {
        // https://lottiefiles.com/blog/working-with-lottie/how-to-add-lottie-animation-ios-app-swift
        view.addSubview(self)
        self.addSubview(animationView)
        self.edgesToSuperview()
        animationView.autoLayout.edgesToSuperview()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
    }

    public func play() {
        animationView.play()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(viewModel: LottieView.ViewModel) {
       /* if let image = viewModel.image {
            imgAvatar.image = image
        } else if let imageName = viewModel.imageName, let image = UIImage(named: imageName) {
            imgAvatar.image = image
        } else {
            imgAvatar.image = Images.notFound.image
        }*/
    }
}
