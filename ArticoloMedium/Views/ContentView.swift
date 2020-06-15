//
//  ContentView.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @EnvironmentObject var searchInput : SearchInput
    @State private var tapped: Bool = false
    @State private var selectedPlace: MKPointAnnotation?
    @State private var isSelected : Bool = false
    @State private var landmarkSelected : LandmarkAnnotation?
    @State private var pathConsidered : Path?
    @EnvironmentObject var itineraryModel : ItineraryModel
   
    func calculateOffset() -> CGFloat {
        if self.searchInput.landmarks.count > 0 && !self.tapped {
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
        }
        else if self.tapped {
            return 160
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    
    var body: some View {
        
        ZStack(alignment: .trailing){
            
            MapView(landmarks: searchInput.landmarks, landmarkAnnotations: $searchInput.landmarksAnnotations, selectedPlace: $selectedPlace, isSelected: $isSelected, pathConsidered: $pathConsidered, landmarkSelected: $landmarkSelected)
                .sheet(isPresented: $isSelected, content:{PoiDetailsView(landmarkSelected: self.landmarkSelected!).environmentObject(self.searchInput).environmentObject(self.itineraryModel)})
            PlaceListView(){
                self.tapped.toggle()
            }.animation(.spring())
            .environmentObject(searchInput)
                .offset(y: calculateOffset())
                .frame(width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height + 150  , alignment: .trailing)
        }
    }
}
