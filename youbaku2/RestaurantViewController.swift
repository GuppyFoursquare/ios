//
//  RestaurantViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 25/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit
import MapKit
let imageCache = NSCache()
class RestaurantViewController: UIViewController, UIActionSheetDelegate, UIScrollViewDelegate {
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
    @IBOutlet var fixedButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var siteButton: UIImageView!
    @IBOutlet var faceButton: UIImageView!
    @IBOutlet var twitterButton: UIImageView!
    @IBOutlet var phoneButton: UIImageView!
    @IBOutlet var gpsButton: UIImageView!
    @IBOutlet var descriptionTextView2: UITextView!
    @IBOutlet var addressTextView2: UITextView!
    var ratings = [Rating]()
    var currentPlace:Place!
    var reviewGesture:UIGestureRecognizer!
    deinit{
        scrollView.delegate = nil
    }
    @IBAction func menuButtonTapped(sender: AnyObject) {
        var sheet: UIActionSheet = UIActionSheet();
        sheet.delegate = self;
        let moviesDataPath = NSBundle.mainBundle().pathForResource("Info2", ofType: "plist")
        var moviesData:NSDictionary = NSDictionary(contentsOfFile: moviesDataPath!)!
        var arr:NSArray = moviesData["rest_menu_list"] as! NSArray
        
        for (index, element) in enumerate(arr) {
            sheet.addButtonWithTitle(element as! String)
        }
        /*
        sheet.addButtonWithTitle("Cancel");
        sheet.addButtonWithTitle("A course");
        sheet.addButtonWithTitle("B course");
        sheet.addButtonWithTitle("C course");
*/
        sheet.cancelButtonIndex = 0;
        sheet.showInView(self.view);
    }
    func siteButtonTapped(sender: AnyObject) {
        
        var view:UIView = sender.view!!
        var tag = view.tag
        switch(tag){
        case 1:
            UIApplication.tryURL([
                //       "fb://profile/116374146706", // App
                currentPlace.plc_website
                ])
            break
        case 2:
            
        
            break
        case 3:
            
            break
        case 4:
            UIApplication.tryURL([
                //       "fb://profile/116374146706", // App
                "tel://" + currentPlace.plc_contact
                ])
        case 5:
            if(UIApplication.sharedApplication().canOpenURL(
                NSURL(string: "comgooglemapsurl://")!)){
                    UIApplication.tryURL([
                        //       "fb://profile/116374146706", // App
                        "comgooglemaps://?daddr=" + currentPlace.plc_latitude + "," + currentPlace.plc_longitude
                        ])
                    
            }else{
                var lat1 : NSString = currentPlace.plc_latitude
                var lng1 : NSString = currentPlace.plc_longitude
                
                var latitute:CLLocationDegrees =  lat1.doubleValue
                var longitute:CLLocationDegrees =  lng1.doubleValue
                
                let regionDistance:CLLocationDistance = 10000
                var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                var options = [
                    MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
                ]
                var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                var mapItem = MKMapItem(placemark: placemark)
                mapItem.name = currentPlace.plc_name
                mapItem.openInMapsWithLaunchOptions(options)
            }
            
            /*
            
            */

            break
        default:
            break
        }
        
    }
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    var restId:String!
    override func viewDidAppear(animated: Bool)
    {
        
        var newFrame:CGRect = linkContainer.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.scrollView.contentOffset.y+(self.scrollView.frame.size.height-45);
        newFrame.size.height = 45
        linkContainer.frame = newFrame

    }
    
