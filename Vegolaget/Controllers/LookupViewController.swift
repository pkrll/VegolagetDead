//
//  LookupViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 19/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class LookupViewController: SearchViewController {
  
  private var searchScope = ["producer", "product", "store"]
  
  override internal var viewTitle: String {
    return ""
  }
  
  override internal var searchBarPlaceholder: String {
    return "Sök"
  }
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.registerNib(Constants.Nib.ProducerCell.rawValue)
    self.registerNib(Constants.Nib.ProductCell.rawValue)
    self.registerNib(Constants.Nib.StoreCell.rawValue)
    self.tableView.delegate = self
    self.tableView.hidden = true
    
    self.configureSearchBar()
    self.navigationItem.titleView = self.searchBar
    self.searchController.searchResultsUpdater = self
    self.segmentedControl.tintColor = Constants.UserInterface.greenColor
    
    self.resizeSearchBar()
    self.hideLoadingView()
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = LookupDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    self.model = LookupModel()
    self.model.delegate = self
  }
  
  override func model(_: Model, didFinishLoadingData data: [Item]) {
    self.dataSource.loadData(data)
    self.tableView.hidden = data.isEmpty
    self.hideLoadingView()
  }
  
  func didPresentSearchController(searchController: UISearchController) {
    // This makes sure the search bar keeps its right size.
    self.resizeSearchBar()
  }
  
  override func updateSearchResultsForSearchController(searchController: UISearchController) {
    // Override to not cause it to call the API Manager each and everytime a change is made. The call is instead made through Search Bar Delegate Method searchBarTextDidEndEditing(_:), which is invoked when the user has pressed enter.
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if let model = self.model as? LookupModel {
      self.showLoadingView()
      model.searchQuery = searchController.searchBar.text ?? ""
      model.searchScope = self.searchScope[self.segmentedControl.selectedSegmentIndex]
      model.loadData()
    }
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    self.model(self.model, didFinishLoadingData: [])
  }

}

private extension LookupViewController {
  
  func resizeSearchBar() {
    if let width = self.navigationController?.navigationBar.frame.width {
      self.searchController.searchBar.frame = CGRectMake(0, 0, width-30, 44)
    }
  }
  
}