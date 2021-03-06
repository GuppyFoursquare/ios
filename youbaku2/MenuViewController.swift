//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by Richard Turton on 13/04/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

class MenuViewController: UICollectionViewController, InformationDelegate2 {
    let imageCache = NSCache()
    var cats = [Category]()
    lazy var data = NSMutableData()
    var clickedCatId:String!
    
    let sectionTap = UIGestureRecognizer()
    var cellCounts = Array<Int>()
    var selectedCats = Array<Int>()
    var openSections = Array<Int>()
    var firstSection:MainMenuCVHeader!
    private let reuseIdentifier = "MenuCell"
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
//    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var pointer:NSError?
    
    override func viewWillAppear(animated: Bool) {
        //navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.barTintColor = UIColor(red: 98/255, green: 178/255, blue: 217/255, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        
        

    }
    

    override func viewDidAppear(animated: Bool) {
        
        if(pointer != nil){
            let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                NSLocalizedString("network_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTokens()
        loadPlaces()
        if let title = getLoggedInUser().username{
            changeLoginTitle(NSLocalizedString("logout_text", comment: ""))
        }else{
            changeLoginTitle(NSLocalizedString("login_text", comment: ""))
        }
        let logo = UIImage(named: "banner_home_2.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
       
    }
    
    
    
    func changeLoginTitle(title:String){
        println(navigationItem.title)
        navigationItem.leftBarButtonItem?.title = title
    }
    func saveToken(apikey:String, token:String){
        let apiData = NSKeyedArchiver.archivedDataWithRootObject(apikey)
        NSUserDefaults.standardUserDefaults().setObject(apiData, forKey: "apikey")
        let tokenData = NSKeyedArchiver.archivedDataWithRootObject(token)
        NSUserDefaults.standardUserDefaults().setObject(tokenData, forKey: "token")
        loadTokens()
    }
    func saveLogin(data:NSData){
        let loginData = NSKeyedArchiver.archivedDataWithRootObject(data)
        NSUserDefaults.standardUserDefaults().setObject(loginData, forKey: "login")
    }
    func loadTokens(){
        let tokenData = NSUserDefaults.standardUserDefaults().objectForKey("token") as? NSData
        if let tokenData = tokenData {
            YouNetworking.TOKEN = (NSKeyedUnarchiver.unarchiveObjectWithData(tokenData) as? String)!
        }

        let apiData = NSUserDefaults.standardUserDefaults().objectForKey("apikey") as? NSData
        if let apiData = apiData {
            YouNetworking.APIKEY = (NSKeyedUnarchiver.unarchiveObjectWithData(apiData) as? String)!
        }
        
        
        
    }
    func getLoggedInUser()->UserDetails{
        let loginData = NSUserDefaults.standardUserDefaults().objectForKey("login") as? NSData
        var user:UserDetails = UserDetails()
        if let loginData = loginData {
            var  data = (NSKeyedUnarchiver.unarchiveObjectWithData(loginData) as? NSData)!
            
            var hoge = JSON(data: data)
            if let appDict = hoge["content"].dictionary {
                
                
                user.username = appDict["usr_username"]!.stringValue
                user.email = appDict["usr_email"]!.string!
            }
        }
        return user
    }
    @IBAction func signInTapped(sender: AnyObject) {
        if let username = getLoggedInUser().username{//logout
            animate()
            request(YouNetworking.Router2.Logout()).response(){
                (_,_, data, error) in
                if(error == nil){
                    var hoge = JSON(data: data! as! NSData)
                    println(hoge)
                    if (hoge["status"] == "SUCCESS"){
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
                        self.changeLoginTitle(NSLocalizedString("login_text", comment: ""))
                    }
                }else{
                    let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                        NSLocalizedString("network_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                self.stopAnimation()
            }
        }else{
            let overlayVC = storyboard?.instantiateViewControllerWithIdentifier("overlayViewController") as! OverlayViewController

            prepareOverlayVC(overlayVC)
            overlayVC.delegate = self
            presentViewController(overlayVC, animated: true, completion: nil)
        }
    }

    private func prepareOverlayVC(overlayVC: UIViewController) {
        overlayVC.transitioningDelegate = overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .Custom
    }
    
    func indexPathsForRowsInSectionAtIndex(sectionIndex:Int) -> NSMutableArray
    {
        
        var numberOfRows:Int = cats[sectionIndex].sub_cats.count
        
        var array:NSMutableArray = NSMutableArray()

        if(numberOfRows>0){
            for i in 0...numberOfRows - 1
            {
                array.addObject(NSIndexPath(forRow: i, inSection: sectionIndex))
            }
        }
    
        return array;
    }

    func tapGesture(gesture: UIGestureRecognizer) {
        let section = gesture.view?.tag
        let header = gesture.view as! MainMenuCVHeader
        toggleSection(section!, header: header)
    }
    func toggleSection(section:Int, header:MainMenuCVHeader){
        
        if(openSections.find{$0 == section} == nil){
            openSections.append(section)
            header.arrowImage.image = UIImage(named: "arrow_up.png")
            header.arrowImage.tag = 1
        }else{
            openSections.removeObject(section)
            header.arrowImage.image = UIImage(named: "arrow_down.png")
            header.arrowImage.tag = 0
        }
        var indexPathsToDelete = indexPathsForRowsInSectionAtIndex(section)
        if(cellCounts[section] != 0){
            cellCounts[section] = 0
            self.collectionView!.performBatchUpdates({
                self.collectionView!.deleteItemsAtIndexPaths(indexPathsToDelete as [AnyObject])
                }, completion: nil)
        }else{
            cellCounts[section] = cats[section].sub_cats.count
            self.collectionView!.performBatchUpdates({
                self.collectionView!.insertItemsAtIndexPaths(indexPathsToDelete as [AnyObject])
                }, completion: nil)
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
            
        }else if(segue.identifier == "toResults"){
            if(self.selectedCats.count > 0){
                Globals.filterKeyWord = ""
                Globals.filterOpen = false
                Globals.filterPopular = false
                Globals.filterDistance = -1
                Globals.filterSort = -1
                Globals.filterCount = -1
            
                var svc = segue.destinationViewController as! ResultViewController2;
                svc.selectedCats = self.selectedCats
            }else{
                var selectAlert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: NSLocalizedString("select_category", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                
                selectAlert.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: .Default, handler: { (action: UIAlertAction!) in
                   
                }))
                self.presentViewController(selectAlert, animated: true, completion: nil)
            }
        }else if segue.identifier == "bouncySegue" {
            let overlayVC = segue.destinationViewController as! UIViewController
            prepareOverlayVC(overlayVC)
        }else if (segue.identifier == "toLogin"){
            
        }

    }
    
    func savePlaces(data:NSData){
        let catsData = NSKeyedArchiver.archivedDataWithRootObject(data)
        NSUserDefaults.standardUserDefaults().setObject(catsData, forKey: "cats")
    }
    
    func loadPlaces(){
        animate()
        let catsData = NSUserDefaults.standardUserDefaults().objectForKey("cats") as? NSData
        /*
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
            */
            request(YouNetworking.Router.Categories()).response() {
                (_, _, data, error) in
                if error == nil {
                    // 4
                    println(data)
                    self.cellCounts = []
                    self.cats = []
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                        // 5, 6, 7
                        self.savePlaces(data as! NSData)
                        var token = YouNetworking.TOKEN
                        var hoge = JSON(data: data! as! NSData)
                        if(hoge["status"] == "FAILURE_PERMISSION"){
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
                            self.changeLoginTitle(NSLocalizedString("login_text", comment: ""))
                            request(YouNetworking.Router.Register()).response() {
                                (_, _, data, error) in
                                if error == nil {
                                    var hoge = JSON(data: data! as! NSData)
                                    var cont:Dictionary = hoge["content"].dictionary!
                                    var token = cont["token"]!.stringValue
                                    var apikey = cont["apikey"]!.stringValue
                                    self.saveToken(apikey, token: token)
                                    self.loadPlaces()
                                    return
                                }
                            }
                            
                        }
                        println(hoge)
                        if let appArray = hoge["content"].array {
                            for appDict in appArray {
                                var cat:Category = Category()
                                cat.cat_name = appDict["cat_name"].stringValue
                                cat.cat_image = appDict["cat_image"].string!
                                cat.cat_id = appDict["cat_id"].intValue
                                self.cats.append(cat)
                                self.cellCounts.append(0)
                                

                                request(YouNetworking.Router.SubCategories(appDict["cat_id"].stringValue)).response() {
                                    (_, _, data, error) in
                                    if error == nil {
                                        // 4
                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                                            // 5, 6, 7
                                            self.savePlaces(data as! NSData)
                                            var hoge = JSON(data: data! as! NSData)
                                            
                                            if let appArray = hoge["content"].array {
                                                for appDict in appArray {
                                                    var ct:Category = Category()
                                                    ct.cat_name = appDict["cat_name"].stringValue
                                                    ct.cat_image = appDict["cat_image"].string!
                                                    ct.cat_id = appDict["cat_id"].intValue
                                                    ct.cat_parent_id = appDict["cat_parent_id"].intValue
                                                    
                                                    for cat in self.cats{
                                                        if(cat.cat_id == ct.cat_parent_id){
                                                            cat.sub_cats.append(ct)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    let lastItem = self.cats.count
                                    
                                    let indexPaths = (lastItem..<self.cats.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                                    self.collectionView!.reloadData()
                                    //                        self.collectionView!.registerClass(MainMenuCell.self, forCellWithReuseIdentifier: "MenuCell")
                                    // 11
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                                        self.stopAnimation()
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
      //  }

    }
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
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

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
    

        func find(includedElement: T -> Bool) -> Int? {
            for (idx, element) in enumerate(self) {
                if includedElement(element) {
                    return idx
                }
            }
            return nil
        }
    
}



extension MenuViewController : UICollectionViewDataSource {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return cellCounts.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(cellCounts.count > section){
            return cellCounts[section]
        }else{
            return 0
        }
    }
    
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
      
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MainMenuCell
        
        if(selectedCats.find{$0 == self.cats[indexPath.section].sub_cats[indexPath.row].cat_id} != nil){
            cell.imageView.image = UIImage(named: "tick.png")
        }else{
            cell.imageView.image = nil
        }
        cell.label.text = cats[indexPath.section].sub_cats[indexPath.row].cat_name
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        clickedCatId = String(cats[indexPath.section].sub_cats[indexPath.row].cat_id)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MainMenuCell
        if(cell.imageView.image != nil){
            cell.imageView.image = nil
            self.selectedCats.removeObject(clickedCatId.toInt()!)
        }else{
            cell.imageView.image = UIImage(named: "tick.png")
            self.selectedCats.append(clickedCatId.toInt()!)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "MainMenuCVHeader",
                    forIndexPath: indexPath)
                    as! MainMenuCVHeader
                let im = UIImage(named: "cat_sample.jpg")
                
                headerView.label.text = cats[indexPath.section].cat_name
                if(openSections.find{$0 == indexPath.section} != nil){
                    headerView.arrowImage.image = UIImage(named: "arrow_up.png")
                }else{
                    headerView.arrowImage.image = UIImage(named: "arrow_down.png")
                }

                let url = NSURL(string: YouNetworking.BASEURL + "/uploads/category_images/" + (cats[indexPath.section].cat_image as String))
                
                
                var request = NSURLRequest(URL: url!)
                SimpleCache.sharedInstance.getImage(url!, completion: { (im:UIImage?, err:NSError?) -> () in
                    if(err == nil){
                        headerView.imageView.image = im
                    }else{
                        
                    }
                })
                
                // create tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
                headerView.tag = indexPath.section
                // add it to the image view;
                headerView.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
                headerView.userInteractionEnabled = true
                if(firstSection == nil){
                    firstSection = headerView
                }
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
            return MainMenuCVHeader()
    }

    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    */
    
    func didSignUp() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! ViewControllerRegister
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
}

