//
//  RestaurantViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 25/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    let reuseIdentifier = "Cell"
    var galleryPhotos = [Gallery]()
    
    @IBOutlet var collectionView1: UICollectionView!
    @IBOutlet var collectionView2: UICollectionView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var addressTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reviewImage: UIImageView!
    @IBOutlet var reviewText: UITextView!
    @IBOutlet var reviewDetail: UILabel!
/*
    override func viewDidAppear(animated: Bool)
    {
        let contentSize = self.descriptionTextView.sizeThatFits(self.descriptionTextView.bounds.size)
        var frame = descriptionTextView.frame
        frame.size.height = contentSize.height
        descriptionTextView.frame = frame
        
        let contentSize2 = self.addressTextView.sizeThatFits(self.addressTextView.bounds.size)
        var frame2 = addressTextView.frame
        frame.size.height = contentSize2.height
        addressTextView.frame = frame2

    }
    
    override func viewDidLoad() {
       	 super.viewDidLoad()
        
        self.descriptionTextView.layoutIfNeeded()
        self.addressTextView.layoutIfNeeded()

    }
*/
    override func viewWillAppear(animated: Bool) {
        request(YouNetworking.Router.Place("2")).responseJSON(){
            (_, _, JSON, error) in
            if error == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    /*
                    let photoInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Gallery( media: $0["plc_gallery_media"] as! String, isVideo: $0["plc_gallery_is_video"] as! Int, seq: $0["plc_gallery_seq"] as! Int, isCover: $0["plc_is_cover_image"] as! Int, isActive: $0["plc_gallery_is_active"] as! Int) }
                    
                    let lastItem = self.galleryPhotos.count
                    self.galleryPhotos = photoInfos
                    
                    let indexPaths = (lastItem..<self.galleryPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                    
                    // 11
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView1!.insertItemsAtIndexPaths(indexPaths)
                    }
*/
                    
                }
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RestaurantViewController : UICollectionViewDataSource {
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        
        cell.imageView2.image = UIImage(named: "18.jpg")
        return cell
    }

    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    let leftRightInset = self.view.frame.size.width / 14.0
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    */
       
}

extension RestaurantViewController : UICollectionViewDelegateFlowLayout {
    

    //1
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            if(collectionView == self.collectionView1){
                let screenSize: CGRect = UIScreen.mainScreen().bounds
            //2
                let collectionViewSize: CGRect = collectionView.bounds
            
                return CGSize(width: collectionViewSize.width, height: collectionViewSize.height)
            }else{
                return CGSize(width: 90, height: 90)
            }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if(collectionView == self.collectionView1){
            return 0
        }else{
            return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        /*if(collectionView == self.collectionView1){
            return CGSizeZero
        }else{
            return CGSizeMake(10, 10)
        }*/
        return CGSizeZero
    }
    

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if(collectionView == self.collectionView1){
            return 0
        }else{
            return 10
        }
    }
    /*
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            if(collectionView == self.collectionView1){
                let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
                return sectionInsets
            }else{
                let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                return sectionInsets
            }
    }*/

    
}

