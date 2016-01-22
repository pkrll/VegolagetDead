//
//  ProducersViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducersViewController: SearchViewController {
  
  @IBOutlet var tableView: UITableView!
  
  internal var category: Category?
  
  override internal var searchBarPlaceholder: String {
    return "Sök bland %i producenter"
  }
  
  override internal var viewTitle: String {
    return "Producenter"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.registerNib(Constants.Nib.ProducerCell.rawValue)
    self.registerNib(Constants.Nib.LoadingCell.rawValue)

    self.configureSearchBar()
    self.searchBar.placeholder = "Sök efter producent"
    self.searchBar.scopeButtonTitles = Constants.UserInterface.scopeButtonTitles
    self.searchBar.delegate = self
    self.tableView.delegate = self
    self.tableView.tableHeaderView = self.searchBar
    self.tableView.tableHeaderView?.sizeToFit()
    self.searchController.searchResultsUpdater = self

    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = ProducersDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    self.model = ProducersModel()
    
    if let tag = CategoryType(rawValue: self.category!.tag.capitalizedString) {
      let coreDataPredicates: [CategoryType: NSPredicate] = [
        .Wine: NSPredicate(format: "doesWine = %i", 1),
        .Beer: NSPredicate(format: "doesBeer = %i", 1),
        .Liquor: NSPredicate(format: "doesLiquor = %i", 1)
      ]
      
      self.model.coreDataPredicate = coreDataPredicates[tag]
      self.model.delegate = self
      self.model.loadData()
    }
    
    self.category = nil
  }
  
  override func model(model: Model, didFinishLoadingData data: [Item]) {
    self.searchBar.placeholder = String(format: self.searchBarPlaceholder, data.count)
    super.model(self.model, didFinishLoadingData: data)
  }
  
  override func didFinishFilterDataSource(_: SearchDataSource) {
    let dataSource = self.dataSource as! ProducersDataSource
    self.searchBar.placeholder = String(format: self.searchBarPlaceholder, dataSource.numberOfSearchableItems)
    super.didFinishFilterDataSource(dataSource)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewController = segue.destinationViewController as? ProducerViewController, let sender = sender as? UITableViewCell {
      let indexPath = self.tableView.indexPathForCell(sender)!
      let producer = self.dataSource.itemAtIndexPath(indexPath) as! Producer
      viewController.producer = producer
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let sender = tableView.cellForRowAtIndexPath(indexPath)!
    
    if sender.reuseIdentifier == Constants.Nib.LoadingCell.rawValue {
      if let dataSource = self.dataSource as? ProducersDataSource where dataSource.hasMoreItemsToLoad(atRow: indexPath.row) {
        self.tableView.reloadData()
      }
    } else {
      self.performSegueWithIdentifier(Constants.Segue.ShowProducer.rawValue, sender: sender)
    }
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let dataSource = self.dataSource as! ProducersDataSource
    dataSource.selectedScopeIndex = selectedScope
    dataSource.filterBySearchString(searchBar.text!)
  }
  
}