    func actionSheet(sheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex == 1 ){
        
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddReviewViewController") as! AddReviewViewController
            vc.place_id = currentPlace.plc_id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(buttonIndex == 2 ){
            
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewControllerReservation") as! ViewControllerReservation
            vc.place_id = currentPlace.plc_id
         //   self.navigationController?.pushViewController(vc, animated: true)
            presentViewController(vc, animated: true, completion: nil)
            
        }
        
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
  
        var newFrame:CGRect = linkContainer.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.scrollView.contentOffset.y+(self.scrollView.frame.size.height-45);
        newFrame.size.height = 45
        linkContainer.frame = newFrame;
        /*
        var newFrame:CGRect = fixedButton.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.scrollView.contentOffset.y+(self.scrollView.frame.size.height-30);
        fixedButton.frame = newFrame;
        println(fixedButton.bounds.origin.x)
*/
    }
    func reviewTapped(sender:AnyObject){
        if(ratings[0].place_rating_rating != -1){
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ReviewsViewController") as! ReviewsViewController
            vc.ratingInfos = ratings
            vc.currentPlace = currentPlace.plc_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidLoad() {
       	 super.viewDidLoad()
        scrollView.delegate = self
        
        let tapGesture6 = UITapGestureRecognizer(target: self, action: "reviewTapped:")
        reviewText.addGestureRecognizer(tapGesture6)
        reviewText.userInteractionEnabled = true
        
        let tapGesture7 = UITapGestureRecognizer(target: self, action: "reviewTapped:")
        reviewImage.addGestureRecognizer(tapGesture7)
        reviewImage.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "siteButtonTapped:")
        siteButton.addGestureRecognizer(tapGesture)
        siteButton.userInteractionEnabled = false
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "siteButtonTapped:")
        faceButton.addGestureRecognizer(tapGesture2)
        faceButton.userInteractionEnabled = false
        let tapGesture3 = UITapGestureRecognizer(target: self, action: "siteButtonTapped:")
        twitterButton.addGestureRecognizer(tapGesture3)
        twitterButton.userInteractionEnabled = false
        let tapGesture4 = UITapGestureRecognizer(target: self, action: "siteButtonTapped:")
        phoneButton.addGestureRecognizer(tapGesture4)
        phoneButton.userInteractionEnabled = false
        let tapGesture5 = UITapGestureRecognizer(target: self, action: "siteButtonTapped:")
        gpsButton.addGestureRecognizer(tapGesture5)
        gpsButton.userInteractionEnabled = false
        
        
        animate()
        request(YouNetworking.Router.Place(restId)).responseJSON(){
            (_, _, JSON, error) in
            if error == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    
                    let restInfo = ((JSON as! NSDictionary).valueForKey("content") as! NSDictionary)
                    let rest_name = (restInfo.valueForKey("plc_name") as! String)
                    var rest_desc2=""
                    if let rest_desc = (restInfo.valueForKey("plc_info") as? String){
                        rest_desc2 = rest_desc
                    }
                    var rest_address = ""
                    if let rest_address2 = (restInfo.valueForKey("plc_address") as? String){
                        rest_address = rest_address2
                    }
                    var rest_site = ""
                    if let rest_site2 = restInfo.valueForKey("plc_website") as? String{
                        rest_site = rest_site2
                    }
                    var rest_contact = ""
                    if let rest_contact2 = restInfo.valueForKey("plc_contact") as? String{
                        rest_contact = rest_contact2
                    }
                    var rest_lat = ""
                    if let rest_lat2 = (restInfo.valueForKey("plc_latitude") as? String){
                        rest_lat = rest_lat2
                    }
                    var rest_lon = ""
                    if let rest_lon2 = (restInfo.valueForKey("plc_longitude") as? String){
                        rest_lon = rest_lon2
                    }
                    
                    var rest_id = ""
                    if let rest_id2 = (restInfo.valueForKey("plc_id") as? String){
                        rest_id = rest_id2
                    }
                    var rest_isopen = "0"
                    if let rest_isopen2 = (restInfo.valueForKey("plc_is_open") as? String){
                        rest_isopen = rest_isopen2
                    }
                    
                    let photoInfos = (restInfo.valueForKey("gallery") as! [NSDictionary]).map { Gallery( media: $0["plc_gallery_media"] as! String, isVideo: $0["plc_gallery_is_video"] as! String, seq: $0["plc_gallery_seq"] as! String, isCover: $0["plc_is_cover_image"] as! String, isActive: $0["plc_gallery_is_active"] as! String) }
                    var ratingInfos = [Rating]()

                        if(restInfo.valueForKey("rating") != nil){
                            
                        ratingInfos = (restInfo.valueForKey("rating") as! [NSDictionary]).map { Rating( id: $0["place_rating_id"] as! String, rating: $0["place_rating_rating"] as! String, comment: $0["place_rating_comment"] as! String, date: $0["places_rating_created_date"] as! String, username: $0["usr_username"] as! String, profilePic: $0["usr_profile_picture"] as! String, isActive: $0["places_rating_is_active"] as! String) }
                            //test
                         /*   var rat = Rating(id: "1", rating: "-1", comment: NSLocalizedString("no_comment_yet", comment: ""), date: "", name: "", surname: "", profilePic: "", isActive: "1")
                            ratingInfos.append(rat)
*/
                        }else{
                            var rat = Rating(id: "1", rating: "-1", comment: NSLocalizedString("no_comment_yet", comment: ""), date: "", username: "", profilePic: "", isActive: "1")
                            ratingInfos.append(rat)
                        }
                    self.ratings = ratingInfos
                    let lastItem = self.galleryPhotos.count
                    self.galleryPhotos = photoInfos
                    
                    let indexPaths = (lastItem..<self.galleryPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                    
                    // 11
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentPlace = Place()
                        self.currentPlace.plc_name = rest_name
                        self.currentPlace.plc_meta_description = rest_desc2
                        self.currentPlace.plc_address = rest_address
                        self.currentPlace.plc_latitude = rest_lat
                        self.currentPlace.plc_longitude = rest_lon
                        self.currentPlace.plc_id = (rest_id as NSString).integerValue
                        self.currentPlace.plc_is_open = rest_isopen
                        if let webSite = (rest_site as? String) {
                            self.currentPlace.plc_website = webSite
                            self.siteButton.image = self.siteButton.image!.imageWithColor(UIColor(red: 95/255, green: 165/255, blue: 106/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                            self.siteButton.userInteractionEnabled = true
                        }else{
                            self.siteButton.image = self.siteButton.image!.imageWithColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                        }
                        
                        if let contact = (rest_contact as? String) {
                            self.currentPlace.plc_contact = contact
                            self.phoneButton.image = self.phoneButton.image!.imageWithColor(UIColor(red: 95/255, green: 165/255, blue: 106/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                            self.phoneButton.userInteractionEnabled = true
                        }else{
                            self.phoneButton.image = self.phoneButton.image!.imageWithColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                        }
                        
                        self.gpsButton.image = self.gpsButton.image!.imageWithColor(UIColor(red: 95/255, green: 165/255, blue: 106/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                        self.gpsButton.userInteractionEnabled = true
                        
                        self.faceButton.image = self.faceButton.image!.imageWithColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                        self.twitterButton.image = self.twitterButton.image!.imageWithColor(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                        
                        self.title = rest_name
                        
                        if(rest_isopen == "1"){
                            self.nameLabel.text = rest_name + ": " + NSLocalizedString("open", comment: "")
                        }else{
                            self.nameLabel.text = rest_name + ": " + NSLocalizedString("closed", comment: "")
                        }
                        self.descriptionTextView2.attributedText = rest_desc2.html2AttributedString
                        
                        println(rest_desc2.stringByAppendingString(""))
                        self.addressTextView2.text = rest_address
                        self.reviewText.text = ratingInfos[0].place_rating_comment
                        self.reviewImage.image = UIImage(named: "placeholder_user")
                        request(.GET, ratingInfos[0].usr_profile_picture).validate(contentType: ["image/*"]).responseImage() {
                            (request, _, image, error) in
                            if error == nil && image != nil {
                                // The image is downloaded, cache it anyways even if the cell is dequeued and we're not displaying the image
                                imageCache.setObject(image!, forKey: request.URLString)
                                
                                self.reviewImage.image = image
                                
                                //self.reviewImage.layer.borderColor = UIColor.redColor().CGColor
                                //self.reviewImage.layer.borderWidth = 1.5;
                            } else {
                                /*
                                If the cell went off-screen before the image was downloaded, we cancel it and
                                an NSURLErrorDomain (-999: cancelled) is returned. This is a normal behavior.
                                */
                            }
                        }
                        self.collectionView1!.insertItemsAtIndexPaths(indexPaths)
                        self.collectionView2!.insertItemsAtIndexPaths(indexPaths)
                        self.stopAnimation()
                    }
                    
                    
                }
            }else{
                self.stopAnimation()
                let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                    NSLocalizedString("network_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }

        
        
    }
    func convertText(inputText: String) -> NSAttributedString {
        
        var html = inputText
        
        // Replace newline character by HTML line break
        while let range = html.rangeOfString("\n") {
            html.replaceRange(range, with: "<br />")
        }
        
        // Embed in a <span> for font attributes:
        html = "<span style=\"font-family: Arial; font-size:28pt;\">" + html + "</span>"
        
        let data = html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!
        let attrStr = NSAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil)!
        return attrStr
    }
    
    func stopAnimation(){
        animating = false;
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.collectionView1.reloadData()
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
                
                if(self.animating==false){
                    self.circleView.removeFromSuperview()
                    self.animationImageView.removeFromSuperview()
                }else{
                    self.circleView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                }
            })
            UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
                if(self.animating==false){
                    self.circleView.removeFromSuperview()
                    self.animationImageView.removeFromSuperview()
                }else{
                    self.circleView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }
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


    override func viewWillAppear(animated: Bool) {
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

extension String {
    var html2AttributedString:NSMutableAttributedString {
        
        var tt = NSMutableAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding, NSFontAttributeName:UIFont.systemFontOfSize(14)], documentAttributes: nil, error: nil)!
        tt.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSRange(location: 0,length: tt.length))
        
        tt.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1), range: NSRange(location: 0,length: tt.length))
        
        return tt
    }
    
    func plainTextFromHTML() -> String? {
        
        let regexPattern = "<.*?>"
        var err: NSError?
        
        if let stripHTMLRegex = NSRegularExpression(pattern: regexPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &err) {
            
            let plainText = stripHTMLRegex.stringByReplacingMatchesInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, count(self)), withTemplate: "")
            
            return err == nil ? plainText : nil
        } else {
            println("Warning: failed to create regular expression from pattern: \(regexPattern)")
            return nil
        }
    }
}

extension RestaurantViewController : UICollectionViewDataSource {
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryPhotos.count
    }
    
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let urlString = "http://www.youbaku.com/uploads/places_images/large/" + (galleryPhotos[indexPath.row].plc_gallery_media as String)
        let url = NSURL(string: urlString)
//        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check

