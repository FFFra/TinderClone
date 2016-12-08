/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var SignUpMode = true
    
    func CreateAlert(title : String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var signUpOrLoginButton: UIButton!

    
    @IBOutlet weak var changeSignUpButton: UIButton!
    
    
    @IBAction func signUpOrLoginButton(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            CreateAlert(title: "ALERT", message: "Please, enter your login and password")
        }
        
        
    }
    
 
    @IBAction func changeSignUpButton(_ sender: Any) {
        
        
        if SignUpMode{
            //Change to login mode
            
            signUpOrLoginButton.setTitle("Login", for: [])
            changeSignUpButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            SignUpMode = false
            
        } else {
            
            //Change to sign up mode
        
            signUpOrLoginButton.setTitle("Sign Up", for: [])
            changeSignUpButton.setTitle("Login", for: [])
            messageLabel.text = "Already have an account?"
            SignUpMode = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
