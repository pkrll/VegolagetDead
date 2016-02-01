//
//  APIEndPoint.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

public enum APIEndPoint {
  
  private static var address = ""
  private static var version = "1.0"
  private static var BaseURL: String {
    return self.address + self.version
  }
  
  static internal var productTypeInStock = "inStock"
  static internal var productTypeListing = "listing"
  
  enum Category: String {
    
    case Root = "/category/"
    
    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    
  }
  /**
   *  Returns details on the producers.
   */
  enum Producer: String {
    /**
     *  Returns all producers stored.
     */
    case Root = "/producer/"
    /**
     *  Returns all wine producers stored.
     */
    case Wine = "/producer/wine/"
    /**
     *  Returns all beer producers stored.
     */
    case Beer = "/producer/beer/"
    /**
     *  Returns all liquor producers stored.
     */
    case liquor = "/producer/liquor/"
    
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
    
    case Root = "/product/"
    
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
    
    case Root = "/store/"
    
    case City = "/store/city/"
    
    case Stock = "/store/stock/"

    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
    
    static func withId(id: Int) -> String {
      return self.Root.string + id.description
    }
    
    static func stock(forStoreWithID id: Int) -> String {
      return self.Stock.string + id.description
    }
  }
  
  enum Search: String {
    
    case Root = "/search/"

    var string: String {
      return APIEndPoint.BaseURL + self.rawValue
    }
        
    static func product(searchString: String) -> String {
      return self.Root.string + searchString
    }
    
  }
  
}