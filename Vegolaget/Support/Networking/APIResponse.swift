//
//  APIResponse.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

struct APIResponse {
  /**
   *  The status code of the request.
   */
  let statusCode: Int
  /**
   *  The headers returned from request.
   */
  let allHeaders: [String: String]?
  /**
   *  The data returned.
   */
  let returnData: Data?
  /**
   *  If the response failed, the error object will hold the details.
   */
  let error: String?
  
  init(statusCode: Int, allHeaders: [String: String]?, data: Data?, error: String?) {
    self.statusCode = statusCode
    self.allHeaders = allHeaders
    self.returnData = data
    self.error = error
  }
  
  func didSucceed() -> Bool {
    if let statusCode = StatusCode(rawValue: self.statusCode), statusCode.isSuccess {
      return true
    }
    
    return false
  }
  
}
