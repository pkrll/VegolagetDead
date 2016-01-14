//
//  ProductViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ProductViewController: TableViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelDetailName: UILabel!
    @IBOutlet var labelYear: UILabel!
    @IBOutlet var labelAlcohol: UILabel!
    @IBOutlet var labelOrganic: UILabel!
    @IBOutlet var labelPrice: UILabel!

    internal var product: ProductInStock?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storeCell = Constants.Nib.StoreCell.rawValue
        self.registerNib(storeCell, forCellReuseIdentifier: storeCell, withTableView: self.tableView)
        self.tableView.delegate = self

        self.loadTextLabels()
        self.loadDataSource()
        self.loadModel()
    }
    
    func loadTextLabels() {
        self.labelDetailName.numberOfLines = 0
        self.labelName.text = self.product?.name
        self.labelDetailName.text = self.product!.detailName + "\n" + self.product!.type
        self.labelYear.text = "År: \(self.product!.year)"
        self.labelAlcohol.text = "Alkohol: \(self.product!.alcohol) %"
        self.labelOrganic.text = (self.product!.organic) ? "Organisk" : "Ej organisk"
        self.labelPrice.text = "Pris: \(self.product!.price) kronor"
        self.labelDetailName.sizeToFit()
    }
    
    override func loadDataSource() {
        self.dataSource = ProductDataSource()
        self.dataSource.delegate = self
        self.tableView.dataSource = self.dataSource
    }
    
    override func loadModel() {
        self.model = ProductModel(locationID: self.product!.locationID)
        self.model.delegate = self
        self.model.loadData()
    }
    
    override func model(_: Model, didFinishLoadingData data: [Item]) {
        self.dataSource.loadData(data)
        super.model(self.model, didFinishLoadingData: [])
    }
    
}
