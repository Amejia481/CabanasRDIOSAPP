//
//  LoadingController.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/5/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

import UIKit

class LoadingController: GAITrackedViewController {
    
    var alerNumber = 0
    
  override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func startLoading(){
        
        
        let url = NSURL(string: "\(CabanaRDAppConfig.urlServer)Home/GetAppVersioniOS")
        var request = NSURLRequest(URL: url!)
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        
        //Checking for a new Version of the app
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var statusCode :Int = 0
            
            
            if let httpResponse = response as? NSHTTPURLResponse {
                statusCode = httpResponse.statusCode
                
            }
            
            if(statusCode == 200){
                
                var serverVersion = JSON(data: data!)
                
                var serverVersionInt : Int =  serverVersion["appServerVersion"].intValue
                if let phoneVersion = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
                    
                    
                    if( ((phoneVersion.toInt()!+10)) >= serverVersionInt ){
                        //LOAD DATA FROM THE SERVER
                        self.loadFromServer()
                        
                    }else{
                        
                        //Showing message to UPDATE THE APP
                        dispatch_async(dispatch_get_main_queue(),{
                           
                            let alert = UIAlertView()
                            alert.title =  NSLocalizedString("message",comment:"")
                            alert.message = NSLocalizedString("ms_update_app",comment:"")
                            alert.addButtonWithTitle(NSLocalizedString("iGotIt",comment:""))
                            alert.delegate = self
                            alert.show()
                            
                            
           
                            
                        })
                    }
                    
                }
                
                
            } else{
                self.loadFromServer()
            }
            
            
        })
        
        
        
        
        
        
        
        
        
        
        
    }
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        if(  self.alerNumber == 1){
            exit(0)
        }else{
            if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier{
                var path: NSURL = NSURL(string: "itms-apps://itunes.apple.com/us/app/\(bundleIdentifier)")!
                UIApplication.sharedApplication().openURL(path)
                exit(0)
            }
        }

    }

    override  func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false);
        
   
        self.startLoading()
        
        
          
           
        

    }

    
    func loadFromServer(){
       
        MotelsHandler.sharedInstance.loadDataFromTheServer(
            { () -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    self.performSegueWithIdentifier("segLodingToTabBar", sender: nil);
                    }
                )

                
                
                
                
            },
            callBackFail: { () -> Void in
                dispatch_async(dispatch_get_main_queue(),{
//                var alert = UIAlertController()
//                    alert.title = NSLocalizedString("message",comment:"")
//                    alert.message = NSLocalizedString("msErrorConnection",comment:"")
                   
           //         alert.preferredStyle             = .Alert
                
                    let alert = UIAlertView()
                    alert.title =  NSLocalizedString("message",comment:"")
                    alert.message = NSLocalizedString("msErrorConnection",comment:"")
                    alert.addButtonWithTitle(NSLocalizedString("iGotIt",comment:""))
                    alert.delegate = self
                    alert.show()
                    self.alerNumber = 1
                
//                alert.addAction(UIAlertAction(title: NSLocalizedString("iGotIt",comment:""), style: .Default, handler: { action in
//                    
//                    
//
//                   
//                    
//                    
//                    
//                }))
//               self.presentViewController(alert, animated: true, completion: nil)
                })
                
        });
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Loading View";
    }
    
}
