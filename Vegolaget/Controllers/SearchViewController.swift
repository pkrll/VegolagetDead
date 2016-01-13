//
//  SearchViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class SearchViewController: TableViewController, SearchDataSourceDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    /**
     *  Manages the display of search results. The search controller does not use its own results controller. The view controller extending the search controller must provide its own table view.
     */
    internal lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()
    /**
     *  The search bar provided by the searchController.
     *  - Note: The search bar will customize itself when this property is first called.
     */
    internal lazy var searchBar: UISearchBar = { [unowned self] in
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.showsScopeBar = false
        self.searchController.searchBar.scopeButtonTitles = self.scopeButtonTitles
        self.searchController.searchBar.barTintColor = Constants.UserInterface.greenColor
        self.searchController.searchBar.tintColor = UIColor.whiteColor()
        // The tint color of the search bar set above will also change the search fields color. This should fix that.
        if let textField = self.searchController.searchBar.valueForKey("_searchField") as? UITextField {
            textField.tintColor = UIColor.blueColor()
        }
        
        return self.searchController.searchBar
    }()
    /**
     *  An array of strings indicating the titles of the scope buttons of the search bar.
     */
    internal var scopeButtonTitles: [String] {
        return []
    }
    /**
     *  Sets the placeholder text of the search bar.
     */
    internal var searchBarPlaceholder: String {
        return ""
    }
    
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
    /**
     *  Hides the search bar, if a table view is set.
     *  - Parameters:
     *      - withAnimation: Set true if the hiding should be animated.
     */
    func hideSearchBar(withAnimation: Bool) {
        if self.respondsToSelector("tableView") {
            let tableView = self.valueForKey("tableView")
            let contentOffset = CGPointMake(0, self.searchBar.bounds.height)
            tableView?.setContentOffset(contentOffset, animated: withAnimation)
        }
    }
    
    // MARK: - Model Delegate Methods
    
    override func model(model: Model, didFinishLoadingData data: [Item]) {
        self.hideSearchBar(true)
        super.model(model, didFinishLoadingData: data)
    }
    
    // MARK: - Search Data Source Delegate Methods
    
    func didFinishFilterDataSource(dataSource: SearchDataSource) {
        super.didFinishLoadDataSource(dataSource)
    }
    
    // MARK: - Search Results Updating Delegate Methods
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if self.dataSource.respondsToSelector("filterBySearchString:") {
            let searchString = searchController.searchBar.text!
            self.dataSource.performSelector("filterBySearchString:", withObject: searchString)
        }
    }
    
    // MARK: - Table View Delegate Methods
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // This fixes an apparent bug where xcode would cry out endDisablingInterfaceAutorotationAnimated not matched with beginDisablingInterfaceAutorotation, whenever the keyboard was dismissed.
        self.searchBar.resignFirstResponder()
    }
    
    deinit {
        // Fixes issue where XCode would warn about loading "the view of a view controller while it is deallocating".
        self.searchController.view.removeFromSuperview()
    }
    
}