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
                
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
                
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
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        self.userImage.image = downloadedImage
                    }
                }
            })
        }
   
//        let urlArray = ["https://staticdelivery.nexusmods.com/mods/1151/images/9853-1-1455347533.jpg", "https://s3.amazonaws.com/cvproducts/CeceliaRobot.jpg", "https://blenderartists.org/forum/attachment.php?attachmentid=215713&d=1360221098", "http://www.episodeseason.com/digital-art/robot-girls/binary-concubine-by-conzpiracy.jpg", "http://www.bandt.com.au/information/uploads/2016/04/melissa-overman-750x500.jpg"]
//        var counter = 0
//        
//        for urlString in urlArray {
//            
//            counter += 1
//            
//            let url = URL(string: urlString)
//            
//            do {
//            
//                let data = try Data(contentsOf: url!)
//                
//                let imageFile = PFFile(name: "photo.png", data: data)
//                let user = PFUser()
//                
//                user["photo"] = imageFile
//                
//                user.username = String(counter)
//                
//                user.password = "password"
//                
//                user["isInterestedInWomen"] = false
//                
//                user["isFemale"] = true
//                
//                let acl = PFACL()
//                acl.getPublicWriteAccess = true
//                user.acl = acl
//                
//                user.signUpInBackground(block: { (success, error) in
//                    
//                    if success {
//                        print("new user signed up")
//                    }
//                })
//                
//                
//            } catch {
//                print ("Could not get data")
//            }
//        }
        
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
