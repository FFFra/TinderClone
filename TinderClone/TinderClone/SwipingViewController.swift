//
//  SwipingViewController.swift
//  TinderClone
//
//  Created by Fraschetti on 13/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var displayedUserID = ""
    
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        print(rotation)
        
        var strechAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = strechAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
                print("Not choosen")
                
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepeted"
                
                print("choosen")
            }
            
            
            if acceptedOrRejected != "" && displayedUserID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    print(PFUser.current())
                    
                    self.updateImage()
                    
                })
                
                
            }
            
            
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            strechAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = strechAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
        
    }
    
    func updateImage() {
        let query = PFUser.query()
        
        print(PFUser.current())
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["isInterestedInWomen"])!)
        
        query?.whereKey("isInterestedInWomen", equalTo: (PFUser.current()?["isFemale"])!)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"]{
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"]{
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        
        
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.displayedUserID = user.objectId!
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                          
                            if error != nil {
                                
                                print(error)
                                
                            }
                            
                            if let imageData = data {
                                
                                self.imageView.image = UIImage(data: imageData)
                                
                            }

                          
                        })
                        
                    }
                }
            }
            
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(gesture)
        
        updateImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
        
        }
        
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
