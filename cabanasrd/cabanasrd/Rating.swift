//
//  Rating.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

@objc(Rating)
class Rating : NSObject , NSCoding {
    var  id: Int = 0
    var guestHouse:Int = 0
    var value: Double = 0.0
    var  device:String?
    
    required init(coder aDecoder: NSCoder) {
    
        self.id =  aDecoder.decodeIntegerForKey("id_")
         self.guestHouse = aDecoder.decodeIntegerForKey("guestHouse")
         self.value = aDecoder.decodeDoubleForKey("value")
       
        if let device = aDecoder.decodeObjectForKey("device") as? String {
            self.device = device
        }
    }
    override init(){
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
    
       
          aCoder.encodeInteger(id, forKey: "id_")
          aCoder.encodeInteger(guestHouse, forKey: "guestHouse")
          aCoder.encodeDouble(value, forKey: "value")
      
        if let device = self.device  {
            aCoder.encodeObject(device, forKey: "device")
        }
      
    
    }

}