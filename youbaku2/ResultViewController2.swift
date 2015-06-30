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
                    }
                }
            }
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
        
        let url = NSURL(string: "http://berataldemir.com/youbaku/uploads/places_header_images/" + (places[indexPath.row].plc_header_image as String))
        
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        cell.imageView.image = UIImage(data: data!)

        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width
        return CGSizeMake(picDimension, 210)
    }
    
}

