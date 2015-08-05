//
//  AddReviewViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 10/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class AddReviewViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet var reviewText: UITextView!
    @IBOutlet var star1Btn: UIButton!
    @IBOutlet var star2Btn: UIButton!
    @IBOutlet var star3Btn: UIButton!
    @IBOutlet var star4Btn: UIButton!
    @IBOutlet var star5Btn: UIButton!
    
    var stars = [UIButton]()
    var placeholderLabel : UILabel!
    var userRating:Int = -1
    var place_id:Int = -1
    var animationImageView:UIImageView!
    var animating = false;
    var circleView:CircleView!
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stars.append(star1Btn)
        stars.append(star2Btn)
        stars.append(star3Btn)
        stars.append(star4Btn)
        stars.append(star5Btn)
        
        reviewText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your review here..."
        placeholderLabel.font = UIFont.italicSystemFontOfSize(reviewText.font.pointSize)
        placeholderLabel.sizeToFit()
        reviewText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, reviewText.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = count(reviewText.text) != 0
        
/*
        tapStar1.addTarget(self, action: "star1Tapped")
        tapStar2.addTarget(self, action: "star1Tapped")
        tapStar3.addTarget(self, action: "star1Tapped")
        tapStar4.addTarget(self, action: "star1Tapped")
        tapStar5.addTarget(self, action: "star1Tapped")
        
        star1.addGestureRecognizer(tapStar1)
        star2.addGestureRecognizer(tapStar2)
        star3.addGestureRecognizer(tapStar3)
        star4.addGestureRecognizer(tapStar4)
        star5.addGestureRecognizer(tapStar5)
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
    
    @IBAction func sendReviewTapped(sender: AnyObject) {
        if(userRating != -1){
            request(YouNetworking.Router2.AddReview(reviewText.text, userRating, place_id)).response(){
                (_,_, data, error) in
                if(error == nil){
                    var hoge = JSON(data: data! as! NSData)
                    if (hoge["status"] == "SUCCESS"){
                        let alertController = UIAlertController(title: "Error", message:
                            NSLocalizedString("review_added", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in self.navigationController?.popViewControllerAnimated(true)}))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }else if(hoge["status"] ==  "FAILURE_COMMENT_MULTIPLE"){
                        let alertController = UIAlertController(title: "Error", message:
                            NSLocalizedString("review_multiple", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss",
                            style: UIAlertActionStyle.Default,
                            handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else if (hoge["status"] ==  "FAILURE_AUTH"){
                        println(hoge)
                        let alertController = UIAlertController(title: "Error", message:
                            NSLocalizedString("login_required_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        alertController.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in let overlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("overlayViewController") as! UIViewController
                            
                            self.prepareOverlayVC(overlayVC)
                            self.presentViewController(overlayVC, animated: true, completion: nil)}))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        println(hoge)
                        let alertController = UIAlertController(title: "Error", message:
                            NSLocalizedString("review_error", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        alertController.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in let overlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("overlayViewController") as! UIViewController
                            
                            self.prepareOverlayVC(overlayVC)
                            self.presentViewController(overlayVC, animated: true, completion: nil)}))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }else{
            let alertController = UIAlertController(title: "Error", message:
                NSLocalizedString("empty_rating", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func prepareOverlayVC(overlayVC: UIViewController) {
        overlayVC.transitioningDelegate = overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .Custom
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
    }
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func starTapped(sender: UIButton) {
        var rating:Int = sender.tag
        userRating = rating
        for (index, element) in enumerate(stars) {
            if(element.tag <= rating){
                (element as UIButton).setImage(UIImage(named: "star_filled.png"),forState: UIControlState.Normal);
            }else{
                (element as UIButton).setImage(UIImage(named: "star_empty.png"),forState: UIControlState.Normal);
            }
        }

    }

    // MARK: - Table view data source

}
