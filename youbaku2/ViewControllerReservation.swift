//
//  ViewControllerReservation.swift
//  youbaku2
//
//  Created by Kemal Sami KARACA on 15/08/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class ViewControllerReservation: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var reserveName: UITextField!
    @IBOutlet weak var reservePersonCount: UITextField!
    @IBOutlet weak var reserveContact: UITextField!
    @IBOutlet weak var reserveDetail: UITextView!
    @IBOutlet weak var reserveDate: UIDatePicker!

    var activeTextField = UITextField()
    
    var place_id:Int = -1
    
    
    
    
    
    
    
    // ----------------------------------------------
    // MARK: VIEWCONTROLLER INITIAL FUNCTION
    // ----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad();
        reserveName.delegate = self;
        reservePersonCount.delegate = self;
        reserveContact.delegate = self;
        reserveDetail.delegate = self;
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    
    
    
    
    
    
    // ----------------------------------------------
    // MARK: DELEGATE FUNCTIONS
    // ----------------------------------------------
    
    // TEXTFIELD DELEGATE FUNCTION
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }

    // TEXTVIEV DELEGATE FUNCTION
    func textViewDidEndEditing(textView: UITextView) {
        
    }
    
    
    
    
    
    
    
    // ----------------------------------------------
    // MARK: UTIL FUNCTIONS
    // ----------------------------------------------
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                var aRect = self.view.frame;
                aRect.size.height -= keyboardSize.height;
                if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
                    var scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - keyboardSize.height)
                    self.scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    
    
    
    
    
    
    // ----------------------------------------------
    // MARK: EVENTS
    // ----------------------------------------------
    @IBAction func ReserveTapped(sender: AnyObject) {
        
        // Get date from date picker
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.stringFromDate(reserveDate.date)
        
        // Get time from date picker
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: reserveDate.date)
        let timeString = String(components.hour)+":"+String(components.minute)
        
        
        // POST Part
        request(YouNetworking.Router2.Reservation( String(place_id), reservePersonCount.text , dateString, timeString, reserveContact.text, reserveDetail.text )).response() {
            (_, _, data, error) in  if error == nil {
                
                
                var hoge = JSON(data: data! as! NSData)
                println(hoge);
                
                if let status = hoge["status"].string{
                    
                    
                    // -- IF response is SUCCESS then get content
                    if status=="SUCCESS" {

                        // SUCCESS ALERT
                        var authAlert = UIAlertController(title: "SUCCESS", message: "Reservation Request Taken Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        authAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            println("SUCCESS RESERVATION")
                            self.navigationController?.popViewControllerAnimated(true)
                        }))
                        
                        self.presentViewController(authAlert, animated: true, completion: nil)
                        
                        
                    // -- IF response is FAILURE_AUTH then redirect user to login page
                    }else if status=="FAILURE_AUTH" {
                        
                        // AUTH FAILURE ALERT
                        var authAlert = UIAlertController(title: "Login ERROR", message: "You should login before reservation request.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        authAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            println("Handle Ok logic here")
                        }))
                        
                        authAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            println("Handle Cancel Logic here")
                        }))
                        
                        self.presentViewController(authAlert, animated: true, completion: nil)
                        
                    
                    // -- IF response is FAILURE_PARAM_MISMATCH then inform user about error
                    }else if status=="FAILURE_PARAM_MISMATCH" {
                        
                        var message = "UNEXPECTED ERROR "
                        if let content = hoge["content"].string {
                            message = content;
                        }
                        
                        var authAlert = UIAlertController(title: "Parameter ERROR", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        authAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            print("FAILURE_PARAM_MISMATCH - Handle Ok logic here");
                        }))
                        
                        self.presentViewController(authAlert, animated: true, completion: nil)
                        
                        
                    // -- ELSE
                    }else {
                        
                        println("Unknown error occur");
                        
                    }
                }

                
            }
        
        }
    }
    
}