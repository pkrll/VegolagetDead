//
//  APIManager.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 11/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation
import SwiftyJSON

class APIManager {
  
  typealias APIManagerCallback = (response: APIResponse) -> Void
  
  internal weak var delegate: APIManagerDelegate?
  /**
   *  Returns the last requested URL.
   */
  private(set) var requestedURL: NSURL?
  /**
   *  The parameters of the request.
   */
  private(set) var parameters: NSData?
  
  private lazy var URLRequest: NSMutableURLRequest = {
    return NSMutableURLRequest()
  }()
  /**
   *  Returns a shared singleton session object.
   */
  private lazy var session: NSURLSession = {
    return NSURLSession.sharedSession()
  }()
  
  func setRequestURL(string: String) {
    self.requestedURL = NSURL(string: string)!
  }
  
  func setHttpMethod(httpMethod: String) {
    self.URLRequest.HTTPMethod = httpMethod
  }
  
  func setParameters(parameters: [String: String]) {
    var httpBody = String()
    
    for (key, value) in parameters {
      httpBody += "\(key)=\(value)&"
    }
    
    self.URLRequest.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
  }
  
  func setParameters(parameters: [String: JSON]) {
    var httpBody = String()
    
    for (key, json) in parameters {
      httpBody += "\(key)=\(json.rawString(NSUTF8StringEncoding, options: []) ?? "")&"
    }
    
    self.URLRequest.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
  }
  
  func executeRequest(success: APIManagerCallback?, failure: APIManagerCallback?) {
    self.URLRequest.URL = self.requestedURL
    print("Calling \(self.requestedURL)")
    self.session.dataTaskWithRequest(self.URLRequest) { (data, URLResponse, error) -> Void in
      let response = self.handleResponse(data, URLResponse: URLResponse, error: error)
      
      if response.didSucceed() {
        if let success = success {
          success(response: response)
        } else {
          self.delegate?.manager(self, didCompleteRequest: response)
        }
      } else {
        if let failure = failure {
          failure(response: response)
        } else {
          self.delegate?.manager(self, failedRequest: response)
        }
      }
    }.resume()
  }
  
}
// MARK: - Private Methods
private extension APIManager {
  
  func handleResponse(data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> APIResponse {
    var response: APIResponse
    
    if let URLResponse = URLResponse {
      let statusCode = StatusCode(rawValue: URLResponse.statusCode)!
      
      if statusCode.isSuccess {
        // A 200 - 299 response
        response = APIResponse(
          statusCode: statusCode.rawValue,
          allHeaders: URLResponse.allHeaders,
          data: data,
          error: error?.localizedDescription
        )
      } else {
        // Status code indicates failure
        response = APIResponse(
          statusCode: statusCode.rawValue,
          allHeaders: URLResponse.allHeaders,
          data: data,
          error: error?.localizedDescription
        )
      }
    } else {
      // A nil URLResponse
      response = APIResponse(
        statusCode: 0,
        allHeaders: nil,
        data: nil,
        error: error?.localizedDescription
      )
    }
    
    return response
  }
  
}