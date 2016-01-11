//
//  APIManager.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 11/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import Foundation

class APIManager {
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
    func callNode(endPoint: String) {
        let request = NSURLRequest(URL: NSURL(string: endPoint)!)
        self.requestedURL = endPoint
        self.execute(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
        }
    }
    
}
// MARK: - Private Methods
private extension APIManager {

    func execute(request: NSURLRequest, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        self.session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }
    
}