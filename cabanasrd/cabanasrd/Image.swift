//
//  Image.swift
//  cabanasrd
//
//  Created by Administrator on 3/10/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

@objc(Image)
class Image : NSObject, NSCoding {

    var url:String?
    var description_:String?
    
    override init(){
    }
    required init(coder aDecoder: NSCoder) {
        if let url = aDecoder.decodeObjectForKey("url") as? String {
            self.url = url
        }
        if let description_ = aDecoder.decodeObjectForKey("description_") as? String {
            self.description_ = description_
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {

        if let url = self.url {
            aCoder.encodeObject(url, forKey: "url")
        }
        if let description_ = self.description_ {
            aCoder.encodeObject(description_, forKey: "description_")
        }
      
    }
}