//
//  ViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit

class ViewController: UIViewController {

    final internal lazy var loadingView: LoadingView = {
        [unowned self] in
        return LoadingView(frame: self.view.frame)
    }()

    internal lazy var viewTitle: String = {
        return Constants.Application.name
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.viewTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.UserInterface.backButtonTitle, style: .Plain, target: nil, action: nil)
    }
    /**
     *  Load the model in this method.
     */
    func loadModel() {
    
    }
    /**
     *  Shows an overlay view to indicate a loading state.
     *  - Note: When the loading process is done, use *hideLoadingView()* method to remove the view.
     */
    func showLoadingView() {
        self.view.addSubview(self.loadingView)
        self.loadingView.startProgress()
    }
    /**
     *  Hides the loading overlay.
     */
    func hideLoadingView() {
        self.loadingView.stopProgress()
        self.loadingView.removeFromSuperview()
    }
    /**
     *  Display an alert message to the user.
     *  - Parameters:
     *      - withMessage: The message to display.
     *  - Note: Has only one action, "Dismiss".
     */
    final func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: Constants.Application.name, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
