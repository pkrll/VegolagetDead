//
//  WebViewController.swift
//  Vegolaget
//
//  Created by Ardalan Samimi on 14/03/16.
//  Copyright © 2016 Saturn Five. All rights reserved.
//

import UIKit

class WebViewController: ViewController {
  
  internal var primaryURL: NSURL?
  internal var pageTitle: String?
  
  @IBOutlet var webView: UIWebView!

  override internal var viewTitle: String {
    return self.pageTitle ?? Application.name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showLoadingView()
    
    if let URL = self.primaryURL {
      self.loadURL(URL)
    } else {
      self.hideLoadingView()
    }
  }

  private func loadURL(URL: NSURL) {
    let request = NSURLRequest(URL: URL)
    self.webView.delegate = self
    self.webView.loadRequest(request)
  }
  
}

extension WebViewController: UIWebViewDelegate {

  func webViewDidFinishLoad(webView: UIWebView) {
    self.hideLoadingView()
  }
  
  
}
