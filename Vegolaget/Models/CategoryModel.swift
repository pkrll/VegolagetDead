//
//  CategoryModel.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

class CategoryModel: Model {
    
    override internal var coreDataEntity: String? {
        return "Category"
    }
 
    override internal var endPoint: String {
        return APIEndPoint.Categories.Root.string
    }
    

}