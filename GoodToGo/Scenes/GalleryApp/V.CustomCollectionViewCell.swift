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
import Domain_VisionBox
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

        static let defaultHeight: CGFloat = screenHeight * 0.3
        static let defaultWidth: CGFloat  = screenWidth * 0.3
        var worker = GalleryAppResolver.shared.worker
        var disposeBag = DisposeBag()

        static var identifier: String {
            return String(describing: self)
        }

        private lazy var imgProduct: UIImageView = {
            UIKitFactory.imageView()
        }()

        override init(frame: CGRect) {
            super.init(frame: .zero)
            setupView()
        }

        private func setupView() {
            let cellColor = UIColor.white.withAlphaComponent(0.4)
            contentView.clipsToBounds = true
            contentView.layer.cornerRadius = 10
            contentView.addShadow()

            contentView.addSubview(imgProduct)
            imgProduct.autoLayout.edgesToSuperview()
            imgProduct.contentMode = .scaleAspectFit
            imgProduct.addShadow()

            contentView.backgroundColor = cellColor
            self.backgroundColor = cellColor

            #warning("free dispose bag on reuse indentifier")

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(viewModel: VM.GalleryAppS1.TableItem) {
            //let image = UIImage(named: viewModel.productImage)
            imgProduct.image = UIImage(named: viewModel.image)

            #warning("strong reference!")

            let request = GalleryAppRequests.ImageInfo(photoId: viewModel.id)
            self.worker?.imageInfoZip(request, cacheStrategy: .cacheElseLoad).asObservable().subscribe(onNext: { [weak self] (_, image) in
                DispatchQueue.main.async {
                    self!.imgProduct.image = image
                }
            }).disposed(by: self.disposeBag)
        }

    }
}
