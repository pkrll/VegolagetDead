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
  
  typealias APIManagerCallback = (_ response: APIResponse) -> Void
  
  internal weak var delegate: APIManagerDelegate?
  /**
   *  Returns the last requested URL.
   */
  fileprivate(set) var requestedURL: URL?
  /**
   *  The parameters of the request.
   */
  fileprivate(set) var parameters: Data?
  
  fileprivate lazy var urlRequest: URLRequest = {
    return URLRequest(url: URL(string: "https://api.saturnfive.se/")!)
  }()
  /**
   *  Returns a shared singleton session object.
   */
  fileprivate lazy var session: URLSession = {
    return URLSession.shared
  }()
  
  func setRequestURL(_ string: String) {
    self.requestedURL = URL(string: string)!
  }
  
  func setHttpMethod(_ httpMethod: String) {
    self.urlRequest.httpMethod = httpMethod
  }
  
  func setParameters(_ parameters: [String: String]) {
    var httpBody = String()
    
    for (key, value) in parameters {
      httpBody += "\(key)=\(value)&"
    }
    
    self.urlRequest.httpBody = httpBody.data(using: String.Encoding.utf8)
  }
  
  func setParameters(_ parameters: [String: JSON]) {
    var httpBody = String()
    
    for (key, json) in parameters {
      httpBody += "\(key)=\(json.rawString(String.Encoding.utf8, options: []) ?? "")&"
    }
    
    self.urlRequest.httpBody = httpBody.data(using: String.Encoding.utf8)
  }
  
  func executeRequest(_ success: APIManagerCallback?, failure: APIManagerCallback?) {
    self.urlRequest.url = self.requestedURL
    
    print("Calling \(String(describing: self.requestedURL))")
    let urlRequest = URLRequest(url: self.requestedURL!)
    
    self.session.dataTask(with: self.urlRequest) { (data, URLResponse, error) -> Void in
      let response = self.handleResponse(data, URLResponse: URLResponse, error: error)
      
      if response.didSucceed() {
        if let success = success {
          success(response)
        } else {
          self.delegate?.manager(self, didCompleteRequest: response)
        }
      } else {
        if let failure = failure {
          failure(response)
        } else {
          self.delegate?.manager(self, failedRequest: response)
        }
      }
    }.resume()
  }
  
}
// MARK: - Private Methods
private extension APIManager {
  
  func handleResponse(_ data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> APIResponse {
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
