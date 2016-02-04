//
//  APIEndPoint.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation


enum APIEndPoint: String {
  /**
   *  The address for the API.
   */
  private static let address = ""
  /**
   *  The version of the API.
   */
  private static let version = "1.0"
  /**
   *  The base API URL.
   */
  private static var baseURL: String {
    return self.address + self.version
  }
  
  case Category       = "Category"
  case Producer       = "Producer"
  case Product        = "Product"
  case ProductInStock = "ProductInStock"
  case Store          = "Store"
  case Search         = "Search"
  
  var string: String {
    return APIEndPoint.baseURL + "/" + self.rawValue
  }
  /**
   *  **Endpoint:**
   *
   *  /category
   *
   *  Retrieves all categories.
   *
   *  Used with GET method.
   *  - Note: Returns information for Category objects.
   */
  static func category() -> String {
    return APIEndPoint.Category.string
  }
  /**
   *  **Endpoint:**
   *
   *  /producer(?items={ids})
   *
   *  Retrieves all producers in the database. If used with POST method, the post field items must be specified.
   *
   *  Used with GET or POST method.
   *  - Note: Returns information for Producer objects.
   */
  static func producer() -> String {
    return APIEndPoint.Producer.string
  }
  /**
   *  **Endpoint:**
   *
   *  /producer/{id}
   *
   *  Retrieves information on the specified producer.
   *
   *  Used with GET method.
   *  - Note: Returns information for a Producer object.
   *  - Parameter: The id of the producer.
   */
  static func producer(withId id: Int) -> String {
    return APIEndPoint.Producer.string + "/" + id.description
  }
  /**
   *  **Endpoint:**
   *
   *  /producer/{id}/products
   *
   *  Retrieves the products of a producer.
   *
   *  Used with GET method.
   *  - Note: Returns both information for Product and ProductInStock objects.
   *  - Parameter id: The id of the producer.
   */
  static func productsForProducer(id: Int) -> String {
    return APIEndPoint.producer(withId: id) + "/products"
  }
  /**
   *  **Endpoint:**
   *
   *  /product/?items={ids}
   *
   *  Retrieve information on multiple products.
   *
   *  Used with POST method. *The post field "items" must be set to an array of product ids.
   *  - Note: Returns information for Product objects.
   */
  static func product() -> String {
    return APIEndPoint.Product.string
  }
  /**
   *  **Endpoint:**
   *
   *  /product/{id}
   *
   *  Retrieve information on a product.
   *
   *  Used with GET method.
   *  - Note: Returns information for a Product object.
   *  - Parameter id: The id of the product.
   */
  static func product(withId id: Int) -> String {
    return APIEndPoint.Product.string + "/" + id.description
  }
  /**
   *  **Endpoint:**
   *
   *  /productinstock/?items={ids}
   *
   *  Retrieve information on multiple in-stock products.
   *
   *  Used with POST method. *The post field "items" must be set to an array of in-stock product ids.
   *  - Note: Returns information for ProductInStock objects.
   */
  static func productInStock() -> String {
    return APIEndPoint.ProductInStock.string
  }
  /**
   *  **Endpoint:**
   *
   *  /productinstock/{id}
   *
   *  Retrieve information on a in-stock product.
   *
   *  Used with GET method.
   *  - Note: Returns information for a ProductInStock object.
   *  - Parameter id: The id of the in-stock product.
   */
  static func productInStock(withId id: Int) -> String {
    return APIEndPoint.ProductInStock.string + "/" + id.description
  }
  /**
   *  **Endpoint:**
   *
   *  /productinstock/{location-id}/stores
   *
   *  Retrieve stores that has the specified in-stock product.
   *
   *  Used with GET method.
   *  - Note: Returns information for Store objects.
   *  - Parameter id: The id of the in-stock product.
   */
  static func storesWithProductInStock(withLocationId id: Int) -> String {
    return self.productInStock(withId: id) + "/stores"
  }
  /**
   *  **Endpoint:**
   *
   *  /store(?items={ids})
   *
   *  Retrieve information on all stores stocked with products. If used with POST method,the post field items must be specified.
   *
   *  Used with GET or POST method.
   *  - Note: Returns information for Store objects.
   *
   */
  static func store() -> String {
    return APIEndPoint.Store.string
  }
  /**
   *  **Endpoint:**
   *
   *  /store/{id}
   *
   *  Retrieve information on a store.
   *
   *  Used with GET method.
   *  - Note: Returns information for a Store object.
   *  - Parameter id: The id of the store.
   */
  static func store(withId id: Int) -> String {
    return APIEndPoint.Store.string + "/" + id.description
  }
  /**
   *  **Endpoint:**
   *
   *  /store/{id}/stock
   *
   *  Retrieves the specified store's stock.
   *
   *  Used with GET method.
   *  - Note: Returns information for ProductInStock objects.
   *  - Parameter id: The id of the store.
   */
  static func stockForStore(withId id: Int) -> String {
    return self.store(withId: id) + "/stock"
  }
  /**
   *  **Endpoint:**
   *
   *  /search/{type}/?query=string
   *
   *  Retrieves information on a producer, product, in-stock product or store that matches a keyword string.
   *
   *  Used with POST method. *The post field "query" must be set to the search query.
   *  - Note: Returns information for Product, Producer, ProductInStock or Store objects.
   */
  static func search(forType type: APIEndPoint) -> String {
    return APIEndPoint.Search.string + "/" + type.rawValue
  }
  
}