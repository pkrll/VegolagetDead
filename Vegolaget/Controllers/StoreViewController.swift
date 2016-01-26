//
//  StoreViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 22/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit
import MapKit

class StoreViewController: TableViewController {
  
  internal var storeID: Int?
  internal var store: Store?
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var postalLabel: UILabel!
  @IBOutlet var openHoursLabel: UILabel!
  
  @IBAction func phoneButtonTapped(sender: AnyObject) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.store != nil {
      self.configureViews()
    } else {
      self.loadModel()
    }
  }
  
  override func loadModel() {
    guard let storeID = self.storeID else {
      return
    }
    
    self.model = StoreModel(storeID: storeID)
    self.model.delegate = self
    self.model.loadData()
  }
  
  override func model(_: Model, didFinishLoadingData data: [Item]) {
    self.store = data.first as? Store
    self.configureViews()
  }
  
  func configureViews() {
    if let store = self.store {
      self.loadCoordinates()
      
      self.addressLabel.text = store.address
      self.postalLabel.text = "\(store.postalCode) \(store.city)"
      self.openHoursLabel.text = store.openHours
      self.openHoursLabel.numberOfLines = 0
      self.openHoursLabel.sizeToFit()
    }
    
    self.hideLoadingView()
  }
  
  
  func loadCoordinates() {
    let searchQuery = "\(self.store!.address), \(self.store!.postalCode) \(self.store!.city)"
    self.mapView.findLocation(searchQuery, withSpan: (longitude: 0.005, latitude: 0.005))
//
//    annotation.coordinate = self.mapView.region.center
//    annotation.title = self.store?.address
//    annotation.subtitle = self.store?.name
//    self.mapView.addAnnotation(annotation)

  }
  
}