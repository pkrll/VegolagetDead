//
//  MKMapView+findLocation.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 26/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import MapKit

extension MKMapView {
  
  func findLocation(searchQuery: String, withSpan: (longitude: Double, latitude: Double)) {
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = searchQuery
    let localSearch = MKLocalSearch(request: searchRequest)
    
    localSearch.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
      if let response = response {
        let location = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
        let span = MKCoordinateSpanMake(withSpan.latitude, withSpan.longitude)
        let annotation = MKPointAnnotation()
        let coordinate = MKCoordinateRegion(center: location, span: span)
        annotation.coordinate = location
        self.setRegion(coordinate, animated: false)
        self.addAnnotation(annotation)
        self.showsUserLocation = false
      }
    }
  }
  
}