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
  
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureSearchBar()
    self.navigationItem.titleView = self.searchBar
    self.searchController.searchResultsUpdater = self
    self.segmentedControl.tintColor = Constants.UserInterface.greenColor
    self.resizeSearchBar()
    self.hideLoadingView()
    self.loadModel()
  }
  
  override func loadModel() {
    self.model = LookupModel()
    self.model.delegate = self
  }
  
  func didPresentSearchController(searchController: UISearchController) {
    // This makes sure the search bar keeps its right size.
    self.resizeSearchBar()
  }
  
  override func updateSearchResultsForSearchController(searchController: UISearchController) {
    // Override to not cause it to call the API Manager each and everytime a change is made. The call is instead made through Search Bar Delegate Method searchBarTextDidEndEditing(_:), which is invoked when the user has pressed enter.
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    let query = searchController.searchBar.text ?? ""
    let scope = self.searchScope[self.segmentedControl.selectedSegmentIndex]
    (self.model as! LookupModel).performSearch(query, withSearchScope: scope)
  }
  
}

private extension LookupViewController {
  
  func resizeSearchBar() {
    if let width = self.navigationController?.navigationBar.frame.width {
      self.searchController.searchBar.frame = CGRectMake(0, 0, width-30, 44)
    }
  }
  
}