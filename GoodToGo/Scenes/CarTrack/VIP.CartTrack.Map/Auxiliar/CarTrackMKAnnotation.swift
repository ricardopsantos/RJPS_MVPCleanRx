//
//  CarTrackMKAnnotation.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/06/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import MapKit
//
import Domain_CarTrack

class CarTrackMKAnnotation: NSObject, MKAnnotation {

    let model: Domain_CarTrack.CarTrack.UserModel
    let title: String?
    let subTitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D, model: Domain_CarTrack.CarTrack.UserModel) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        self.model = model
        super.init()
    }
}
