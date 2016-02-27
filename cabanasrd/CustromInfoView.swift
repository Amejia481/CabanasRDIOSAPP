//
//  sssss.swift
//  cabanasrd
//
//  Created by Administrator on 4/1/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import UIKit

class CustromInfoView: UIView {

    @IBOutlet weak var title: UILabel!
  
    @IBOutlet weak var prices: UILabel!

  
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MotelCustomInfoWindow", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as UIView
    }
}
