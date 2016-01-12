//
//  Category.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class Category: Item {
    
    let tag: String
    let title: String
    let count: Int
    
    override init(data: JSON) {
        self.tag = data["tag"].stringValue
        self.count = data["count"].intValue
        self.title = data["title"].stringValue.stringByReplacingOccurrencesOfString("($)", withString: "\(self.count)")
        
        super.init(data: data)
    }
    
}