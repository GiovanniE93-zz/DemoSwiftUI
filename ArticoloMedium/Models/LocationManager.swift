//
//  LocationManager.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var positionisEnabled: Bool = true
    
    override init(){
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        getPosition()
    }

    
    func getPosition(){
        if (positionisEnabled) {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        else {
            print("Error")
        }
    }
    
    func setPosition(Boolposition : Bool){
        positionisEnabled = Boolposition
    }
    
    func getPositionbyString(_ locationToUse : CLLocation){
        if (!positionisEnabled) {
            self.location = locationToUse
        } else {
            print("Not Possible!")
        }
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            return
        }
        self.location = location
    }
}
