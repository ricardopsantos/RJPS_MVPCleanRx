//
//  V.CartTrackMapView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import MapKit
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

//
// INSERT INVISION/ZEPLIN RELATED LAYOUT SCREENS BELOW
//
// Colors WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/378/Colors
// Labels WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/880/Typography
// Icons WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/333/Icons
//

extension V {
    class CartTrackMapView: BaseGenericViewVIP {

        deinit { }

        var rxFilter = BehaviorSubject<String?>(value: nil)

        // MARK: - UI Elements (Private and lazy by default)

        private lazy var mapView: MKMapView = {
            return MKMapView()
        }()

        private lazy var searchBar: CustomSearchBar = {
            return UIKitFactory.searchBar()
        }()

        private lazy var lblResume: UILabel = {
            return UIKitFactory.label(style: .value)
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(mapView)
            addSubview(searchBar)
            addSubview(lblResume)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let edgesToExclude: LayoutEdge = .init([.top, .bottom])
            let defaultMargin = Designables.Sizes.Margins.defaultMargin
            let insets: TinyEdgeInsets = TinyEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)

            lblResume.autoLayout.topToBottom(of: searchBar, offset: Designables.Sizes.Margins.defaultMargin)
            lblResume.autoLayout.width(screenWidth / 4)
            lblResume.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            mapView.autoLayout.topToBottom(of: searchBar)
            mapView.autoLayout.bottomToSuperview()
            mapView.autoLayout.leadingToSuperview()
            mapView.autoLayout.trailingToSuperview()

            searchBar.rjsALayouts.setMargin(TopBar.defaultHeight, on: .top)
            searchBar.autoLayout.leadingToSuperview()
            searchBar.autoLayout.trailingToSuperview()
            searchBar.autoLayout.height(50)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            // Do any additional setup after loading the view, typically from a nib.

            mapView.delegate = self
            lblResume.backgroundColor = lblResume.backgroundColor?.withAlphaComponent(0.5)
            lblResume.addShadow()
            lblResume.addCorner(radius: 5)
            lblResume.textAlignment = .right

        }

        override func setupColorsAndStyles() {
            self.backgroundColor = TopBar.defaultColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {
            searchBar.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    //self.presenter.searchUserWith(username: some.text ?? "")
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: disposeBag)
            searchBar.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    guard self.searchBar.text!.count>0 else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: self.disposeBag)
        }

        // MARK: - Custom Getter/Setters

        func setupWith(mapData viewModel: VM.CartTrackMap.MapData.ViewModel) {
            lblResume.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

        func setupWith(screenInitialState viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel) {
            //subTitle = viewModel.subTitle
            //screenLayout = viewModel.screenLayout
        }

        func setupWith(mapDataFilter viewModel: VM.CartTrackMap.MapDataFilter.ViewModel) {
            lblResume.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

    }
}

// MARK: - Private

extension V.CartTrackMapView {

    func updateMapWith(list: [CarTrack.UserModel]) {

        let lat: CLLocationDegrees =  CLLocationDegrees(Double(list.first!.address.geo.lat)!)
        let lng: CLLocationDegrees =  CLLocationDegrees(Double(list.first!.address.geo.lng)!)
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        list.forEach { (some) in
            let lng: CLLocationDegrees =  CLLocationDegrees(Double(some.address.geo.lat)!)
            let lat: CLLocationDegrees =  CLLocationDegrees(Double(some.address.geo.lng)!)

            print(lat, lng)
            let coordinate = CLLocationCoordinate2DMake(lat, lng)
             let annotation = MKPointAnnotation()
             annotation.coordinate = coordinate
            annotation.title = some.company.name
            annotation.subtitle = some.address.city
             self.mapView.addAnnotation(annotation)
        }
    }

}

// MARK: - MKMapViewDelegate

extension V.CartTrackMapView: MKMapViewDelegate {
    // Called when the region displayed by the map view is about to change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print(#function)
    }

    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.isDraggable = true
            pinView?.pinColor = .purple

            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        } else {
            pinView?.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(#function)
        if control == view.rightCalloutAccessoryView {
            print("toTheMoon")
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            let droppedAt = view.annotation?.coordinate
            print(droppedAt.debugDescription)
        }
    }

    // MARK: - Navigation

    @IBAction func didReturnToMapViewController(_ segue: UIStoryboardSegue) {
        print(#function)
    }
}

// MARK: - Events capture

extension V.CartTrackMapView {
 /*   var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
    var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
    var rxBtnSample3Tap: Observable<Void> { btnSample3.rx.tapSmart(disposeBag) }
    var rxModelSelected: ControlEvent<VM.CartTrackMap.TableItem> {
        tableView.rx.modelSelected(VM.CartTrackMap.TableItem.self)
    }*/
}
