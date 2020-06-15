//
//  ItineraryModel.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import CoreData

class ItineraryModel : ObservableObject {

    @Published var landmarksToVisit : [LandmarkAnnotation] = [LandmarkAnnotation]()
    @Published var initialPosition : LocationManager = LocationManager()
    @Published var type : MKDirectionsTransportType = .automobile
    @Published var timeSpent : Double = 0
    @Published var paths : [Path] = []
    @Published var isOptimized : Bool = false
    @Published var name : String = ""
    @Published var isChanged : Bool = false
    @Published var disablePolyline : Bool = false
    private var arrayDiComodo: [LandmarkAnnotation] = [LandmarkAnnotation] ()
    private var city : String = ""
    
}

struct Landmark {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D{
        self.placemark.coordinate
    }
}

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    
    init(landmark: Landmark) {
        self.title = landmark.name
        self.coordinate = landmark.coordinate
    }
    
    init(_ coordinate :CLLocationCoordinate2D, _ name: String) {
        self.title = name
        self.coordinate = coordinate
        
    }
    
    override init() {
        self.title = ""
        self.coordinate = CLLocationCoordinate2D()
        super.init()
    }
}

struct Path {
    var initialPoint : LandmarkAnnotation
    var finalPoint : LandmarkAnnotation
    var route: MKRoute
    var timeToGo : Double
}
