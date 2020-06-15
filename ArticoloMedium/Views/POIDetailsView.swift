//
//  POIDetailsView.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import SwiftUI
import MapKit

struct PoiDetailsView: View {
    let landmarkSelected : LandmarkAnnotation
    @EnvironmentObject var landMarksArray : ItineraryModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack{
                Text(landmarkSelected.title!)
            }
            if !self.landMarksArray.landmarksToVisit.contains(where: {$0.title == self.landmarkSelected.title! && $0.coordinate.latitude == self.landmarkSelected.coordinate.latitude && $0.coordinate.longitude == self.landmarkSelected.coordinate.longitude}){
                Button(action: {
                    self.landMarksArray.landmarksToVisit.append(self.landmarkSelected)
                    self.landMarksArray.disablePolyline = true
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                {
                    Text("Add to the itinerary")
                }
                
            }
            
            if self.landMarksArray.landmarksToVisit.contains(where: {$0.title == self.landmarkSelected.title!}){
                Button(action: {
                    self.landMarksArray.landmarksToVisit.removeAll(where: {$0.title == self.landmarkSelected.title! && $0.coordinate.latitude == self.landmarkSelected.coordinate.latitude && $0.coordinate.longitude == self.landmarkSelected.coordinate.longitude})
                    self.landMarksArray.disablePolyline = true
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Remove")
                }
            }
            
            
            Button(action: {
                self.landMarksArray.isChanged = true
                self.presentationMode.wrappedValue.dismiss()
                self.landMarksArray.disablePolyline = false
            }) {
                Text("Start")
            }
            
        }
    }
}

