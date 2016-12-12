//
//  UserDetailsViewController.swift
//  TinderClone
//
//  Created by Fraschetti on 12/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    
    func CreateAlert(title : String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var genderSwitch: UISwitch!
    
    @IBOutlet weak var interestedInSwitch: UISwitch!
    
    @IBAction func update(_ sender: Any) {
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {

                    self.CreateAlert(title: "OPS", message: parseError)
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }else{
                
                self.CreateAlert(title: "WOW", message: "You looks good!")
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
            }

            
        })
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            genderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedInSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            
            photo.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let downloadedImage = UIImage(data: imageData){
                        self.userImage.image = downloadedImage
                    }
                }
            })
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
