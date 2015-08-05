//
//  FilterViewController.swift
//  youbaku2
//
//  Created by ULAKBIM on 08/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate {
    var delegate: InformationDelegate?
    

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var sortByLbl: UILabel!
    @IBOutlet var sortRatingLbl: UILabel!
    @IBOutlet var sortDistanceLbl: UILabel!
    @IBOutlet var sortRatingImg: UIImageView!
    @IBOutlet var sortDistanceImg: UIImageView!
    @IBOutlet var distanceText: UILabel!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button20: UIButton!
    @IBOutlet var button30: UIButton!
    @IBOutlet var button40: UIButton!
    @IBOutlet var button50: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var isOpenToggle: UISwitch!
    @IBOutlet var isPopularToggle: UISwitch!
    @IBOutlet var keywordTxt: UITextField!

    @IBOutlet var cancelBtn: UIBarButtonItem!
    let numberButtonTap = UIGestureRecognizer()
    let tapRecDistance = UITapGestureRecognizer()
    let tapRecRating = UITapGestureRecognizer()
    var places = [Place]()
    
    var isOpen = false
    var isPopular = false
    var placeLimit = 20
    var distanceLimit = 2.0
    var sortType = -1
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    @IBAction func buttonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func filterButtonTapped(sender: AnyObject) {
        
        for index in stride(from: places.count - 1, through: 0, by: -1) {
            if(keywordTxt.text != ""){
                if (places[index].plc_name.lowercaseString.rangeOfString(keywordTxt.text) == nil) {
                    places.removeAtIndex(index)
                    continue
                }
            }
            if(isOpenToggle.on){
                if(places[index].plc_is_open != "1"){
                    places.removeAtIndex(index)
                    continue
                }
            }
            /* //popular?
            if(isPopularToggle.on){
                if(places[index].plc_ != "1"){
                    places.removeAtIndex(index)
                    continue
                }
            }*/
            /*
            if(distanceLimit != -1.0 && distanceLimit < places[index].plc_distance){
                places.removeAtIndex(index)
                continue
            }
*/
        }
//        images.sort({ $0.fileID > $1.fileID })
        if(sortType == 0){
            places.sort({ $0.plc_distance > $1.plc_distance })
        }else if(sortType == 1){
            places.sort({ $0.rating_avg > $1.rating_avg })
        }
        if(places.count > placeLimit){
            places = Array(places[0..<placeLimit])
        }
        if let d = self.delegate {
            d.didPlacesFiltered(places)
        }
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
        if let buttonText = sender.titleLabel?.text{
            placeLimit = (buttonText as NSString).integerValue
        }

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
        sortDistanceLbl.addGestureRecognizer(tapRecDistance)
        sortRatingLbl.addGestureRecognizer(tapRecRating)
        setBorderForButton(&button10!)
        setBorderForButton(&button20!)
        setBorderForButton(&button30!)
        setBorderForButton(&button40!)
        setBorderForButton(&button50!)
        button20.backgroundColor = UIColor(red: 98/255, green: 178/255, blue: 217/255, alpha: 1)
        button20.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
        distanceLimit = valKm.doubleValue
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
        sortType = 1
        sortByLbl.text = NSLocalizedString("sort_by_rating", comment: "")
        sortRatingImg.image = UIImage(named: "tick.png")
        sortDistanceImg.image = nil
    }
    func tappedViewDistance(){
        sortType = 0
        sortByLbl.text = NSLocalizedString("sort_by_distance", comment: "")
        sortDistanceImg.image = UIImage(named: "tick.png")
        sortRatingImg.image = nil
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
protocol InformationDelegate {
    func didPlacesFiltered(value: [Place])
}
