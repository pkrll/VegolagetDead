//
//  LookupViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 19/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class LookupViewController: SearchViewController {
  
  override internal var viewTitle: String {
    return ""
  }
  
  override internal var searchBarPlaceholder: String {
    return "Sök"
  }
  
  override internal var searchResultsController: UIViewController? {
    return nil//UITableViewController()
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
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    let string = searchController.searchBar.text!
    (self.model as! LookupModel).performSearch(string)
  }
  
}

private extension LookupViewController {
  
  func resizeSearchBar() {
    if let width = self.navigationController?.navigationBar.frame.width {
      self.searchController.searchBar.frame = CGRectMake(0, 0, width-30, 44)
    }
  }
  
}