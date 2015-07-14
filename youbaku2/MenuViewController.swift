//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by Richard Turton on 13/04/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

class MenuViewController: UICollectionViewController {
    let imageCache = NSCache()
    var cats = [Category]()
    lazy var data = NSMutableData()
    var clickedCatId:String!
    
    private let reuseIdentifier = "MenuCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var pointer:NSError?
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor(red: 98/255, green: 178/255, blue: 217/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        loadPlaces()
        
    }
    override func viewDidAppear(animated: Bool) {
        
        if(pointer != nil){
            let alertController = UIAlertController(title: "Error", message:
                NSLocalizedString("network_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toSubCats") {
            var svc = segue.destinationViewController as! SubCategoryViewController;
            let cell = sender as! MainMenuCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            println(indexPath!.row)
            println(cats[indexPath!.row].cat_id)
            svc.mainCatId = String(cats[indexPath!.row].cat_id)
            
        }

    }
    
    func savePlaces(data:NSData){
        let catsData = NSKeyedArchiver.archivedDataWithRootObject(data)
        NSUserDefaults.standardUserDefaults().setObject(catsData, forKey: "cats")
    }
    
    func loadPlaces(){
        let catsData = NSUserDefaults.standardUserDefaults().objectForKey("cats") as? NSData
        
        if let catsData = catsData {
           var  data = (NSKeyedUnarchiver.unarchiveObjectWithData(catsData) as? NSData)!
            
            var hoge = JSON(data: data)
            cats = []
            if let appArray = hoge["content"].array {
                for appDict in appArray {
                    var cat:Category = Category()
                    cat.cat_name = appDict["cat_name"].stringValue
                    cat.cat_image = appDict["cat_image"].string!
                    cat.cat_id = appDict["cat_id"].intValue
                    cats.append(cat)
                }
            }
        }else{
            /*
            let url = NSURL(string: "http://10.10.20.173/youbaku/api/category.php")
            var request = NSURLRequest(URL: url!)
            
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: &pointer)
            
            
            if(pointer == nil){
                savePlaces(data!)
                var hoge = JSON(data: data!)
                
                if let appArray = hoge["content"].array {
                    for appDict in appArray {
                        var cat:Category = Category()
                        cat.cat_name = appDict["cat_name"].stringValue
                        cat.cat_image = appDict["cat_image"].string!
                        cat.cat_id = appDict["cat_id"].intValue
                        cats.append(cat)
                    }
                }
            }
*/
            request(YouNetworking.Router.Categories()).response() {
                (_, _, data, error) in
                if error == nil {
                    // 4
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                        // 5, 6, 7
                        self.savePlaces(data as! NSData)
                        var hoge = JSON(data: data! as! NSData)
                        
                        if let appArray = hoge["content"].array {
                            for appDict in appArray {
                                var cat:Category = Category()
                                cat.cat_name = appDict["cat_name"].stringValue
                                cat.cat_image = appDict["cat_image"].string!
                                cat.cat_id = appDict["cat_id"].intValue
                                self.cats.append(cat)
                            }
                        }
                        
                        let lastItem = self.cats.count
                        
                        let indexPaths = (lastItem..<self.cats.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        self.collectionView!.reloadData()
//                        self.collectionView!.registerClass(MainMenuCell.self, forCellWithReuseIdentifier: "MenuCell")
                        // 11
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                        }
                    }
                }
            }
        }
    }
}

extension MenuViewController : UICollectionViewDataSource {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
      
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MainMenuCell
        //2
        
        //let flickrPhoto = photoForIndexPath(indexPath)

        //3
        let url = NSURL(string: "http://192.168.2.50/youbaku/uploads/category_images/" + (cats[indexPath.row].cat_image as String))
        
        
            var request = NSURLRequest(URL: url!)
            SimpleCache.sharedInstance.getImage(url!, completion: { (im:UIImage?, err:NSError?) -> () in
                if(err == nil){
                    cell.imageView.image = im
                }else{
                    
                }
            })
            /*
        
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            if data != nil {

                var image = UIImage(data: data!)
                cell.imageView.image = image
                self.imageCache.setObject(image!, forKey: url!.URLString)
            }
*/
        
//        cell.imageView.image = UIImage(named: "cinema.jpg")
        cell.label.lineBreakMode = NSLineBreakMode.ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell.label.numberOfLines = 0
        cell.label.text=cats[indexPath.row].cat_name as String
        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        clickedCatId = String(cats[indexPath.row].cat_id)
    }
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    */    
    
    
}

