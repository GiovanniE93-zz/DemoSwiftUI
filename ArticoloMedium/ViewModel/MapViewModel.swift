//
//  MapViewModel.swift
//  ArticoloMedium
//
//  Created by Giovanni Erpete on 15/06/2020.
//  Copyright © 2020 Giovanni Erpete. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct  MapView: UIViewRepresentable {
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var control : MapView
        @Binding var landmarkSelected : LandmarkAnnotation?
        
        init(mappa : MapView,landmarkSelected: Binding<LandmarkAnnotation?>){
            self.control = mappa
            _landmarkSelected = landmarkSelected
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            
            if let annotationView = views.first {
                if let annotation = annotationView.annotation{
                    if annotation is MKUserLocation{
                        
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapView.setRegion(region, animated: true)
                    }
                    
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .purple
            render.lineWidth = 3
            return render
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
            if ((view.annotation!.coordinate.latitude != mapView.userLocation.coordinate.latitude) && (view.annotation!.coordinate.longitude != mapView.userLocation.coordinate.longitude))
            {
                    print("jesus")
    //            toggle della variabile isSelected che in base al suo valore apre la modal
                control.isSelected = true
    //            assegnazione della variabile interna del coordinator alla annotation effettivamente selezionata
                self.landmarkSelected = (view.annotation! as! LandmarkAnnotation)
            }
        }
        
}
    
    var landmarks: [Landmark]
    //Aggiundo due variabili binding, voglio gestire i binding già in termini di LandmarkAnnotations che sono MKAnnotation
    @Binding var landmarkAnnotations : [LandmarkAnnotation]
    @Binding var selectedPlace : MKPointAnnotation?
    @Binding var isSelected : Bool
    @Binding var pathConsidered : Path?
    @Binding var landmarkSelected : LandmarkAnnotation?
    @EnvironmentObject var itinerary : ItineraryModel
    @EnvironmentObject var searchInput : SearchInput
    @State private var group = DispatchGroup()
    
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        if(itinerary.initialPosition.location?.coordinate != nil) {
            map.centerCoordinate = itinerary.initialPosition.location!.coordinate
        }
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mappa : self,landmarkSelected: $landmarkSelected)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        updateAnnotations(from: uiView)
        if itinerary.isChanged{
            let arrayComodo = self.itinerary.landmarksToVisit
            getAll(for: LandmarkAnnotation(self.itinerary.initialPosition.location!.coordinate, "MyPosition"), array: arrayComodo, MapViewConsidered: uiView)
            itinerary.isChanged = false
        }
        
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        
        if(self.itinerary.disablePolyline) {
            mapView.removeOverlays(mapView.overlays)
        }
        mapView.removeAnnotations(mapView.annotations)
        if(self.itinerary.landmarksToVisit.count != 0 && searchInput.landmarksAnnotations.count == 0) {
            let annotation = self.itinerary.landmarksToVisit
            print("Annotation count: \(annotation.count)")
            for ann in annotation {
                print("Ann: \(ann.title!)")
            }
            print("Add Annotation of landmark to visit")
            mapView.addAnnotations(annotation)
        } else {
            print("Add point researched \(landmarkAnnotations.count)")
            mapView.addAnnotations(landmarkAnnotations)
        }
        
    }
    
    private func getAll (for value: LandmarkAnnotation, array: [LandmarkAnnotation], MapViewConsidered: MKMapView) {
        print("getAll richiamata")
        var arrayComodo : [Path] = []
        for i in array{
            group.enter()
            print("getAll nel dispatchGroup")
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: value.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: i.coordinate))
            request.requestsAlternateRoutes = true
            request.transportType = self.itinerary.type
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if var routeResponses = response?.routes {
                    print("getAll completion handler")
                    routeResponses.sort(by: {$0.distance < $1.distance})
                    let quickestRoute = routeResponses[0]
                    arrayComodo.append(Path(initialPoint: value, finalPoint: i, route: quickestRoute, timeToGo: quickestRoute.expectedTravelTime))
                    self.group.leave()
                }
            }
        }
        
        group.notify(queue: .main){
            print("getAll notify")
            let bestPath = arrayComodo.min(by: {$0.route.distance < $1.route.distance})
            var a = array
            self.pathConsidered = bestPath
            var polyline : MKOverlay
            polyline = self.pathConsidered!.route.polyline
            MapViewConsidered.addOverlay(polyline)
            self.itinerary.paths.append(self.pathConsidered!)
            if a.count > 1 {
                let k = self.itinerary.landmarksToVisit.first(where: {$0.coordinate.latitude == bestPath!.finalPoint.coordinate.latitude && $0.coordinate.longitude == bestPath!.finalPoint.coordinate.longitude})
                a.removeAll(where: {$0.coordinate.latitude == bestPath!.finalPoint.coordinate.latitude && $0.coordinate.longitude == bestPath!.finalPoint.coordinate.longitude})
                print("BestPath final Point: \(bestPath!.finalPoint)")
                self.getAll(for: k!, array: a, MapViewConsidered: MapViewConsidered)
            }
        }
    }
    
}
