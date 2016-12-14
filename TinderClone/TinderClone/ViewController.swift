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
    var activityIndicator = UIActivityIndicatorView()
 
    
    
    func CreateAlert(title : String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func Indicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpOrLoginButton: UIButton!

    @IBOutlet weak var changeSignUpButton: UIButton!
    
    @IBAction func signUpOrLoginButton(_ sender: Any) {
   
        if usernameTextField.text == "" || passwordTextField.text == "" {
            CreateAlert(title: "ALERT", message: "Please, enter your login and password")
            
        } else {
            
            Indicator()
        }
        
        
        
            if SignUpMode {
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        
                        if let parseError = error?.userInfo["error"] as? String {
                            
                             self.CreateAlert(title: "Uh oh!!", message: parseError)
                        }
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    } else {
                        
                        self.CreateAlert(title: "Sign up!", message: "uhu!")
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                    }
                
                })
        
        
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        
                        if let parseError = error?.userInfo["error"] as? String {
                            
                            self.CreateAlert(title: "OPS", message: parseError)
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    
                    
                    
                        } else {
                            
                            self.CreateAlert(title: "YAY", message: "Time to meet some people!")
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        
                            self.redirectUser()
                    
                    }
                    
                })
                
            }
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        redirectUser()
    }
    
    
    
    func redirectUser() {
    
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil {
                
                 performSegue(withIdentifier: "swipeFromInitialSegue", sender: self)
                
            } else {
            
                 performSegue(withIdentifier: "goToUserInfo", sender: self)
            
            }
        }
    
    }
 
    @IBAction func changeSignUpButton(_ sender: Any) {
        
        
        if SignUpMode{
            //Change to login mode
            SignUpMode = false
            signUpOrLoginButton.setTitle("Login", for: [])
            changeSignUpButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            
            
        } else {
            
            //Change to sign up mode
            SignUpMode = true
            signUpOrLoginButton.setTitle("Sign Up", for: [])
            changeSignUpButton.setTitle("Login", for: [])
            messageLabel.text = "Already have an account?"
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
