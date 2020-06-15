//
//  PlaceListView.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceListView: View {

    @EnvironmentObject var searchInput : SearchInput
    var onTap: () -> ()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                EmptyView()
            }.frame(width: UIScreen.main.bounds.size.width, height: 15)
                .background(Color.gray)
            .gesture(TapGesture()
                .onEnded(self.onTap)
            )
        
            List {
                HStack{
                TextField("Search...", text: $searchInput.searchText, onEditingChanged: {_ in
                    print("[PLV] onEditingChange!")
                    self.searchInput.getNearByLandmarksByName()
                    if(self.searchInput.searchText == "") {
                        self.searchInput.landmarks.removeAll()
                        self.searchInput.landmarksAnnotations.removeAll()
                    }
                })
                    Button(action: {self.searchInput.searchText = ""
                        self.searchInput.landmarks.removeAll()
                        self.searchInput.landmarksAnnotations.removeAll()
                    }) {
                    Text("Cancel")
                    }
                }
                if(searchInput.landmarks.count > 0) {
                    ForEach(self.searchInput.landmarks, id: \.id) { landmark in
                        
                        VStack(alignment: .leading) {
                            Text(landmark.name)
                                .fontWeight( .bold)
                            
                            Text(landmark.title)
                        }
                    }
                }else {
                Button(action: {
                    self.searchInput.getNearByLandmarksByFilter(.cafe)
                }, label: {
                    Text("Cafè")
                })
                Button(action: {
                    self.searchInput.getNearByLandmarksByFilter(.hotel)
                }, label: {
                    Text("Hotel")
                })
                Button(action: {
                    self.searchInput.getNearByLandmarksByFilter(.museum)
                }, label: {
                    Text("Museum")
                })
                Button(action: {
                    self.searchInput.getNearByLandmarksByFilter(.park)
                }, label: {
                    Text("Park")
                    })
                Button(action: {
                    self.searchInput.getNearByLandmarksByFilter(.beach)
                }, label: {
                    Text("Beach")
                })
                }
            }
            
        }.cornerRadius(10)
    }
}
