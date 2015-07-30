//
//  ResultViewController2.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit



class ResultViewController2: UICollectionViewController {
    let reuseIdentifier = "ResultCollectionCell"
    var places = [Place]()
    var places2 = NSMutableOrderedSet()
    var subCatId:String!
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    var selectedCats = Array<Int>()
    

    
    override func viewDidLoad() {
        animate()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()

        
        request(YouNetworking.Router2.Search(selectedCats)).responseJSON{ request, response, JSON, error in
            if error == nil {
                // 4
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    // 5, 6, 7
                    if let js = (JSON as! NSDictionary).valueForKey("content") as? [NSDictionary]{
                        println(js)
                        let photoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Place( id: $0["plc_id"] as! String, name: $0["plc_name"] as! String, image: $0["plc_header_image"], address: $0["plc_address"] as! String, rating: $0["plc_address"] as! String) }
                        
                        let lastItem = self.places.count
                        self.places = photoInfos
                        
                        let indexPaths = (lastItem..<self.places.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        
                        // 11
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                            self.stopAnimation()
                        }
                    }else{
                        self.stopAnimation()
                        let alertController = UIAlertController(title: "Error", message:
                            NSLocalizedString("empty_result", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        /*
            subCatId = "17"
            let url = NSURL(string: "http://www.youbaku.com/api/places.php")
            let req = NSMutableURLRequest(URL: url!)
            req.HTTPMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let values = "{\"op\":\"search\", \"subcat_list\":[37]}"
            var dict = [ "op" : "search", "subcat_list" :selectedCats, "token":"341766447c4ab254450c8b7398e3c6b9","apikey":"160950eb93bc9af51e2b9a79eab53335" ] // dict is Dictionary<Int, String>
            
            let nsDict = dict as NSDictionary
            
            
            var error: NSError?
            req.HTTPBody = NSJSONSerialization.dataWithJSONObject(nsDict, options: nil, error: &error)

        request(req)
            .responseJSON { request, response, JSON, error in
                if error == nil {
                    // 4
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                        // 5, 6, 7
                        if let js = (JSON as! NSDictionary).valueForKey("content") as? [NSDictionary]{
                        let photoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Place( id: $0["plc_id"] as! String, name: $0["plc_name"] as! String, image: $0["plc_header_image"] as! String, address: $0["plc_address"] as! String, rating: $0["plc_address"] as! String) }
                        
                        let lastItem = self.places.count
                        self.places = photoInfos
                        
                        let indexPaths = (lastItem..<self.places.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        
                        // 11
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                            self.stopAnimation()
                        }
                        }else{
                            self.stopAnimation()
                            let alertController = UIAlertController(title: "Error", message:
                                NSLocalizedString("empty_result", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }
*/
        }
        
        
        /*
        request(YouNetworking.Router.Places(subCatId)).responseJSON() {
            (_, _, JSON, error) in
            if error == nil {
                // 4
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    // 5, 6, 7
                    let photoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Place( id: $0["plc_id"] as! String, name: $0["plc_name"] as! String, image: $0["plc_header_image"] as! String, address: $0["plc_address"] as! String, rating: $0["plc_address"] as! String) }
                    
                    let lastItem = self.places.count
                    self.places = photoInfos
                    
                    let indexPaths = (lastItem..<self.places.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                    
                    // 11
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                        self.stopAnimation()
                    }
                }
            }
        }*/
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
            
        }
        
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
        cell.nameLabel.text = places[indexPath.row].plc_name as String
        cell.secondLabel.text = places[indexPath.row].plc_address as String
        
        let urlString = "http://www.youbaku.com/uploads/places_header_images/" + (places[indexPath.row].plc_header_image as String)
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
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width
        return CGSizeMake(picDimension, 210)
    }
    
}

