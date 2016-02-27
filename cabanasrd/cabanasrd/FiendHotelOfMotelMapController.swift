//
//  FirstViewController.swift
//  cabanasrd
//
//  Created by arturo mejia marmol on 3/4/15.
//  Copyright (c) 2015 arturo mejia marmol. All rights reserved.
//

import UIKit
import MapKit

class FiendHotelOfMotelMapController: GAITrackedViewController , CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var googleMap: GMSMapView!
    
    @IBInspectable
     var tabSelectedColor : UIColor? {
        didSet{
           self.tabBarController?.tabBar.tintColor = tabSelectedColor
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "FiendMotel View";
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as?  UINavigationController {
          var motelsviewC =   destinationVC.topViewController  as? DetailViewController
            motelsviewC?.motel = sender as? Motel
            
            //destinationVC.motel = sender
            
        }
        //
        print( segue.destinationViewController is UINavigationController)
    }
    
    
    var motels = MotelsHandler.sharedInstance.motels
    let locationManager = CLLocationManager()
    var  circActualPosition : GMSCircle?
    var filteredCandies = [Motel]()
    var motelsMarkets = [Motel:GMSMarker]()
    var provinviasTituloArray = [String]()
    var motelesByProvincia = [[Motel]]()
    var stringToSearch = ""

    
    

// MARK: SEARCH
   
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var resultText = NSLocalizedString("results",comment:"")
        var title :String?
        
        if(searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty){
            if(!motelesByProvincia[section].isEmpty){
               title =  "\(provinviasTituloArray[section].uppercaseString) (\(motelesByProvincia[section].count))"
            }
        } else{
            if(!filteredCandies.isEmpty){
               title = "\(resultText.uppercaseString) (\(filteredCandies.count))"
            }
            
            
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty) ? motelesByProvincia[section].count : filteredCandies.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        var a =  self.searchDisplayController?
        self.searchDisplayController?.setActive(false, animated: true)
        
        var motel:Motel? = nil
        
        if(!stringToSearch.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty){
            motel =  filteredCandies[indexPath.row]
        }else{
            motel =  motelesByProvincia[indexPath.section][indexPath.row]
        }
       
        
       
        var selectedMarker = motelsMarkets[motel!]
        selectedMarker?.title = "\(motel!.name!) \(getDistanceFromSelectedMarkerToUserPosition(selectedMarker!))"
        googleMap.selectedMarker = selectedMarker
        googleMap.camera = GMSCameraPosition.cameraWithLatitude(motel!.latitude,
            longitude: motel!.longitude, zoom: 17)

        updateMotelFromServer(motel!);
        
    }
    
    func getDistanceFromSelectedMarkerToUserPosition(selectedMarker:GMSMarker) -> String  {
                var strdistanceBetweenUserAndActualSelectedMotelInKMORM: String = ""
        
        if ( googleMap?.myLocation != nil)
        {
        var myPosition = CLLocationCoordinate2DMake(googleMap!.myLocation.coordinate.latitude, googleMap!.myLocation.coordinate.longitude)

        var distanceBetweenUserAndActualSelectedMotel = GMSGeometryDistance(selectedMarker.position, myPosition)
       
        
        var nsFormater  = NSNumberFormatter()
        nsFormater.numberStyle =  NSNumberFormatterStyle.DecimalStyle
        nsFormater.maximumFractionDigits = 1;
        
        
        if(distanceBetweenUserAndActualSelectedMotel > 1000){
            distanceBetweenUserAndActualSelectedMotel = distanceBetweenUserAndActualSelectedMotel * 0.001;
            
            strdistanceBetweenUserAndActualSelectedMotelInKMORM = "(\(nsFormater.stringFromNumber(distanceBetweenUserAndActualSelectedMotel)!) KM)"
        }else{
            
            strdistanceBetweenUserAndActualSelectedMotelInKMORM = "(\(nsFormater.stringFromNumber(distanceBetweenUserAndActualSelectedMotel)!) M) "
        }
    }
        
        return strdistanceBetweenUserAndActualSelectedMotelInKMORM
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 //       tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
//        
        
        var cell =  tableView.dequeueReusableCellWithIdentifier("mycell") as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        }
        
        
        var candy : Motel
        
        if(!searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty){
            candy =  filteredCandies[indexPath.row]
        }else{
            candy =  motelesByProvincia[indexPath.section][indexPath.row]
        }
        
        cell?.textLabel?.text = candy.name
        
        if(candy.type == 2){
                   cell?.imageView?.image =  UIImage(named: "hotelMarket")
        
        
                }else{
                    cell?.imageView?.image =  UIImage(named: "motelMarket")
                }
        
        return   cell!
    }
    
    
    
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
        stringToSearch = " "
        controller.searchBar.text = " "

    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return  (searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty) ? provinviasTituloArray.count : 1
    }
    

 
    

    func filterContentForSearchText(searchText: String) {
    stringToSearch = searchText
        var trimSearchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
       
        self.filteredCandies = self.motels.filter({( candy: Motel) -> Bool in
            
            let stringMatch = candy.name!.lowercaseString.rangeOfString(trimSearchText.lowercaseString)
            let stringMatchState = candy.state!.name!.lowercaseString.rangeOfString(trimSearchText.lowercaseString)
            return  (stringMatch != nil || stringMatchState != nil)
        })
        print(filteredCandies.count)
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        if(!searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty){
       
            self.filterContentForSearchText(searchString)
            var tbView = controller.searchResultsTableView
            

            if(tbView.numberOfSections() > 0 && tbView.numberOfRowsInSection(0) > 0){
                controller.searchResultsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }

        }
        return true
    }
    
    
     func searchDisplayController(controller: UISearchDisplayController, willShowSearchResultsTableView tableView: UITableView) {
        tableView.contentInset = UIEdgeInsetsZero
        tableView.contentInset.bottom = CGFloat(50)
        
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero
         tableView.scrollIndicatorInsets.bottom = CGFloat(50)
    }

    
    //
