//
//  SearchInput.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import Foundation
import MapKit

class SearchInput : ObservableObject {
    
    @Published var searchText : String = ""
    @Published var landmarksAnnotations : [LandmarkAnnotation] = [LandmarkAnnotation]()
    @Published var landmarks : [Landmark] = [Landmark]()
    @Published var newModificationAvailable : Bool = false
    @Published var locationManager : LocationManager = LocationManager()
    
    func getNearByLandmarksByName(){
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.searchText
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                for item in self.landmarks
                {
                    self.landmarksAnnotations.append(LandmarkAnnotation(landmark: item))
                }
            }
        }
    }
    
    func getNearByLandmarksByFilter(_ filter : MKPointOfInterestCategory){
        
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: .init(arrayLiteral: filter))
        request.region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 10, longitudinalMeters: 10)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
                
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                 for item in self.landmarks {
                    self.landmarksAnnotations.append(LandmarkAnnotation(landmark: item))
                }
            }
        }
    }
}


