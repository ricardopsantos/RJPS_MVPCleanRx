//
//  Preview.swift
//  Designables
//
//  Created by Ricardo Santos on 27/11/2020.
//

import Foundation
import UIKit
import SwiftUI
//
//
import RJSLibUFALayouts
import RxSwift
import RxCocoa
import Lottie
//
import AppResources
import AppTheme
import BaseConstants
import Extensions
import DevTools
import PointFreeFunctions

@available(iOS 13, *)
struct DesignablesPreviewVCPreview: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> DesignablesPreviewVC { return DesignablesPreviewVC() }
    func updateUIViewController(_: DesignablesPreviewVC, context _: Context) { }
}

@available(iOS 13, *)
struct DesignablesPreviewVC_Previews: PreviewProvider {
    static var previews: some View {
        DesignablesPreviewVCPreview()
    }
}

public class DesignablesPreviewVC: UIViewController {

    private lazy var scrollView: UIScrollView = {
        UIKitFactory.scrollView()
    }()

    private lazy var stackViewVLevel1: UIStackView = {
        UIKitFactory.stackView(axis: .vertical)
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.uiUtils.addAndSetup(scrollView: scrollView, stackViewV: stackViewVLevel1, hasTopBar: false)

        view.backgroundColor = ColorName.background.color

        stackViewVLevel1.uiUtils.addSection(title: "Labels")
        let labelWithPadding = UIKitFactory.labelWithPadding(title: "Label with padding", style: .title)
        labelWithPadding.backgroundColor = ComponentColor.primary.withAlphaComponent(FadeType.heavy.rawValue)
        labelWithPadding.height(30)
        stackViewVLevel1.uiUtils.addSub(view: labelWithPadding)

        stackViewVLevel1.uiUtils.addSection(title: "Switch")
        let switchWithCaption = UIKitFactory.switchWithCaption(caption: "Switch With Caption")
        stackViewVLevel1.uiUtils.addSub(view: switchWithCaption)

        stackViewVLevel1.uiUtils.addSection(title: "Buttons")
        let raisedButton = UIKitFactory.raisedButton(title: "Raised Button", backgroundColor: ComponentColor.primary)
        stackViewVLevel1.uiUtils.addSub(view: raisedButton)

        stackViewVLevel1.uiUtils.addSection(title: "SkyFloatingTextField")
        let skyFloatingLabelTextField = UIKitFactory.skyFloatingTextField(title: "title", placeholder: "placeholder")
        stackViewVLevel1.uiUtils.addSub(view: skyFloatingLabelTextField)

        stackViewVLevel1.uiUtils.addSection(title: "Images")
        let avatarView = AvatarView()
        avatarView.setup(viewModel: AvatarView.ViewModel(imageName: "avatar.1"))
        stackViewVLevel1.uiUtils.addSub(centeredView: avatarView)
        avatarView.autoLayout.width(50)
        avatarView.autoLayout.height(50)

        let imageViewWithRoundedShadow = ImageViewWithRoundedShadow()
        imageViewWithRoundedShadow.image = UIImage(named: "notFound")
        stackViewVLevel1.uiUtils.addSub(centeredView: imageViewWithRoundedShadow)
        imageViewWithRoundedShadow.autoLayout.width(100)
        imageViewWithRoundedShadow.autoLayout.height(100)

        let animationView = AnimationView(name: "23038-animatonblue")
        stackViewVLevel1.uiUtils.addSub(centeredView: animationView)
        animationView.autoLayout.height(200)
        animationView.autoLayout.width(200)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()

        //DevTools.DebugView.paint(view: self.view)

    }
}
