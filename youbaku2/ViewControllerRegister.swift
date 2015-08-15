
import UIKit

class ViewControllerRegister: UIViewController, UITextFieldDelegate {
    var delegate: InformationDelegate?
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userSurname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassConfirm: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var activeTextField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.activeTextField = textField
    }
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
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

    
    @IBAction func RegisterTapped(sender: AnyObject) {
        /*
        var contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame;
        aRect.size.height -= 50
*/
        /*
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            var scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        }
        */
        if(userFirstName.text.isEmpty || userSurname.text.isEmpty || username.text.isEmpty || userEmail.text.isEmpty || userPass.text.isEmpty || userPassConfirm.text.isEmpty){
            let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                NSLocalizedString("signup_all_fields_requires", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if(userPass.text != userPassConfirm.text){
                let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message:
                    NSLocalizedString("signup_password_not_match", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("ok_title", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            request(YouNetworking.Router2.UserRegister(userFirstName.text , userSurname.text , username.text, userEmail.text, userPass.text, userPassConfirm.text  )).response() {
            (_, _, data, error) in
            if error == nil {
                var hoge = JSON(data: data! as! NSData)
                println(hoge);

                if let status = hoge["status"].string{
                    
                    // -- IF response is SUCCESS then get content
                    if status=="SUCCESS" {
                        
                        if let content = hoge["content"].dictionary {
                            var xxx = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as! MenuViewController
                            
                            xxx.changeLoginTitle("Logout")
                            xxx.saveLogin(data as! NSData)
                            self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        println("İşlem başarılı geri dönebilirsin")
                        
                    // -- IF response is FAILURE_PARAM_MISMATCH then inform user for missing parameter
                    }else if status=="FAILURE_PARAM_MISMATCH" {
                        
                        println("Parameter mismatch error");
                        
                    // -- ELSE
                    }else {
                        
                        println("Unknown error occur");
                        
                    }
                }
                
                
                /*
                if let res = hoge["content"].dictionary {
                    if let usr = res["usr_username"]{
                        var xxx = self.presentingViewController?.childViewControllers[0].childViewControllers[0] as! MenuViewController
                        
                        xxx.changeLoginTitle("Logout")
                        xxx.saveLogin(data as! NSData)
                        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                */
                
                
                
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
protocol InformationDelegate2 {
    func didSignUp()
}