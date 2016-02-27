//
//  DetailViewController.swift
//  cabanasrd
//
//  Created by Administrator on 4/10/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import UIKit

class DetailViewController: GAITrackedViewController, UITableViewDataSource {

 
  

    @IBOutlet weak var lblNamePlace: UILabel!
    
    @IBOutlet weak var lblStatePlace: UILabel!
    @IBOutlet weak var btnSeeRoutePlace: UIButton!
    
    
    @IBOutlet weak var lblRankingPlace: UILabel!
    
    
    @IBOutlet weak var lblCountOfVotePlace: UILabel!
    
    @IBOutlet weak var imgActualPlace: UIImageView!
    
    var motel : Motel?
    var motelDetails = [Int]()
    var titleServices = ["Servicios","Servicios","Tarjetas De Credito","Menu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    
    struct  CONSTANTS{
        static let cellIdentifier = "cell_detail"
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
    }

    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return titleServices[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.cellIdentifier) as UITableViewCell
        var text = ""
        
//        switch indexPath.section {
//        case 0:
//              text =  motel.phones[indexPath.row]
//        case 1:
//            
//             text =  motel.motelServices[indexPath.row].descriptionDetail!
//            
//        case 2:
//            
//            text = "\(motel.creditCards[indexPath.row])"
//            
//        case 3:
//            
//            text = "\(motel.creditCards[indexPath.row])"
//            
//            
//        }
        
        cell.textLabel?.text = text
        
        return cell
    }

}
