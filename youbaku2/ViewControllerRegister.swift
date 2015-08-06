
import UIKit

class ViewControllerRegister: UIViewController {
    
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userSurname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func RegisterTapped(sender: AnyObject) {
        println("Sample click test");
        
        
        
        request(YouNetworking.Router2.UserRegister(userFirstName.text , userSurname.text , username.text, userEmail.text, userPass.text, userPassConfirm.text  )).response() {
            (_, _, data, error) in
            if error == nil {
                var hoge = JSON(data: data! as! NSData)
                println(hoge);

                if let status = hoge["status"].string{
                    
                    // -- IF response is SUCCESS then get content
                    if status=="SUCCESS" {
                        
                        if let content = hoge["content"].dictionary {
                            println(content);
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}