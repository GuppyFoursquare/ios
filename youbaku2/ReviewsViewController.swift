//
//  ReviewsViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 28/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var ratingInfos = [Rating]()
    var currentPlace:Int = -1
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView2.rowHeight = UITableViewAutomaticDimension;
        self.tableView2.estimatedRowHeight = 44.0;
//        self.tableView2.separatorColor = UIColor.clearColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        return ratingInfos.count
    }
    func getRatingColor(rating:Int) -> UIColor{
        var resColor:UIColor
        if(rating>4){
            resColor = UIColor(red: 93/255, green: 204/255, blue: 78/255, alpha: 1)
        }else if(rating > 3){
            resColor = UIColor(red: 224/255, green: 213/255, blue: 65/255, alpha: 1)
        }else if(rating>2){
            resColor = UIColor(red: 232/255, green: 153/255, blue: 58/255, alpha: 1)
        }else if(rating<=2){
            resColor = UIColor(red: 240/255, green: 82/255, blue: 51/255, alpha: 1)
        }else{
            resColor = UIColor.whiteColor()
        }
        return resColor
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath) as! ReviewCell
        cell.ratingLabel.text = String(ratingInfos[indexPath.row].place_rating_rating) + "/5"
        cell.ratingLabel.backgroundColor = getRatingColor(ratingInfos[indexPath.row].place_rating_rating)
        cell.userImage.image = UIImage(named:"placeholder_user")
        cell.userImage.frame = CGRectMake(cell.userImage.frame.origin.x, cell.userImage.frame.origin.y, 75.0, 75.0)
        println(cell.userImage.frame.width)
        cell.content.text = ratingInfos[indexPath.row].place_rating_comment
        cell.detailLabel.text = ratingInfos[indexPath.row].places_rating_created_date + ", " + ratingInfos[indexPath.row].usr_username
        request(.GET, ratingInfos[indexPath.row].usr_profile_picture).validate(contentType: ["image/*"]).responseImage() {
            (request, _, image, error) in
            if error == nil && image != nil {
                // The image is downloaded, cache it anyways even if the cell is dequeued and we're not displaying the image
                imageCache.setObject(image!, forKey: request.URLString)
                
                cell.userImage.image = image
                
                //self.reviewImage.layer.borderColor = UIColor.redColor().CGColor
                //self.reviewImage.layer.borderWidth = 1.5;
            } else {
                /*
                If the cell went off-screen before the image was downloaded, we cancel it and
                an NSURLErrorDomain (-999: cancelled) is returned. This is a normal behavior.
                */
            }
        }
        
        

        return cell

    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toAddReview"){
            var svc = segue.destinationViewController as! AddReviewViewController;
            svc.place_id = currentPlace
        }
    }


}
