//
//  MKMapView+findLocation.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 26/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import MapKit

extension MKMapView {

  typealias CLLocationDegreesTuple = (longitude: Double, latitude: Double)
  typealias MapViewCompletionHandler = (_ mapView: MKMapView) -> Void
  
  func findLocation(_ forAddress: String, withSpan: CLLocationDegreesTuple, completion: @escaping MapViewCompletionHandler) {
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = forAddress
    let search = MKLocalSearch(request: request)
    
    search.start { (response, error) -> Void in
      guard let region = response?.boundingRegion else {
        return
      }
      
      let location = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
      let span = MKCoordinateSpanMake(withSpan.latitude, withSpan.longitude)
      let coordinate = MKCoordinateRegion(center: location, span: span)
      self.setRegion(coordinate, animated: false)
      self.showsUserLocation = false
      
      completion(self)
    }
  }
  
}
