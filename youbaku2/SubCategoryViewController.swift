//
//  SubCategoryViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit


class SubCategoryViewController: UICollectionViewController {
    @IBOutlet var myCollectionView: UICollectionView!
    lazy var data = NSMutableData()
    var mainCatId:String!
    var subCats = [Category]()
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    private let reuseIdentifier = "SubMenuCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    override func viewWillAppear(animated: Bool) {
        animate()
        
        let url = NSURL(string: YouNetworking.BASEURL + "/api/category.php?cat_id=" + mainCatId)
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
                    
                }
            }
        }else{
            let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                "Network error occured!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        stopAnimation()
    }
    func hoop(){
        print("hop")
    }
    override func viewDidLoad() {
        /*
        animate()
        request(YouNetworking.Router.SubCategories(mainCatId)).responseJSON(){
            (_, _, JSON, error) in
            if error == nil {
                let subCatInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Category( id: $0["cat_id"] as! String, name: $0["cat_name"] as! String, image: $0["cat_image"] as! String)}
                
                let lastItem = self.subCats.count
                self.subCats = subCatInfos
                
                let indexPaths = (lastItem..<self.subCats.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    self.myCollectionView.insertItemsAtIndexPaths(indexPaths)
                    self.myCollectionView.reloadItemsAtIndexPaths(indexPaths)
                    self.stopAnimation()
                }
                
            }
            else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let alertController = UIAlertController(title: "Error", message:
                        "Network error occured!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        }
*/
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toResults") {
            var svc = segue.destinationViewController as! ResultViewController2;
            let button = sender as! UIButton
            
            svc.subCatId = String(button.tag)
            
        }
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
