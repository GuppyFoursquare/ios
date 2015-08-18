//
//  BookViewController.swift
//  youbaku2
//
//  Created by ulakbim on 18/08/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
        // Do any additional setup after loading the view.
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
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
                self.scrollView.contentInset = contentInset
                /*                self.scrollView.scrollIndicatorInsets = contentInset
                
                var aRect = self.view.frame;
                aRect.size.height -= keyboardSize.height;
                if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
                var scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - keyboardSize.height)
                self.scrollView.setContentOffset(scrollPoint, animated: true)
                }
                */
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }

}
