//
//  StoresModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 15/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class StoresModel: Model {
    
    private let city: String
    
    init(city: String) {
        self.city = city
        super.init()
        self.coreDataEntity = .Store
        self.endPoint = APIEndPoint.Store.City.string
    }
    
    override func refreshData() {
        self.manager.setHttpMethod("POST")
        self.manager.setParameters(["city": self.city.uppercaseString])
        super.refreshData()
    }
    
    override func saveData(data: [Item]) {
        if let entity = self.coreDataEntity {
            self.dataController.insertAndUpdateItems(data, inEntity: entity.rawValue)
        }
    }
    
    override func createItem(json: JSON) -> Item {
        return Store(data: json)
    }
    
}