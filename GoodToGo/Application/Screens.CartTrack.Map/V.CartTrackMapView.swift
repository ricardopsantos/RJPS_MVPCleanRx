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

        enum CartTrackMapViewAnnotationType {
            case pinAnnotationView
            case markerAnnotationView
        }

        static var selectedAnnotationsTypeForMap: CartTrackMapViewAnnotationType = .markerAnnotationView

        var rxFilter = BehaviorSubject<String?>(value: nil)
        private var lastModel: [CarTrack.UserModel] = []
        // MARK: - UI Elements (Private and lazy by default)

        private lazy var mapView: MKMapView = {
            return MKMapView()
        }()

        private lazy var searchBar: CustomSearchBar = {
            return UIKitFactory.searchBar()
        }()

        private lazy var lblInfo: UILabel = {
            return UIKitFactory.label(style: .info)
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(mapView)
            addSubview(searchBar)
            addSubview(lblInfo)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {
            let edgesToExclude: LayoutEdge = .init([.top, .bottom])
            let defaultMargin = Designables.Sizes.Margins.defaultMargin
            let insets: TinyEdgeInsets = TinyEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)

            lblInfo.autoLayout.topToBottom(of: searchBar, offset: Designables.Sizes.Margins.defaultMargin)
            lblInfo.autoLayout.width(screenWidth / 4)
            lblInfo.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

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
            lblInfo.addShadow()
            lblInfo.addCorner(radius: 5)
            lblInfo.textAlignment = .right

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
            lblInfo.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

        func setupWith(screenInitialState viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel) {
            //subTitle = viewModel.subTitle
            //screenLayout = viewModel.screenLayout
        }

        func setupWith(mapDataFilter viewModel: VM.CartTrackMap.MapDataFilter.ViewModel) {
            lblInfo.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

    }
}

// MARK: - Private

extension V.CartTrackMapView {

    private func extractSubTitle(_ userModel: Domain.CarTrack.UserModel) -> String {
        return userModel.name
    }

    private func extractTitle(_ userModel: Domain.CarTrack.UserModel) -> String {
        return userModel.company.name
    }

    private func extractLocation(_ userModel: Domain.CarTrack.UserModel) -> CLLocationCoordinate2D {
        let latitude  = userModel.address.geo.lat
        let longitude = userModel.address.geo.lng
        let lat: CLLocationDegrees = CLLocationDegrees(Double(latitude)!)
        let lng: CLLocationDegrees = CLLocationDegrees(Double(longitude)!)
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        return coordinate
    }

    private func updateMapWith(list: [CarTrack.UserModel]) {
        lastModel = list
        mapView.removeAnnotations()

        guard list.count > 0 else {
            BaseViewControllerMVP.shared.displayMessage(Messages.noRecords.localised, type: .warning)
            return
        }

        if V.CartTrackMapView.selectedAnnotationsTypeForMap == .pinAnnotationView {

            let mkPointAnnotationList: [MKPointAnnotation] = list.map {
                let annotation = MKPointAnnotation()
                annotation.coordinate = extractLocation($0)
                annotation.title = extractTitle($0)
                annotation.subtitle = extractSubTitle($0)
                return annotation
            }

            mkPointAnnotationList.forEach { (mkPointAnnotation) in
                self.mapView.addAnnotation(mkPointAnnotation)
            }
        } else {
            let mkAnnotationsList: [CarTrackMKAnnotation] = list.map {
                CarTrackMKAnnotation(title: extractTitle($0), subTitle: extractSubTitle($0), coordinate: extractLocation($0))
            }
            self.mapView.addAnnotations(mkAnnotationsList)
        }

        if let first = list.first {
            mapView.setRegion(extractLocation(first))
        }
    }

}

// MARK: - MKMapViewDelegate

extension V.CartTrackMapView: MKMapViewDelegate {

    // Called when the region displayed by the map view is about to change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //    print(#function)
    }

    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation { return nil }

        let reuseIdentifier = "MKAnnotationView.identifier"

        if V.CartTrackMapView.selectedAnnotationsTypeForMap == .pinAnnotationView {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                pinView?.animatesDrop = true
                pinView?.canShowCallout = true
                pinView?.isDraggable = true
                pinView?.pinTintColor = UIColor.App.primary
                let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
                pinView?.rightCalloutAccessoryView = rightButton as? UIView
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        } else if V.CartTrackMapView.selectedAnnotationsTypeForMap == .markerAnnotationView {
            guard let annotation = annotation as? CarTrackMKAnnotation else { return nil }
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(#function)
        if control == view.rightCalloutAccessoryView {
            //   print("toTheMoon")
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            let droppedAt = view.annotation?.coordinate
            //print(droppedAt.debugDescription)
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

// MARK: MKMapViewUtils

extension MKMapView {
    func removeAnnotations() {
        self.removeAnnotations(self.annotations)
    }

    func setRegion(_ center: CLLocationCoordinate2D) {
        guard self.annotations.count > 0 else {
            return
        }

        let maxLongitude = annotations.max { (a, b) -> Bool in a.coordinate.longitude > b.coordinate.longitude }!.coordinate.longitude
        let minLongitude = annotations.min { (a, b) -> Bool in a.coordinate.longitude > b.coordinate.longitude }!.coordinate.longitude
        let maxLatitude = annotations.max { (a, b) -> Bool in a.coordinate.latitude > b.coordinate.latitude }!.coordinate.longitude
        let minLatitude = annotations.min { (a, b) -> Bool in a.coordinate.latitude > b.coordinate.latitude }!.coordinate.longitude
        //print(maxLongitude, minLongitude)
        //print(maxLatitude, minLatitude)
        //let latitudeDelta = CLLocationDegrees()
        //let longitudeDelta = CLLocationDegrees()
        let span = MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
        let region = MKCoordinateRegion.init(center: center, span: span)
        self.setRegion(region, animated: true)
    }
}

// MARK: MKMapViewUtils

class CarTrackMKAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subTitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, subTitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        super.init()
    }
}
