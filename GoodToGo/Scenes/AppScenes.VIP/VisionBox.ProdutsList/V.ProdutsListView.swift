//
//  V.ProdutsListView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
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

// MARK: - Preview

@available(iOS 13.0.0, *)
struct ProdutsListView_UIViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: V.ProdutsListView, context: Context) { }
    func makeUIView(context: Context) -> V.ProdutsListView {
        let view = V.ProdutsListView()
        view.profiles = [
            ProductModel(name: "1 Thor", location: "Boston", imageName: "astronomy", profession: "astronomy"),
            ProductModel(name: "Mike", location: "Albequerque", imageName: "basketball", profession: "basketball"),
            ProductModel(name: "Walter White", location: "New Mexico", imageName: "chemistry", profession: "chemistry"),
            ProductModel(name: "Sam Brothers", location: "California", imageName: "geography", profession: "geography"),
            ProductModel(name: "Chopin", location: "Norway", imageName: "geometry", profession: "geometry"),
            ProductModel(name: "Castles", location: "UK", imageName: "history", profession: "history"),
            ProductModel(name: "Dr. Johnson", location: "Australia", imageName: "microscope", profession: "microscope"),
            ProductModel(name: "Tom Hanks", location: "Bel Air", imageName: "theater", profession: "theater")
        ]
        return view
    }
}

@available(iOS 13.0.0, *)
struct ProdutsListView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ProdutsListView_UIViewRepresentable()
    }
}

// MARK: - View

extension V {
    class ProdutsListView: BaseGenericViewVIP {

        var profiles: [ProductModel] = [] {
            didSet {
                collectionView.reloadData()
            }
        }

         private let collectionView: UICollectionView = {
             let viewLayout = UICollectionViewFlowLayout()
             viewLayout.scrollDirection = .horizontal
             let some = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
             return some
         }()

         private enum LayoutConstant {
             static let spacing: CGFloat = 16.0
             static let itemHeight: CGFloat = 300.0
         }

        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI Elements (Private and lazy by default)

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(collectionView)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            collectionView.edgesToSuperview(usingSafeArea: true)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(ProductCollectioViewCell.self, forCellWithReuseIdentifier: ProductCollectioViewCell.identifier)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = AppColors.backgroundColor
            collectionView.backgroundColor = .white
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // MARK: - Custom Getter/Setters

        // We can set the view data by : 1 - Rx                                     ---> var rxTableItems = BehaviorRelay <---
        // We can set the view data by : 2 - Custom Setters / Computed Vars         ---> var subTitle: String <---
        // We can set the view data by : 3 - Passing the view model inside the view ---> func setupWith(viewModel: ... <---

        func setupWith(someStuff viewModel: VM.ProdutsList.Something.ViewModel) {

        }

        func setupWith(screenInitialState viewModel: VM.ProdutsList.ScreenInitialState.ViewModel) {
            screenLayout = viewModel.screenLayout
        }

        var screenLayout: E.ProdutsListView.ScreenLayout = .layoutA {
            didSet {
                // show or hide stuff
            }
        }
    }
}

// MARK: - Events capture

extension V.ProdutsListView {
   /* var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.ProdutsList.TableItem> {
        tableView.rx.modelSelected(VM.ProdutsList.TableItem.self)
    }*/
}

extension V.ProdutsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectioViewCell.identifier, for: indexPath) as! ProductCollectioViewCell

        let profile = profiles[indexPath.row]
        cell.setup(with: profile)
        cell.contentView.backgroundColor = .red
        return cell
    }
}

extension V.ProdutsListView {

}

extension V.ProdutsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: self.frame.width, spacing: LayoutConstant.spacing)
        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}

struct ProductModel {
    let name: String
    let location: String
    let imageName: String
    let profession: String
}

final class ProductCollectioViewCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 180.0

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let name: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let professionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(profileImageView)
        contentView.addSubview(name)
        contentView.addSubview(locationLabel)
        contentView.addSubview(professionLabel)
    }

    private func setupLayouts() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        professionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `profileImageView`
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for `usernameLabel`
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

        // Layout constraints for `descriptionLabel`
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            locationLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4.0)
        ])

        // Layout constraints for `matchLabel`
        NSLayoutConstraint.activate([
            professionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            professionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            professionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8.0),
            professionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.profileDescriptionVerticalPadding)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with profile: ProductModel) {
        profileImageView.image = UIImage(named: profile.imageName)
        name.text = profile.name
        locationLabel.text = profile.location
        professionLabel.text = profile.profession
    }
}
