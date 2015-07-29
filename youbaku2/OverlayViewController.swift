//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

class OverlayViewController: UIViewController, UITextFieldDelegate {
    var originWithKeyboard:CGFloat!
    var originWithoutKeyboard:CGFloat!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // These settings are of questionable (OK, they look shit) style, but I never said I was a designer
//    view.layer.cornerRadius = 20.0
//    view.layer.shadowColor = UIColor.blackColor().CGColor
//    view.layer.shadowOffset = CGSizeMake(0, 0)
//    view.layer.shadowRadius = 10
//    view.layer.shadowOpacity = 0.5
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
    view.addGestureRecognizer(tap)
    
  }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidAppear(animated: Bool) {
        originWithKeyboard = self.view.frame.origin.y - 110
        originWithoutKeyboard = self.view.frame.origin.y
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if( textField == self.txtUsername){
            self.txtPassword.becomeFirstResponder()
        }else if(textField == self.txtPassword){
            
        }
        return true
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        
        request(YouNetworking.Router2.Login(txtUsername.text, txtPassword.text)).response() {
            (_, _, data, error) in
            if error == nil {
                var hoge = JSON(data: data! as! NSData)
                println(hoge["content"])
                if let res = hoge["content"].dictionary {
                    if let usr = res["usr_username"]{
                        var xxx = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as! MenuViewController
                        
                        xxx.changeLoginTitle("Logout")
                        xxx.saveLogin(data as! NSData)
                        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
        
        
    }
    

  @IBAction func handleDismissedPressed(sender: AnyObject) {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = originWithKeyboard
    }
    func keyboardWillHide(sender: NSNotification) {
        
        self.view.frame.origin.y = originWithoutKeyboard
    }
    
  
}
