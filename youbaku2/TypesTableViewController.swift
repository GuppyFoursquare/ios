//
//  TypesTableViewController.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

protocol TypesTableViewControllerDelegate: class {
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String])
}

class TypesTableViewController: UITableViewController {
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    var possibleTypesDictionary:Dictionary<String, Dictionary<String,String>> = Dictionary()
  var selectedTypes: [String]!
  weak var delegate: TypesTableViewControllerDelegate!
  var sortedKeys: [String] {
    get {
      return sorted(possibleTypesDictionary.keys)
    }
  }
    
    override func viewWillAppear(animated: Bool) {
        animate()

        let url = NSURL(string: "http://www.youbaku.com/api/category.php")
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if(data != nil){
            var hoge = JSON(data: data!)
            if let appArray = hoge["content"].array {
                for appDict in appArray {
                    
                    var pot:Dictionary<String, String> = Dictionary()
                    pot["img"] = "http://www.youbaku.com/uploads/category_images/" + appDict["cat_image"].stringValue
                    pot["name"] = appDict["cat_name"].stringValue
                        //
                    possibleTypesDictionary[appDict["cat_id"].stringValue] = pot
                }
            }
        }else{
            let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                "Network error occured!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        tableView.reloadData()
        stopAnimation()
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
  // MARK: - Actions
  @IBAction func donePressed(sender: AnyObject) {
    delegate?.typesController(self, didSelectTypes: selectedTypes)
  }
  
  // MARK: - Table view data source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return possibleTypesDictionary.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TypeCell", forIndexPath: indexPath) as! UITableViewCell
    let key = sortedKeys[indexPath.row]
    let pot = possibleTypesDictionary[key]!
    cell.textLabel?.text = pot["name"]
    if(cell.imageView?.image == nil){
        cell.imageView?.image = UIImage(named: "bar")
    }
    cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    
    var urlString:String = pot["img"]!
    
    let url = NSURL(string: urlString)
    if let image = imageCache.objectForKey(urlString) as? UIImage { // Use the local cache if possible
        cell.imageView?.image = image
    } else { // Download from the internet
        
        var request = NSURLRequest(URL: url!)
        SimpleCache.sharedInstance.getImage(url!, completion: { (im:UIImage?, err:NSError?) -> () in
            if(err == nil){
                cell.imageView?.image = im
                cell.imageView?.image = im
            }else{
                
            }
        })
        
    }
    
    cell.accessoryType = contains(selectedTypes!, key) ? .Checkmark : .None
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let key = sortedKeys[indexPath.row]
    if contains(selectedTypes!, key) {
      selectedTypes = selectedTypes.filter({$0 != key})
    } else {
      selectedTypes.append(key)
    }
    
    tableView.reloadData()
  }
}