        if(collectionView == self.collectionView1){

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell1
            var request = NSURLRequest(URL: url!)
            cell.imageView.image = UIImage(named: "placeholder_list.png")
            SimpleCache.sharedInstance.getImage(url!, completion: { (im:UIImage?, err:NSError?) -> () in
                if(err == nil){
                    cell.imageView.image = im
                }else{
                    
                }
            })
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell2
            //var request = NSURLRequest(URL: url!)
            
            
            if let image = imageCache.objectForKey(urlString) as? UIImage { // Use the local cache if possible
                cell.imageView.image = image
            } else { // Download from the internet
                cell.imageView.image = nil
             
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
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == self.collectionView2){
            var browser = MWPhotoBrowser(photos: galleryPhotos)
            // Set options
            browser.displayActionButton = true // Show action button to allow sharing, copying, etc (defaults to YES)
            browser.displayNavArrows = false // Whether to display left and right nav arrows on toolbar (defaults to NO)
            browser.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
            browser.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
            browser.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
            browser.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
            browser.startOnGrid = true // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
            
            // Optionally set the current visible photo before displaying
            if(indexPath.row<0){
                return
            }
            browser.setCurrentPhotoIndex(UInt(indexPath.row))
            
            self.navigationController?.pushViewController(browser, animated: true)
        }
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
extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}