//    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
//        return true
//    }

    // MARK: ADS
  
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL)
            return false
        }
        
        return true
    }
    
    // MARK: MAP
    
    
//    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
//      var custom: CustromInfoView =  CustromInfoView.instanceFromNib()as CustromInfoView
//       // UIView.viewFromNibName("MotelCustomInfoWindow")
//        
//        
//                custom.title.text = marker.title
//                custom.prices.text = marker.snippet
//        return custom
//    }
//    

    
    
    func setUpMotelMarkers(){

        for var index = 0; index < provinviasTituloArray.count; ++index {
           var  provincia = provinviasTituloArray[index]
            motelesByProvincia.append( [])
            for ( motel: Motel) in motels {
            
                if provincia.rangeOfString(motel.state!.name!) != nil{
                     motelesByProvincia[index].append( motel)
                   
                }
            }
        }
        

        
        for ( motel: Motel) in motels {
            
         

            
            var marker = GMSMarker()
            if(motel.type == 2){
                marker.icon =  UIImage(named: "hotelMarket")
            }else{
                marker.icon =  UIImage(named: "motelMarket")
            }
            
            
            marker.position = CLLocationCoordinate2DMake(motel.latitude, motel.longitude)
            marker.title =   motel.name
            marker.snippet = motel.toString()
            marker.map = googleMap
            motelsMarkets[motel] = marker
            
        }
    }
    
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        var stringLatAndLong = "\(marker!.position.latitude),\(marker!.position.longitude)"
        let motel = ((motelsMarkets as NSDictionary).allKeysForObject(marker) as [Motel])
        performSegueWithIdentifier("segDetailPlase", sender: motel)
        
        
