//
//  APIEndPoint.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

public enum APIEndPoint {
  
  private static var address = "http://api.veganvinguiden.se/"
  private static var version = "1.0"
  private static var BaseURL: String {
    return self.address + self.version
  }
  
  static internal var productTypeInStock = "inStock"
  static internal var productTypeListing = "listing"
  
  enum Categories: String {
    
    case Root = "/categories/"
    
    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    
  }
  /**
   *  Returns details on the producers.
   */
  enum Producers: String {
    /**
     *  Returns all producers stored.
     */
    case Root = "/producers/"
    /**
     *  Returns all wine producers stored.
     */
    case Wine = "/producers/wine/"
    /**
     *  Returns all beer producers stored.
     */
    case Beer = "/producers/beer/"
    /**
     *  Returns all liquor producers stored.
     */
    case liquor = "/producers/liquor/"
    
    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    /**
     *  Returns details about the producer, along with its products both listed at Barnivore and in stock at the System Company in a dictionary with the keys "listing" and "inStock".
     *  - Parameters:
     *      - id: The id of the producer.
     */
    static func withId(id: Int) -> String {
      return self.Root.string + id.description
    }
    
  }
  /**
   *  Returns details on a specific product.
   */
  enum Product: String {
    
    case Root = "/products/"
    
    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    /**
     *  Returns details about all the stores that has it in stock.
     *  - Parameters:
     *      - id: The location id of the product.
     *  - Returns: String representation of the the API end point enum.
     */
    static func withId(id: Int) -> String {
      return self.Root.string + id.description
    }
  }
  
  enum Store: String {
    
    case Root = "/stores/"
    
    case City = "/stores/city/"
    
    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    
    static func withId(id: Int) -> String {
      return self.Root.string + id.description
    }
  }
  
}