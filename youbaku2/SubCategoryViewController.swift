//
//  SubCategoryViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit


class SubCategoryViewController: UICollectionViewController {
    lazy var data = NSMutableData()
    var mainCatId:String!
    var subCats = [Category]()
    private let reuseIdentifier = "SubMenuCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string: "http://berataldemir.com/youbaku/api/category.php?cat_id=" + mainCatId)
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if(data != nil){
            var hoge = JSON(data: data!)
            if let appArray = hoge["content"].array {
                for appDict in appArray {
                    var cat:Category = Category()
                    cat.cat_name = appDict["cat_name"].stringValue
                    cat.cat_image = appDict["cat_image"].string!
                    cat.cat_id = appDict["cat_id"].intValue
                    subCats.append(cat)
                }
            }
        }else{
            let alertController = UIAlertController(title: "Error", message:
                "Network error occured!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toResults") {
            var svc = segue.destinationViewController as! ResultViewController2;
            let button = sender as! UIButton
            
            svc.subCatId = String(button.tag)
            
        }
    }
}

extension SubCategoryViewController : UICollectionViewDataSource {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCats.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SubMenuCell
        cell.button.tag = subCats[indexPath.row].cat_id
        cell.button.setTitle(subCats[indexPath.row].cat_name as String, forState: .Normal)
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(10, leftRightInset,10, leftRightInset)
    }
        
    
}
