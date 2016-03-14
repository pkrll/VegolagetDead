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
  internal var producerID: Int?
  
  override internal var viewTitle: String {
    return self.producer?.name ?? "Producent"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.registerNib(Nib.ProductCell.rawValue)
    
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
    var producerID: Int? = nil
    
    if let id = self.producer?.id {
      producerID = id
      self.producer = nil
    } else if let id = self.producerID {
      producerID = id
    }
    
    if let id = producerID {
      self.model = ProducerModel(producerID: id)
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
    if indexPath.section == 0 {
      let sender = self.dataSource.itemAtIndexPath(indexPath) as? Product
      self.performSegueWithIdentifier(Segue.ShowBrowser.rawValue, sender: sender)
    } else if indexPath.section == 1 {
      let sender = self.dataSource.itemAtIndexPath(indexPath) as? ProductInStock
      self.performSegueWithIdentifier(Segue.ShowProduct.rawValue, sender: sender)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewController = segue.destinationViewController as? WebViewController, let sender = sender as? Product {
      viewController.primaryURL = NSURL(string: "\(Application.barnivoreProductURL)\(sender.id)")
      viewController.pageTitle = sender.name
    } else if let viewController = segue.destinationViewController as? ProductViewController, let sender = sender as? ProductInStock {
      viewController.product = sender
    }
  }
  
}