//
//  APIManager.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 11/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

typealias APIManagerCallback = (response: APIResponse) -> Void

class APIManager {
    
    internal weak var delegate: APIManagerDelegate?
    /**
     *  Returns the last requested URL.
     */
    internal var requestedURL = String()
    /**
     *  Returns a shared singleton session object.
     */
    private lazy var session: NSURLSession = {
        return NSURLSession.sharedSession()
    }()
    /**
     *  Make a request.
     *  - parameter endPoint: The URL to call.
     */
    func callNode(endPoint: String, success: APIManagerCallback?, failure:APIManagerCallback?) {
        let request = NSURLRequest(URL: NSURL(string: endPoint)!)
        self.requestedURL = endPoint
        self.execute(request) { (data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Void in
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
        }
    }
    
}
// MARK: - Private Methods
private extension APIManager {

    func execute(request: NSURLRequest, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        self.session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }
    
}