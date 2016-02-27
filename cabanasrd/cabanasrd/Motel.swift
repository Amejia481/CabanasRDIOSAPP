//
//  Motel.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//


import Foundation
@objc(Motel)
class Motel : NSObject, NSCoding{
    var id:Int = 0
    var name:String?
    var phones:Array<String> = []
    var latitude:Double = 0.0;
    var longitude:Double = 0.0;
    var takeCredictCards:Bool = false
    var images:Array<Image> = Array<Image>()
    var motelServices:Array<MotelService> = Array<MotelService>()
    var state:State?
    var rating:Rating?
    var creditCards:Array<Int> = []
    var ranking:Int = 0
    var type:Int = 0
    
//  
//    override var hashValue: Int {
//        return self.id
//    }
//    

    
    
    required init(coder aDecoder: NSCoder) {
        
        self.id =  aDecoder.decodeIntegerForKey("motel_id")
        self.ranking =  aDecoder.decodeIntegerForKey("ranking")
        self.latitude = aDecoder.decodeDoubleForKey("latitude")
        self.longitude = aDecoder.decodeDoubleForKey("longitude")
        self.takeCredictCards = aDecoder.decodeBoolForKey("takeCredictCards")
        self.type =  aDecoder.decodeIntegerForKey("type")
        
        
        if let images = aDecoder.decodeObjectForKey("images") as? Array<Image> {
            self.images = images
        }
        if let phones = aDecoder.decodeObjectForKey("phones") as? Array<String> {
            self.phones = phones
        }
        if let motelServices = aDecoder.decodeObjectForKey("motelServices") as? Array<MotelService> {
            self.motelServices = motelServices
        }
        if let state = aDecoder.decodeObjectForKey("state") as? State {
            self.state = state
        }
        if let creditCards = aDecoder.decodeObjectForKey("creditCards") as? Array<Int> {
            self.creditCards = creditCards
        }
        if let rating = aDecoder.decodeObjectForKey("rating") as? Rating {
            self.rating = rating
        }
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
    }
    


    
    func encodeWithCoder(aCoder: NSCoder) {
        

        aCoder.encodeInteger(id, forKey: "motel_id")
        aCoder.encodeInteger(ranking, forKey: "ranking")
        aCoder.encodeBool(takeCredictCards, forKey: "takeCredictCards")
        aCoder.encodeDouble(latitude, forKey: "latitude")
        aCoder.encodeDouble(longitude, forKey: "longitude")
        aCoder.encodeInteger(type, forKey: "type")

        if let state = self.state  {
            aCoder.encodeObject(state, forKey: "state")
        }
        if let rating = self.rating  {
            aCoder.encodeObject(rating, forKey: "rating")
        }
        
        if let name = self.name  {
            aCoder.encodeObject(name, forKey: "name")
        }
        
        aCoder.encodeObject(images, forKey: "images")
        aCoder.encodeObject(phones, forKey: "phones")
        aCoder.encodeObject(motelServices, forKey: "motelServices")
        aCoder.encodeObject(creditCards, forKey: "creditCards")
    
        
        
       
        
        
    }

    override init(){
    }
    
    func toString() ->String{
//        StringBuilder sb = new StringBuilder();
//        if(motelServices!= null){
//            for(int i =0; i < motelServices.size() ; i++){
//                MotelService motelService1 = motelServices.get(i);
//                
//                if(motelService1 !=null && motelService1.getType() == CabannasrdApp.MOTEL_TYPE_HOUSING ){
//                    
//                    sb.append( motelService1.getService());
//                    sb.append(": ");
//                    sb.append(String.format("$%,3.2f",motelService1.getPrice()));
//                    sb.append( (( (i+1) != motelServices.size())  ? " \n" : ""));
//                }
//            }
//        }
        var strText = ""
       if(!motelServices.isEmpty ){
        
        
        
        var index = 0
        for ( service: MotelService) in motelServices {
            
            
            if(service.type == CabanaRDAppConfig.MOTEL_TYPE_HOUSING){
                
                   var formatePrice = ""
                   var formater = CabanaRDAppConfig.currencyFormater
                   formater.currencyCode = CabanaRDAppConfig.currencyTypeString(service.currencyType)
                    formatePrice =  formater.stringFromNumber(service.price)!
              
                
                
                var lineBraker = ((index+1) != motelServices.count) ? "\n" :""
                
                    strText += "\(service.service!) : $\(formatePrice) \(lineBraker)"
                }
                index++
                
            }
       
        }
        return strText
    }
}
//func == (lhs: Motel, rhs: Motel) -> Bool{
//    return lhs.id == rhs.id
//}