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
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

  @IBAction func phoneButtonTapped(sender: AnyObject) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.registerNib(Constants.Nib.OpenHourCell.rawValue)
    self.loadDataSource()
    if self.store != nil {
      self.configureViews()
    } else {
      self.loadModel()
    }
  }
  
  override func loadDataSource() {
    self.dataSource = StoreDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
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
    if let store = data.first as? Store {
      self.store = store
    }
    
    self.configureViews()
  }
  
  override func didFinishLoadDataSource(_: DataSource) {
    self.tableView.reloadData()
    // Dynamically sets the height of the table view.
    self.tableViewHeightConstraint.constant = CGFloat(self.tableView.numberOfRowsInSection(0)) * self.tableView.rowHeight
    self.view.layoutIfNeeded()
  }
  
}

private extension StoreViewController {

  func configureViews() {
    if let store = self.store, let dataSource = self.dataSource as? StoreDataSource {
      dataSource.loadData(store.dateTime)
      self.loadCoordinates()
      self.addressLabel.text = store.address
      self.postalLabel.text = "\(store.postalCode) \(store.city)"
    }
    
    self.hideLoadingView()
  }
  
  func loadCoordinates() {
    let searchQuery = "\(self.store!.address), \(self.store!.postalCode) \(self.store!.city)"
    self.mapView.findLocation(searchQuery, withSpan: (longitude: 0.005, latitude: 0.005)) { (mapView: MKMapView) -> Void in
      let annotation = MKPointAnnotation()
      annotation.coordinate = mapView.region.center
      annotation.title = self.store?.address
      annotation.subtitle = self.store?.name
      mapView.addAnnotation(annotation)
    }
  }
  
}