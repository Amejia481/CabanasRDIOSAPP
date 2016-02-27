//
//  MotelService.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

@objc(MotelService)
class MotelService : NSObject , NSCoding{
   
    var price:Double = 0.0
    var type:Int = 0
    var currencyType:Int = 0
    var descriptionDetail:String?
    var service:String?
 
    required init(coder aDecoder: NSCoder) {
        
        self.type =  aDecoder.decodeIntegerForKey("type")
        self.currencyType =  aDecoder.decodeIntegerForKey("currencyType")
        self.price = aDecoder.decodeDoubleForKey("price")
        
        if let descriptionDetail = aDecoder.decodeObjectForKey("descriptionDetail") as? String {
            self.descriptionDetail = descriptionDetail
        }
        if let service = aDecoder.decodeObjectForKey("service") as? String {
            self.service = service
        }
    }
    
    override init(){
    }
    func encodeWithCoder(aCoder: NSCoder) {
        
        
        aCoder.encodeInteger(type, forKey: "type")
        aCoder.encodeInteger(currencyType, forKey: "currencyType")
        aCoder.encodeDouble(price, forKey: "price")
        
        if let descriptionDetail = self.descriptionDetail  {
            aCoder.encodeObject(descriptionDetail, forKey: "descriptionDetail")
        }
        if let descriptionDeservicetail = self.service  {
            aCoder.encodeObject(service, forKey: "service")
        }

        
    }
  
}
