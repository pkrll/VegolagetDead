//
//  Model.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
import SwiftyJSON

class Model: NSObject, APIManagerDelegate {
    
    internal weak var delegate: ModelDelegate?
    
    internal var coreDataEntity: String? {
        return nil
    }
        
    internal var coreDataPredicate: NSPredicate? {
        return nil
    }

    internal var endPoint: String {
        return String()
    }
    
    internal lazy var dataController: DataController = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
    }()
    
    internal lazy var manager = {
        return APIManager()
    }()
    
    override init() {
        super.init()
        self.manager.delegate = self
    }
    /**
     *  Saves to core data, If an entity is set in the property coreDataEntity.
     *  - Note: Invoked by *manager(_:didCompleteRequest:)*.
     *  - Parameter data: An array of elements to save.
     */
    func saveData(data: [Item]) {
        if let entity = self.coreDataEntity {
            self.dataController.insertItems(data, toEntity: entity)
        }
    }
    /**
     *  Loads from core data.
     */
    func loadData() {
        self.dataController.loadItems(fromEntity: self.coreDataEntity, withPredicate: self.coreDataPredicate) { (success: Bool, data: [AnyObject]?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let data = data where data.count > 0 {
                    let elements = self.didLoadFromCoreData(data)
                    self.willPassDataToDelegate(elements)
                } else {
                    self.manager.callNode(self.endPoint,
                        success: self.managerDidCompleteRequest,
                        failure: self.managerFailedRequest
                    )
                }
            }
        }
    }
    /**
     *  This method is called by *loadData()*, providing the results of the core data query.
     *  - Parameter data: An array containing the core data objects.
     *  - Note: This method must be subclassed if actual objects are to be created. Also, extend the method *createItem(_:)* to create objects from a JSON object created in this method.
     *  - Returns: An array of Item object.
     */
    func didLoadFromCoreData(data: [AnyObject]) -> [Item] {
        let elements: [Item] = []
        // Create an object from the core data object in sub classes
        return elements
    }
    /**
     *  Called before the model passes on the fetched items to the delegate.
     */
    func willPassDataToDelegate(data: [Item]) {
        self.delegate?.model(self, didFinishLoadingData: data)
    }
    /**
     *  Parses the returned data from the request to create objects of type Item.
     *  - Note: This method invokes *createItem(_:)*, which should be extended if the object is a sub class of Item.
     */
    func parseResponseData(data: NSData?) -> [Item] {
        var list = [Item]()
        if let data = data {
            let data = JSON(data: data)
            
            for (_, json): (String, JSON) in data {
                let item = self.createItem(json)
                list.append(item)
            }
        }
        
        return list
    }
    /**
     *  Creates an object of type Item.
     *  - Note: Override this method to create subtypes of Item.
     *  - Parameter json: The JSON object must contain the basic information to satisfy the Item type.
     */
    func createItem(json: JSON) -> Item {
        return Item(data: json)
    }
    
    // MARK: - API Manager Delegate/Callback Methods
    
    /**
     *  Receives the response from the API manager upon success.
     *  - SeeAlso: managerDidCompleteRequest(_:)
     *  - Parameters:
     *      - manager: The instance that made the request.
     *      - response: The response from the request.
     */
    func manager(_: APIManager, didCompleteRequest response: APIResponse) {
        self.managerDidCompleteRequest(response)
    }
    /**
     *  Receives the resposne from the API manager upon failure.
     *  - SeeAlso: managerFailedRequest(_:)
     *  - Parameters:
     *      - manager: The instance that made the request.
     *      - response: The response from the request.
     */
    func manager(_: APIManager, failedRequest response: APIResponse) {
        self.managerFailedRequest(response)
    }
    /**
    *  Receives the response from the API manager upon success.
    *  - Note: This method will parse the return data of the Response object by calling *parseReturnData(_:)*.
    *  - Note: If there were any data returned, the parsed data will be added to the *elements* array and the *ModelDelegate* method *didPopulateDataSource()* will be called.
    *  - Note: An empty response will invoke *ModelDelegate* method *model(_: didEncounterError:)*.
    *  - Parameters:
    *      - response: The response from the request.
    */
    func managerDidCompleteRequest(response: APIResponse) {
        let elements = self.parseResponseData(response.returnData)
        
        if elements.isEmpty == false {
            self.saveData(elements)
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.willPassDataToDelegate(elements)
        }
    }
    /**
     *  Receives the resposne from the API manager upon failure.
     *  - Parameters:
     *      - response: The response from the request.
     */
    func managerFailedRequest(response: APIResponse) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let errorString = response.error ?? "Okänt fel"
            self.delegate?.model(self, didFinishLoadingWithError: errorString)
        }
    }

    
}