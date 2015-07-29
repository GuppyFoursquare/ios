//
//  FilterViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 08/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var sortByLbl: UILabel!
    @IBOutlet var sortRatingLbl: UILabel!
    @IBOutlet var sortLikesLbl: UILabel!
    @IBOutlet var sortDistanceLbl: UILabel!
    @IBOutlet var sortLikesImg: UIImageView!
    @IBOutlet var sortRatingImg: UIImageView!
    @IBOutlet var sortDistanceImg: UIImageView!
    @IBOutlet var distanceText: UILabel!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button20: UIButton!
    @IBOutlet var button30: UIButton!
    @IBOutlet var button40: UIButton!
    @IBOutlet var button50: UIButton!

    @IBOutlet var cancelBtn: UIBarButtonItem!
    let numberButtonTap = UIGestureRecognizer()
    let tapRecDistance = UITapGestureRecognizer()
    let tapRecRating = UITapGestureRecognizer()
    let tapRecLikes = UITapGestureRecognizer()
    
    @IBAction func buttonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func distanceButtonTapped(sender: UIButton) {
        button10.backgroundColor = UIColor.whiteColor()
        button10.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button20.backgroundColor = UIColor.whiteColor()
        button20.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button30.backgroundColor = UIColor.whiteColor()
        button30.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button40.backgroundColor = UIColor.whiteColor()
        button40.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button50.backgroundColor = UIColor.whiteColor()
        button50.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        sender.backgroundColor = UIColor(red: 98/255, green: 178/255, blue: 217/255, alpha: 1)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    func tapGesture(gesture: UIGestureRecognizer) {
        println(gesture.view?.tag)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)//98 178 217
        navigationBar.barTintColor = UIColor(red: 98/255, green: 178/255, blue: 217/255, alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecDistance.addTarget(self, action: "tappedViewDistance")
        tapRecRating.addTarget(self, action: "tappedViewRating")
        tapRecLikes.addTarget(self, action: "tappedViewLikes")
        sortDistanceLbl.addGestureRecognizer(tapRecDistance)
        sortRatingLbl.addGestureRecognizer(tapRecRating)
        sortLikesLbl.addGestureRecognizer(tapRecLikes)
        setBorderForButton(&button10!)
        setBorderForButton(&button20!)
        setBorderForButton(&button30!)
        setBorderForButton(&button40!)
        setBorderForButton(&button50!)
        // Do any additional setup after loading the view.
    }
    
    func setBorderForButton(inout button:UIButton){
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberButtonPressed(sender: AnyObject) {
        print(sender.tag);
    }

    @IBAction func distanceChanged(sender: UISlider) {
        let valKm = NSString(format: "%.1f", sender.value)
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        // Configure the number formatter to your liking
        let val = nf.stringFromNumber(sender.value)
        if(sender.value >= 1){
            distanceText.text =  NSLocalizedString("distance", comment: "") + (valKm as String) + " km"
        }else{
            let valMeter = NSString(format: "%.0f", sender.value * 1000)
            distanceText.text = NSLocalizedString("distance", comment: "") + (valMeter as String) + " m"
        }
    }
    
    
    func tappedViewRating(){
        sortByLbl.text = NSLocalizedString("sort_by_rating", comment: "")
        sortRatingImg.image = UIImage(named: "tick.png")
        sortDistanceImg.image = nil
        sortLikesImg.image = nil
    }
    func tappedViewLikes(){
        sortByLbl.text = NSLocalizedString("sort_by_likes", comment: "")
        sortDistanceImg.image = nil
        sortRatingImg.image = nil
        sortLikesImg.image = UIImage(named: "tick.png")
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
