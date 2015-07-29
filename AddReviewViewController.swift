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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stars.append(star1Btn)
        stars.append(star2Btn)
        stars.append(star3Btn)
        stars.append(star4Btn)
        stars.append(star5Btn)
        
        reviewText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter optional text here..."
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
