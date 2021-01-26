//
//  PLACES.swift
//  A1_iOS_simranpreet_c0794501
//
//  Created by simranPreet KAur on 26/01/21.
//
import Foundation
import MapKit

class PLACES: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
   
}

