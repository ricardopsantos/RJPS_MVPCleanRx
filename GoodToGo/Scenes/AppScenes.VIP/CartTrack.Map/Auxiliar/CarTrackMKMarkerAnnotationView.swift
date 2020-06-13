//
//  CarTrackMKMarkerAnnotationView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 13/06/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import MapKit
//
import Domain_CarTrack

class CarTrackMKMarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let carTrackMKAnnotation = newValue as? CarTrackMKAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            markerTintColor = carTrackMKAnnotation.model.mapColor
            glyphText       = carTrackMKAnnotation.model.mapGlyphText
            rightCalloutAccessoryView = carTrackMKAnnotation.model.mapButton

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont.App.Styles.caption.rawValue
            detailLabel.text = carTrackMKAnnotation.model.mapSubTitle
            detailCalloutAccessoryView = detailLabel

        }
    }
}
