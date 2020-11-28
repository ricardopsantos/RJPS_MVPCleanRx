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

        view.addSubview(scrollView)
        //scrollView.addSubview(stackViewVLevel1)
        scrollView.uiUtils.addStackView(stackViewVLevel1)
        scrollView.autoLayout.trailingToSuperview()
        scrollView.autoLayout.leftToSuperview()
        scrollView.autoLayout.topToSuperview(offset: 0, usingSafeArea: false)
        scrollView.autoLayout.height(screenHeight)

        stackViewVLevel1.uiUtils.addSeparator()

        stackViewVLevel1.uiUtils.addSection(title: "Labels")
        let labelWithPadding = UIKitFactory.labelWithPadding(title: "Label with padding", style: .title)
        labelWithPadding.backgroundColor = ComponentColor.primary.withAlphaComponent(FadeType.heavy.rawValue)
        stackViewVLevel1.uiUtils.addSubviewSmart(labelWithPadding)

        stackViewVLevel1.uiUtils.addSection(title: "Switch")
        let switchWithCaption = UIKitFactory.switchWithCaption(caption: "Switch With Caption")
        stackViewVLevel1.uiUtils.addSubviewSmart(switchWithCaption)

        stackViewVLevel1.uiUtils.addSection(title: "Buttons")
        let raisedButton = UIKitFactory.raisedButton(title: "Raised Button", backgroundColor: ComponentColor.primary)
        stackViewVLevel1.uiUtils.addSubviewSmart(raisedButton)

        stackViewVLevel1.uiUtils.addSection(title: "SkyFloatingTextField")
        let skyFloatingLabelTextField = UIKitFactory.skyFloatingTextField(title: "title", placeholder: "placeholder")
        stackViewVLevel1.uiUtils.addSubviewSmart(skyFloatingLabelTextField)

        stackViewVLevel1.uiUtils.addSection(title: "Images")
        let avatarView = AvatarView()
        avatarView.setup(viewModel: AvatarView.ViewModel(imageName: "avatar.1"))
        stackViewVLevel1.uiUtils.addSubviewCentered(avatarView)
        avatarView.autoLayout.width(50)
        avatarView.autoLayout.height(50)

        let imageViewWithRoundedShadow = ImageViewWithRoundedShadow()
        imageViewWithRoundedShadow.image = UIImage(named: "notFound")
        stackViewVLevel1.uiUtils.addSubviewCentered(imageViewWithRoundedShadow)
        imageViewWithRoundedShadow.autoLayout.width(200)
        imageViewWithRoundedShadow.autoLayout.height(100)

        stackViewVLevel1.uiUtils.addSubviewSmart(UIView())

        //DevTools.DebugView.paint(view: self.view)
        /*
        let animationView = AnimationView(name: "23038-animatonblue")
        view.addSubview(animationView)
        animationView.autoLayout.topToBottom(of: imageViewWithRoundedShadow, offset: offset)
        animationView.autoLayout.leadingToSuperview(offset: offset)
        animationView.autoLayout.trailingToSuperview(offset: offset)
        animationView.autoLayout.height(200)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
*/
    }
}

class DesignablesPreviewView: UIView {
    public init() {
        super.init(frame: .zero)
        setupView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
/*
        stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

        let raisedButton = UIKitFactory.raisedButton(title: "raisedButton", backgroundColor: ComponentColor.primary)
        stackViewVLevel1.uiUtils.safeAddArrangedSubview(raisedButton)

        stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)

        let skyFloatingLabelTextField = UIKitFactory.skyFloatingLabelTextField(title: "skyFloatingLabelTextField",
                                                                               placeholder: "Your skyFloatingLabelTextField")
        stackViewVLevel1.uiUtils.safeAddArrangedSubview(skyFloatingLabelTextField)

        stackViewVLevel1.uiUtils.addArrangedSeparator(withSize: 1, color: sectionSmallSeparatorColor)
 */
    }
}
