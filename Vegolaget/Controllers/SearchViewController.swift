//
//  SearchViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
/**
 *  This class is a sub class of the Table View Controller class and provides extra functionality for using a search controller.
 *  - Note: This class conforms to the Search Data Source Delegate.
 */
class SearchViewController: TableViewController, SearchDataSourceDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
  
  // MARK: - Properties
  
  internal var searchResultsController: UIViewController? {
    return nil
  }
  /**
   *  Manages the display of search results. The search controller does not use its own results controller. The view controller extending the search controller must provide its own table view.
   */
  internal lazy var searchController: UISearchController = { [unowned self] in
    let searchController = UISearchController(searchResultsController: self.searchResultsController)
    searchController.delegate = self
    
    return searchController
  }()
  /**
   *  The search bar provided by the searchController.
   *  - Note: The search bar will customize itself when this property is first called.
   */
  internal lazy var searchBar: UISearchBar = { [unowned self] in
    return self.searchController.searchBar
  }()
  /**
   *  Sets the placeholder text of the search bar.
   */
  internal var searchBarPlaceholder: String {
    return ""
  }
  
  // MARK: - View Controller Methods
  
  override func viewDidLoad() {
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.dimsBackgroundDuringPresentation = false
    self.definesPresentationContext = true
    super.viewDidLoad()
  }
  /**
   *  Loads the Search View Controller's data source.
   */
  override func loadDataSource() {
    self.dataSource = SearchDataSource()
    self.dataSource.delegate = self
  }
  
  // MARK: - Search View Controller Specific Methods
  
  /**
   *  Configure the search bar with a predefined style.
   *  - Parameter withStyle: The style of the search bar.
   */
  func configureSearchBar() {
    let font = Font.Roboto.withStyle(.Light, size: 16.0)!
    
    self.searchController.searchBar.delegate = self
    self.searchController.searchBar.barStyle = .default
    self.searchController.searchBar.tintColor = UserInterface.greenColor
    self.searchController.searchBar.barTintColor = UIColor.white
    self.searchController.searchBar.showsScopeBar = false

    // The tint color of the search bar will also change the search fields color. This should fix that.
    if let textField = self.searchController.searchBar.value(forKey: "_searchField") as? UITextField {
      textField.textColor = UIColor.black
      textField.tintColor = UIColor.black
      textField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)
      textField.attributedPlaceholder = NSAttributedString(string: self.searchBarPlaceholder, attributes:[NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font])
    }


    self.searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
    self.searchController.searchBar.setImage(UIImage(named: "search"), for: .search, state: UIControlState())
  }
  
  func setSearchBarPlaceholder(_ string: String) {
    if let textField = self.searchController.searchBar.value(forKey: "_searchField") as? UITextField {
      let font = Font.Roboto.withStyle(.Light, size: 16.0)!
      textField.attributedPlaceholder = NSAttributedString(string: string, attributes:[NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font])
    }
  }
  /**
   *  Hides the search bar, if a table view is set.
   *  - Parameters:
   *      - withAnimation: Set true if the hiding should be animated.
   */
  func hideSearchBar(_ withAnimation: Bool) {
    if self.responds(to: #selector(getter: UITableViewController.tableView)) {
      let tableView = self.value(forKey: "tableView")
      let contentOffset = CGPoint(x: 0, y: self.searchBar.bounds.height)
      (tableView as AnyObject).setContentOffset(contentOffset, animated: withAnimation)
    }
  }
  
  // MARK: - Model Delegate Methods
  
  override func model(_ model: Model, didFinishLoadingData data: [Item]) {
    self.hideSearchBar(true)
    super.model(model, didFinishLoadingData: data)
  }
  
  // MARK: - Search Data Source Delegate Methods
  
  func didFinishFilterDataSource(_ dataSource: SearchDataSource) {
    super.didFinishLoadDataSource(dataSource)
  }
  
  // MARK: - Search Results Updating Delegate Methods
  
  func updateSearchResults(for searchController: UISearchController) {
    if self.dataSource.responds(to: "filterBySearchString:") {
      let searchString = searchController.searchBar.text!
      self.dataSource.perform("filterBySearchString:", with: searchString)
    }
  }
  
  // MARK: - Table View Delegate Methods
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // This fixes an apparent bug where xcode would cry out endDisablingInterfaceAutorotationAnimated not matched with beginDisablingInterfaceAutorotation, whenever the keyboard was dismissed.
    self.searchBar.resignFirstResponder()
  }
  
  // MARK: - Other Methods
  
  deinit {
    // Fixes issue where XCode would warn about loading "the view of a view controller while it is deallocating".
    self.searchController.view.removeFromSuperview()
  }
  
}
