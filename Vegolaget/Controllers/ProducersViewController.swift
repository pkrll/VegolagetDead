//
//  ProducersViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 13/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducersViewController: SearchViewController {
    
    private let coreDataPredicates: [CategoryType: NSPredicate] = [
        .Wine: NSPredicate(format: "doesWine = %i", 1),
        .Beer: NSPredicate(format: "doesBeer = %i", 1),
        .Liquor: NSPredicate(format: "doesLiquor = %i", 1)
    ]
    
    @IBOutlet var tableView: UITableView!
    
    internal var category: Category?
    
    override internal var scopeButtonTitles: [String] {
        return Constants.UserInterface.scopeButtonTitles
    }
    
    override internal var viewTitle: String {
        return "Producenter"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let producerCell = Constants.Nib.ProducerCell.rawValue
        let loadingCell = Constants.Nib.LoadingCell.rawValue
        self.registerNib(producerCell, forCellReuseIdentifier: producerCell, withTableView: self.tableView)
        self.registerNib(loadingCell, forCellReuseIdentifier: loadingCell, withTableView: self.tableView)
        
        self.searchBar.placeholder = "Sök efter producent"
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
            self.model.coreDataPredicate = self.coreDataPredicates[tag]
            self.model.delegate = self
            self.model.loadData()
        }
        
        self.category = nil
    }
    
    override func model(model: Model, didFinishLoadingData data: [Item]) {
        self.searchBar.placeholder = "Sök bland \(data.count) producenter"
        self.dataSource.loadData(data)
        super.model(self.model, didFinishLoadingData: [])
    }

    override func didFinishFilterDataSource(_: SearchDataSource) {
        let dataSource = self.dataSource as! ProducersDataSource
        self.searchBar.placeholder = "Sök bland \(dataSource.numberOfSearchableItems) producenter"
        super.didFinishFilterDataSource(dataSource)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

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
