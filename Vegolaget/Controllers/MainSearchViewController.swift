//
//  MainSearchViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 19/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class MainSearchViewController: SearchViewController {
  
  override internal var viewTitle: String {
    return ""
  }
  
  override internal var searchBarPlaceholder: String {
    return "Sök"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureSearchBar(withStyle: .BlackTranslucentBar)
    self.searchBar.barStyle = .Black
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:self.searchBar)
    self.resizeSearchBar()
    self.hideLoadingView()
  }
  
  func didPresentSearchController(searchController: UISearchController) {
    // This makes sure the search bar keeps its right size.
    self.resizeSearchBar()
  }
  
}

private extension MainSearchViewController {
  
  func resizeSearchBar() {
    if let width = self.navigationController?.navigationBar.frame.width {
      self.searchController.searchBar.frame = CGRectMake(0, 0, width-30, 44)
    }
  }
  
}