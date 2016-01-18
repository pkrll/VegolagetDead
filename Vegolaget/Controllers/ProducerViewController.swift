//
//  ProducerViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProducerViewController: TableViewController {
  
  @IBOutlet var tableView: UITableView!
  
  internal var producer: Producer?
  
  override internal var viewTitle: String {
    return self.producer?.name ?? "Producent"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.registerNib(Constants.Nib.ProductCell.rawValue)
    
    self.tableView.delegate = self
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 80.0
    self.tableView.addSubview(self.refreshControl)
    
    self.loadDataSource()
    self.loadModel()
  }
  
  override func loadDataSource() {
    self.dataSource = ProducerDataSource()
    self.dataSource.delegate = self
    self.tableView.dataSource = self.dataSource
  }
  
  override func loadModel() {
    if let id = self.producer?.id {
      self.model = ProducerModel(producerID: id)
      self.model.coreDataPredicate = NSPredicate(format: "companyID = %i", id)
      self.model.delegate = self
      self.model.loadData()
    }
  }
  
  override func didRequestRefresh(sender: AnyObject) {
    self.model.refreshData()
  }
  
  // MARK: - Model Delegate Methods
  
  override func model(model: Model, didFinishLoadingData data: [Item]) {
    self.refreshControl.endRefreshing()
    super.model(model, didFinishLoadingData: data)
  }
  
  // MARK: - Table View Delegate Methods
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Barnivore items and System Company items differ
    if indexPath.section == 1 {
      let sender = self.dataSource.itemAtIndexPath(indexPath) as? ProductInStock
      self.performSegueWithIdentifier(Constants.Segue.ShowProduct.rawValue, sender: sender)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewController = segue.destinationViewController as? ProductViewController, let sender = sender as? ProductInStock {
      viewController.product = sender
    }
  }
  
}