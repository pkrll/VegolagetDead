//
//  ViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 12/01/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//
import UIKit
/**
 *  This class serves as the basis of all view controllers.
 *
 *  The View Controller class contains basic methods that all controllers can access.
 */
class ViewController: UIViewController {
  /**
   *  The Loading View. An overlay illustrating that an operation is in progress.
   *  - Note: Show the view by calling method showLoadingView() instead of directly accessing this property.
   */
  internal lazy var loadingView: LoadingView = { [unowned self] in
    return LoadingView(frame: self.view.frame)
  }()
  /**
   *  The back bar button item.
   *  - Note: The title of the button is set in the Constants enum. The font used is Roboto Light.
   */
  internal lazy var backBarButtonItem: UIBarButtonItem = {
    let text = UserInterface.backButtonTitle.localized
    let font = Font.Roboto.withStyle(.Light, size: 17.0)!
    let item = UIBarButtonItem(title: text, style: .Plain, target: nil, action: nil)
    item.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
    
    return item
  }()
  /**
   *  The title of the view will be displayed in the navigation bar.
   */
  internal var viewTitle: String {
    return Application.name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showLoadingView()
    self.navigationItem.title = self.viewTitle
    self.navigationItem.backBarButtonItem = self.backBarButtonItem
  }
  
  // MARK: - Loading View Methods
  
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
  
  // MARK: - Alert Methods
  
  /**
  *  Display an alert message to the user.
  *  - Parameters:
  *      - withMessage: The message to display.
  *  - Note: Has only one action, "Dismiss".
  */
  final func showAlert(withMessage message: String) {
    let alertController = UIAlertController(title: Application.name, message: message, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
  }

}
