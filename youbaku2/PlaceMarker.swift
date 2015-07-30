//
//  PlaceMarker.swift
//  Feed Me
//
//  Created by Brian Moakley on 10/24/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import Foundation

class PlaceMarker: GMSMarker {

  
    let place: Place
    
    // 2
    init(place: Place) {
        self.place = place
        super.init()
        println(place.plc_latitude)
        position = CLLocationCoordinate2D(latitude: (place.plc_latitude as NSString).doubleValue, longitude: (place.plc_longitude as NSString).doubleValue)
        icon = UIImage(named: "ic_yellow_marker")

//        groundAnchor = CGPoint(x: 0.44, y: 0.45)
//        infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
        appearAnimation = kGMSMarkerAnimationPop
        
    }
}