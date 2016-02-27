//
//  SecondViewController.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import UIKit

class SecondViewController: GAITrackedViewController  {


    @IBOutlet weak var webview: UIWebView!
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked || !(request.URL.absoluteString!.rangeOfString("team") != nil)  {
           
            UIApplication.sharedApplication().openURL(request.URL)
            return false
        
        }
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                let localfilePath = NSBundle.mainBundle().URLForResource(NSLocalizedString("teamFile",comment:""), withExtension: "html");
        let requestObj = NSURLRequest(URL: localfilePath!);
        webview.loadRequest(requestObj);
    }
    
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Team View";
    }


}

