//
//  ResultViewController2.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit



class ResultViewController2: UICollectionViewController, CLLocationManagerDelegate, InformationDelegate {
    
    let reuseIdentifier = "ResultCollectionCell"
    var places = [Place]()
    var allPlaces = [Place]()
    var places2 = NSMutableOrderedSet()
    var subCatId:String!
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    var selectedCats = Array<Int>()
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D!
    var zeroOffset:CGPoint!
    override func viewDidAppear(animated: Bool) {
        

    }
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        zeroOffset = self.collectionView?.contentOffset
        animate()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        var req:YouNetworking.Router2
        if(selectedCats.count > 0){
            req = YouNetworking.Router2.Search(selectedCats)
            self.navigationItem.title = NSLocalizedString("search_results", comment: "")
        }else{
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Popular Places"
            req = YouNetworking.Router2.Popular()
        }
        request(req).responseJSON{ request, response, JSON, error in
            if error == nil {
                // 4
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    // 5, 6, 7
                    if let js = (JSON as! NSDictionary).valueForKey("content") as? [NSDictionary]{
                        println(js)
                        let photoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Place( id: $0["plc_id"] as! String, name: $0["plc_name"] as! String, image: $0["plc_header_image"], address: $0["plc_address"] as! String, rating: $0["plc_address"] as! String,  rating_avg: $0["rating_avg"], rating_count: $0["rating_count"], plc_latitude: $0["plc_latitude"], plc_longitude: $0["plc_longitude"], is_open: $0["plc_is_open"] ) }
                        
                        let lastItem = self.places.count
                        self.places = photoInfos
                        
                        for index in 0...self.places.count-1{
                                if let userLocation = self.userLocation{
                                    var userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                                    var placeLoc = CLLocation(latitude: (self.places[index].plc_latitude as NSString).doubleValue, longitude: (self.places[index].plc_longitude as NSString).doubleValue)

                                    var dist = userLoc.distanceFromLocation(placeLoc)
                                    var dist_km = NSString(format:"%.1f km", (dist.description as NSString).doubleValue / 1000)
                                    self.places[index].plc_distance = dist_km.floatValue
                                }else{
                                    self.places[index].plc_distance = -1
                                }
                        }
                        self.allPlaces = photoInfos
                        let indexPaths = (lastItem..<self.places.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        
                        // 11
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                            self.stopAnimation()
                        }
                    }else{
                        self.stopAnimation()
                        
                        let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                            NSLocalizedString("empty_result", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
      
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
            NSLocalizedString("gps_denied", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            userLocation = location.coordinate
            self.collectionView?.reloadData()
            manager.stopUpdatingLocation()
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        /*
        let url = NSURL(string: "http://10.10.20.173/youbaku/api/places.php?op=nearme&lat=40.372877&lon=49.842825&sub_cat_id=" + subCatId)
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        var hoge = JSON(data: data!)
        
        if let appArray = hoge["content"].array {
            for appDict in appArray {
                var cat:Place = Place()
                cat.plc_id = appDict["plc_id"].intValue
                cat.plc_name = appDict["plc_name"].stringValue
                cat.plc_header_image = appDict["plc_header_image"].stringValue
                cat.plc_address = appDict["plc_address"].stringValue
                cat.rating = appDict["rating"].stringValue
                places.append(cat)
            }
        }
        */
        
    }
    
    func stopAnimation(){
        animating = false;
    }
    func animate(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if(animating == false)
        {
            circleView = CircleView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
            animationImageView = UIImageView()
            animationImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            animationImageView.backgroundColor = UIColor.whiteColor()
            circleView = CircleView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
            animationImageView.addSubview(circleView)
            view.addSubview(animationImageView)
        }
        animating = true
        
        
        
        let duration = 0.5
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        
        let fullRotation = CGFloat(M_PI * 2)
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/2, animations: {
                
                self.circleView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            })
            UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
                self.circleView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            
            }, completion: {finished in
                if(self.animating){
                    self.animate()
                }else{
                    self.circleView.removeFromSuperview()
                    self.animationImageView.removeFromSuperview()
                }
                
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toRestaurant") {
            var svc = segue.destinationViewController as! RestaurantViewController;
            let cell = sender as! ResultCollectionCell
            let indexPath = self.collectionView?.indexPathForCell(cell)
            svc.restId = String(places[indexPath!.row].plc_id)
            
        }else if(segue.identifier == "toFilter"){
            var svc = segue.destinationViewController as! FilterViewController
            svc.places = self.allPlaces
            svc.delegate = self
        }
        
    }
    func getRatingColor(rating:Float) -> UIColor{
        var resColor:UIColor
        if(rating>4){
            resColor = UIColor(red: 93/255, green: 204/255, blue: 78/255, alpha: 1)
        }else if(rating > 3){
            resColor = UIColor(red: 224/255, green: 213/255, blue: 65/255, alpha: 1)
        }else if(rating>2){
            resColor = UIColor(red: 232/255, green: 153/255, blue: 58/255, alpha: 1)
        }else if(rating==0){
            resColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        }else if(rating<=2){
            resColor = UIColor(red: 240/255, green: 82/255, blue: 51/255, alpha: 1)
        }else{
            resColor = UIColor.whiteColor()
        }
        return resColor
    }
}



extension ResultViewController2 : UICollectionViewDataSource {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ResultCollectionCell
        //2
        
        
        
        
        cell.distanceButton.setTitle(NSString(format: "%.1f km", places[indexPath.row].plc_distance) as String, forState: UIControlState.Normal)
        cell.ratingLabel.text = NSString(format: "%.1f", places[indexPath.row].rating_avg) as String + String("/5.0")
        cell.ratingLabel.backgroundColor = self.getRatingColor(places[indexPath.row].rating_avg)
        cell.commentButton.setTitle(" " + String(places[indexPath.row].rating_count), forState: .Normal)
        cell.nameLabel.text = places[indexPath.row].plc_name as String
        cell.secondLabel.text = places[indexPath.row].plc_address as String
        let urlString = YouNetworking.BASEURL + "/uploads/places_header_images/" + (places[indexPath.row].plc_header_image as String)
        cell.imageView.image = UIImage(named: "placeholder_list.png")
        if let image = imageCache.objectForKey(urlString) as? UIImage { // Use the local cache if possible
            cell.imageView.image = image
        } else { // Download from the internet
            
            
            cell.request?.cancel()
            cell.request = request(.GET, urlString).validate(contentType: ["image/*"]).responseImage() {
                (request, _, image, error) in
                if error == nil && image != nil {
                    // The image is downloaded, cache it anyways even if the cell is dequeued and we're not displaying the image
                    imageCache.setObject(image!, forKey: request.URLString)
                    
                    cell.imageView.image = image
                } else {
                    
                }
            }
            
        }

        return cell
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width
        return CGSizeMake(picDimension, 310)
    }
    func didPlacesFiltered(value:[Place]){
        places = value
        self.collectionView?.reloadData()
        
        var rect = self.collectionView?.contentInset.top
        self.collectionView?.setContentOffset(CGPointMake(0, -rect!), animated: true)
        if(places.count == 0){
            let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                NSLocalizedString("empty_result", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
}

