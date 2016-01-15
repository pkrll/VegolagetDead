//
//  StoreModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import SwiftyJSON

class StoreModel: Model {
    
    init(storeID: Int) {
        super.init()
        self.endPoint = APIEndPoint.Store.withId(storeID)
    }
    
    override func refreshData() {
    }
    

    
}
