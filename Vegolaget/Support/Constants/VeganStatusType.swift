//
//  VeganStatusType.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 09/02/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

enum VeganStatusType: Int {
  
  case NonVegan  = 0
  case AllVegan  = 1
  case SomeVegan = 2
  
  var description: String {
    var string = String()
    
    switch (self) {
    case .NonVegan:
      string = "Not Vegan Friendly"
    case .AllVegan:
      string = "Vegan Friendly"
    case .SomeVegan:
      string = "Has Some Vegan Options"
    }
    
    return string
  }
  
}
