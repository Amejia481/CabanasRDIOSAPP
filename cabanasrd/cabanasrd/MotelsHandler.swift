//
//  MotelsHandler.swift
//  cabanasrd
//
//  Created by Administrator on 3/10/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation


class MotelsHandler  {
    
    var motels:[Motel] = []
    let ud = NSUserDefaults.standardUserDefaults()
    
    
    
    func getLocalData()  {
        
        if let data = ud.objectForKey("motel") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            if let newBlog = unarc.decodeObjectForKey("root") as? [Motel]{
                motels = newBlog
            }
        }
        
        
    }
 
    
    func saveLocalData(value: [Motel]) {
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(value), forKey: "motel")
        
    }
    
    
    class var sharedInstance: MotelsHandler {
        struct Static {
            static var instance: MotelsHandler?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MotelsHandler()
        }
        
        return Static.instance!
    }
    func createNewMotelFromJSON(motelsJson:JSON) -> Motel{
        

        var newMotel :Motel
        
        
        newMotel = Motel();
        
        
        newMotel.id = motelsJson["id"].intValue
        newMotel.name = motelsJson["name"].stringValue
        newMotel.latitude = motelsJson["latitude"].doubleValue
        newMotel.longitude = motelsJson["longitude"].doubleValue
        newMotel.takeCredictCards = motelsJson["takeCredictCards"].boolValue
        newMotel.ranking = motelsJson["ranking"].intValue
        newMotel.type = motelsJson["type"].intValue
        
        
        var newState:State = State()
        newState.id = motelsJson["state"]["id"].intValue
        newState.name = motelsJson["state"]["name"].stringValue
        newMotel.state = newState
        
        //Adding Phones
        
        for (phoneKey: String, phonesJson: JSON) in motelsJson["phones"] {
            var newPhone: String =    phonesJson.stringValue
            newMotel.phones.append(newPhone)
        }
        
        //Adding images
        for (imageKey: String, imageJson: JSON) in motelsJson["images2"] {
            var newImage: Image = Image()
            newImage.description_ = imageJson["description"].stringValue
            newImage.url = imageJson["url"].stringValue
            newMotel.images.append(newImage)
            
            
            
        }
        //Adding creditCards
        for (creditCardKey: String, creditCardJson: JSON) in motelsJson["creditCards"]{
            
            var newCreditCard: Int =   creditCardJson["id"].intValue
            newMotel.creditCards.append(newCreditCard)
            
        }
        
        //Adding motel Services
        for (motelServicesKey: String, motelServicesJson: JSON) in motelsJson["motelServices"]{
            
            var newMotelServices: MotelService = MotelService()
            newMotelServices.price =  motelServicesJson["price"].doubleValue
            newMotelServices.type =  motelServicesJson["type"].intValue
            newMotelServices.currencyType =  motelServicesJson["currencyType"].intValue
            newMotelServices.descriptionDetail = motelServicesJson["descriptionDetail"].stringValue
            newMotelServices.service =  motelServicesJson["service"].stringValue
            
            newMotel.motelServices.append(newMotelServices)
            
            
            
            
            
        }
        return newMotel
    }

    func getUpdateMotelFromServer(localMotel:Motel,callBackSuccesFull:(newMotel: Motel)->Void,callBackFail:()->Void){
        print("\(CabanaRDAppConfig.urlServer)api/Cabanias/\(localMotel.id)")
        let url = NSURL(string: "\(CabanaRDAppConfig.urlServer)api/Cabanias/\(localMotel.id)" )
        var request = NSURLRequest(URL: url!)
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if( !self.validateError(response,callBackFail)){
               var serverMotel = self.createNewMotelFromJSON(JSON(data: data))
              
                if let index = find(self.motels, localMotel) {
                    self.motels[index] = serverMotel
                     self.saveLocalData(self.motels)
                    callBackSuccesFull(newMotel:serverMotel)
                }
            }
          
            
            
        })

        
    }
    func validateError(response: NSURLResponse!,callBackFail:()->Void) -> Bool{
        var statusCode :Int = 0
        
        if let httpResponse = response as? NSHTTPURLResponse {
            statusCode = httpResponse.statusCode
            
        }
        
        if(statusCode != 200){
            callBackFail()
            return true
        }
        
        return false
    }
    
    
    func loadDataFromTheServer(  callBackSuccesFull: () -> Void,  callBackFail:() -> Void){
        
        
        //LOADING DATA FROM LOCAL STORAGE
        getLocalData()
        
        
        //IF THERE NO LOCAL DATA GETTING IT FROM THE SERVER
        if(motels.isEmpty){
            
            let url = NSURL(string: "\(CabanaRDAppConfig.urlServer)api/Cabanias")
            var request = NSURLRequest(URL: url!)
            
            let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                var statusCode :Int = 0
                
                
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    statusCode = httpResponse.statusCode
                    
                }
                if(statusCode != 200){
                    callBackFail()
                    return
                }
                
                if let errorLet = error   {
                    // MotelsHandler.Load.array("blog")
                    callBackFail()
                } else {
                    let motelsArray = JSON(data: data)
                    
                    
                    //            var rating:Rating?
                    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                    println("start \(timestamp)")
                    for (key: String, motelsJson: JSON) in motelsArray {
                        //Do something you want
                       
                        self.motels.append(self.createNewMotelFromJSON(motelsJson))
                        
                        
                        
                    }
                    // MotelsHandler.Save.array("list_Array", self.motels)
                    
                    self.saveLocalData(self.motels)
                    
                    let timestamp2 = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                    println("end \(timestamp2)")
                    callBackSuccesFull()
                    
                    
                }
                
                
                
                
                
                
                
            })
        } else {
            
            let url = NSURL(string: "\(CabanaRDAppConfig.urlServer)api/Cabanias/Diff/\(self.motels.last!.id)")
            var request = NSURLRequest(URL: url!)
            let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
             
                if( !self.validateError(response,callBackSuccesFull)){
                    
                    let motelsArray = JSON(data: data)
                    
                    
                    for (key: String, motelsJson: JSON) in motelsArray {
                        
                        
                        self.motels.append(self.createNewMotelFromJSON(motelsJson))
                        
                        
                        
                    }
                    if(!motelsArray.isEmpty){
                     self.saveLocalData(self.motels)
                    }
                    callBackSuccesFull()

                }
          
                
                })
            
            
        }
        
        
        
    }
}
