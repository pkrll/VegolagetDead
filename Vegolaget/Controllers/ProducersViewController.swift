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
    let title: String
    
    switch self.tag {
      case .Wine?:
        title = "Vinproducenter"
      case .Beer?:
        title = "Ölproducenter"
      case .Liquor?:
        title = "Spritproducenter"
      default:
        title = "Producenter"
    }
    
    return title
  }
  
  fileprivate lazy var tag: CategoryType? = { [unowned self] in
    return CategoryType(rawValue: self.category!.tag.capitalized)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.registerNib(Nib.ProducerCell.rawValue)
    self.registerNib(Nib.LoadingCell.rawValue)

    self.configureSearchBar()
    self.setSearchBarPlaceholder("Sök efter producent")
    self.searchBar.scopeButtonTitles = UserInterface.scopeButtonTitles
    self.searchBar.delegate = self
    self.tableView.delegate = self
    self.tableView.tableHeaderView = self.searchBar
    self.tableView.tableHeaderView?.sizeToFit()
    self.tableView.addSubview(self.refreshControl)
    self.searchController.searchResultsUpdater = self
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = ProducersDataSource(type: self.tag)
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    self.model = ProducersModel()
    
    if let tag = self.tag {
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
  
  override func didRequestRefresh(_ sender: AnyObject) {
    self.model.refreshData()
  }
  
  override func model(_ model: Model, didFinishLoadingData data: [Item]) {
    let placeholder = String(format: self.searchBarPlaceholder, data.count)
    self.setSearchBarPlaceholder(placeholder)
    self.refreshControl.endRefreshing()
    super.model(self.model, didFinishLoadingData: data)
  }
  
  override func didFinishFilterDataSource(_: SearchDataSource) {
    let dataSource = self.dataSource as! ProducersDataSource
    let placeholder = String(format: self.searchBarPlaceholder, dataSource.numberOfSearchableItems)
    self.setSearchBarPlaceholder(placeholder)
    super.didFinishFilterDataSource(dataSource)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? ProducerViewController, let sender = sender as? UITableViewCell {
      let indexPath = self.tableView.indexPath(for: sender)!
      let producer = self.dataSource.itemAtIndexPath(indexPath) as! Producer
      viewController.producer = producer
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    let sender = tableView.cellForRow(at: indexPath)!
    
    if sender.reuseIdentifier == Nib.LoadingCell.rawValue {
      if let dataSource = self.dataSource as? ProducersDataSource, dataSource.hasMoreItemsToLoad(atRow: indexPath.row) {
        self.tableView.reloadData()
      }
    } else {
      self.performSegue(withIdentifier: Segue.ShowProducer.rawValue, sender: sender)
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let dataSource = self.dataSource as! ProducersDataSource
    dataSource.selectedScopeIndex = selectedScope
    dataSource.filterBySearchString(searchBar.text!)
  }
  
}
