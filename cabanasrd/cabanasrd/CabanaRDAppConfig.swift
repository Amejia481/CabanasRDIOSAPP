//
//  CabanaRDAppConfig.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import Foundation

class CabanaRDAppConfig {
    var appServerVersion = 0
    
    
    class var MOTEL_TYPE_HOUSING: Int
        {
        get { return 1 }
    }
    
    class var urlServer: String
        {
        get { return "http://cabanasrdapi.azurewebsites.net/" }
    }
    class var currencyFormater:NSNumberFormatter
        {
        get {
            
            var nsFormater  = NSNumberFormatter()
            nsFormater.numberStyle =  NSNumberFormatterStyle.CurrencyStyle
            return nsFormater }
    }
    
    
    class func currencyTypeString(type:Int) -> String                {
        var curencyString  = ""
        switch (type) {
        case  1:
            curencyString = NSLocalizedString("DOP",comment:"")
            break
            
        case  2:
            curencyString = NSLocalizedString("USD",comment:"")
            
            break
            
        case  3:
            curencyString = NSLocalizedString("EUR",comment:"")
            break
            
        default:
            curencyString = NSLocalizedString("DOP",comment:"")
            
        }
        
        return curencyString
    }
    
    
    
    
    
    
}