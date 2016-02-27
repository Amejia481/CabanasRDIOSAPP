//
//  State.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

@objc(State)
class State : NSObject  , NSCoding{
    var  name: String?
    var id:Int = 0
    

    required init(coder aDecoder: NSCoder) {
        
        self.id =  aDecoder.decodeIntegerForKey("id_")

        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
    }
    override init(){
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        
        aCoder.encodeInteger(id, forKey: "id_")
        
        if let name = self.name  {
            aCoder.encodeObject(name, forKey: "name")
        }
        
        
    }
}