//        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
//            
//            UIApplication.sharedApplication().openURL(NSURL(string:
//                "comgooglemaps://?sadd=r&daddr=\(stringLatAndLong)&zoom=14")!)
//            print("comgooglemaps://?center=\(marker!.position.latitude),\(marker!.position.longitude)&zoom=14")
//        } else {
//            var appleLink2 = "http://maps.apple.com/maps?q=\(stringLatAndLong)"
//            var myUrl = NSURL(string: appleLink2)
//            UIApplication.sharedApplication().openURL(myUrl!)
//            
//        }
    }
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let motel = ((motelsMarkets as NSDictionary).allKeysForObject(marker) as [Motel])
        updateMotelFromServer(motel[0]);
        marker?.title = "\(motel[0].name!) \(getDistanceFromSelectedMarkerToUserPosition(marker!))"
    

        
        return false;
    }
    
    func updateMotelFromServer(motel: Motel){
        MotelsHandler.sharedInstance.getUpdateMotelFromServer(motel, callBackSuccesFull: { (newMotel:Motel) -> Void in
            
            dispatch_async(dispatch_get_main_queue(),{
                
                var marker  =  self.motelsMarkets[motel]
                
                
                if(motel.type != newMotel.type){
                    
                    
                    if(newMotel.type == 2){
                        marker?.icon =  UIImage(named: "hotelMarket")
                        
                        
                    }else{
                        marker?.icon =  UIImage(named: "motelMarket")
                    }
                    
                }
                
                if(motel.name != newMotel.name){
                    marker?.title = newMotel.name
                }
                marker?.snippet = newMotel.toString()
                
                
                if(motel.longitude != newMotel.longitude &&
                    motel.latitude != newMotel.latitude){
                        
                        marker?.position.latitude = newMotel.latitude
                        marker?.position.longitude = newMotel.longitude
                }
                
                
                self.motelsMarkets[motel] = nil
                self.motelsMarkets[newMotel] = marker
                self.googleMap.selectedMarker = marker
                print(newMotel.name)
            });
            }, callBackFail: {() -> Void in
                print("errror buscando motel")
                
            }
            
            
        )
    }
    
  
    
    // MARK: CLLocationManagerDelegate
    
    // 1
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            createCircle()
            
        }
        
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            var   eventDate:NSDate = location.timestamp
            var    howRecent:NSTimeInterval = eventDate.timeIntervalSinceNow
            
            // 6
            
            if ( circActualPosition == nil ){
                createCircle();
            }else if(abs(howRecent) < 15.0){
                
                circActualPosition?.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
                
            }
            
            
            //         googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
            
            // 7
            
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()

    }
    // MARK: VIEWCONTROLLER LIFECICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
       //searchBar?.setImage( UIImage(contentsOfFile: "search_white"),state:  .Normal )

        
        searchBar.setImage(UIImage(named: "search_white"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
        
        var searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
        if searchTextField!.respondsToSelector(Selector("attributedPlaceholder")) {
            var color = UIColor.whiteColor()
            let attributeDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search",comment:""), attributes: attributeDict)
        }
        
        
                let path = NSBundle.mainBundle().pathForResource("provincias", ofType: "txt")
        var text = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
        provinviasTituloArray = text.componentsSeparatedByString(",")
        
        
        
        
        let localfilePath = NSBundle.mainBundle().URLForResource("ads", withExtension: "html");
        let requestObj = NSURLRequest(URL: localfilePath!);
        web.loadRequest(requestObj);
        web.scrollView.scrollEnabled = false;
        web.scrollView.bounces = false;
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        var camera = GMSCameraPosition.cameraWithLatitude(18.86471,
            longitude: -71.36719, zoom: 6)
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        locationManager.distanceFilter = 500;
        
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        
        
        
        
        
        
        
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        
        googleMap.myLocationEnabled = true
        googleMap.settings.compassButton = true
        googleMap.settings.myLocationButton = true
        googleMap.camera  = camera
        googleMap.delegate = self
        
        setUpMotelMarkers()
        createCircle()
        
    }
    
    func createCircle(){
        if let location = locationManager.location{
            
            
            if (self.circActualPosition == nil) {
                
                self.circActualPosition = GMSCircle(position: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), radius: 200)
                self.circActualPosition?.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
                self.circActualPosition?.strokeColor = UIColor.orangeColor()
                self.circActualPosition?.strokeWidth = 1
                self.circActualPosition?.map = googleMap
                
                googleMap.camera  = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                    longitude: location.coordinate.longitude, zoom: 16)
            }
           
            
        }
    }
}

