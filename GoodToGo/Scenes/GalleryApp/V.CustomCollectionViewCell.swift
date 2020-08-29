//
//  GoodToGo
//
//  Created by Ricardo Santos on 26/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources
import Domain_GalleryApp

// MARK: - Preview
/*
@available(iOS 13.0.0, *)
struct ProductPreviewSmallCollectionViewCell_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProductPreviewSmallCollectionViewCell, context: Context) { }
    func makeUIView(context: Context) -> V.ProductPreviewSmallCollectionViewCell {
        let some = V.ProductPreviewSmallCollectionViewCell()
        some.setup(viewModel: VisionBox.ProductModel.mockData.first!)
        return some
    }
}

@available(iOS 13.0.0, *)
struct ProductPreviewSmallCollectionViewCell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProductPreviewSmallCollectionViewCell_UIViewRepresentable()
    }
}*/

// MARK: - View

extension V {
    class CustomCollectionViewCell: UICollectionViewCell {

        func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
            let itemsInRow: CGFloat = 2
            let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
            let finalWidth = (width - totalSpacing) / itemsInRow
            return floor(finalWidth)
        }

        static let defaultMargin: CGFloat = screenWidth * 0.05
        static let defaultHeight: CGFloat = screenWidth * 0.4
        static let defaultWidth: CGFloat  = screenWidth * 0.4
        var worker = GalleryAppResolver.shared.worker
        var disposeBag = DisposeBag()

        static var identifier: String {
            return String(describing: self)
        }

        private lazy var imageView: UIImageView = {
            UIKitFactory.imageView()
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {
            let cellColor = UIColor.clear// UIColor.white.withAlphaComponent(0.4)
            //contentView.clipsToBounds = true
            //contentView.layer.cornerRadius = 10
            contentView.addShadow()

            contentView.addSubview(imageView)
            imageView.autoLayout.edgesToSuperview()
            imageView.contentMode = .scaleAspectFit
            imageView.addShadow()

            contentView.backgroundColor = cellColor
            self.backgroundColor = cellColor

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func set(image: UIImage) {
            UIView.transition(with: imageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.imageView.image = image },
                              completion: nil)
        }

        func setup(viewModel: VM.GalleryAppS1.TableItem) {

            set(image: Images.notFound.image)
            let request = GalleryAppRequests.ImageInfo(photoId: viewModel.id)
            self.worker?.imageInfoZip(request, cacheStrategy: .cacheElseLoad)
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (_, image) in
                    self?.set(image: image)
            }).disposed(by: self.disposeBag)
        }

        override func prepareForReuse() {
            disposeBag = DisposeBag()
        }

    }
}
