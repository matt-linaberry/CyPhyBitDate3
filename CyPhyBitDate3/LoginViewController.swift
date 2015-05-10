//
//  LoginViewController.swift
//  CyPhyBitDate3
//
//  Created by Matt Linaberry on 5/10/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func FBLoginPressed(sender: AnyObject) {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            if user == nil {
                println("uh oh the user cancelled the facebook login!")
                return
            }
            else if user.isNew {
                println("user signed up and logged in through facebook!")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection,result,error in
                        var r = result as NSDictionary
                        user["first_name"] = r["first_name"]
                        user["gender"] = r["gender"]
                        var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    user["birthday"] = dateFormatter.dateFromString(r["birthday"] as String)
                    let pictureURL = ((r["picture"] as NSDictionary)["data"] as NSDictionary)["url"] as String
                    let url = NSURL(string: pictureURL)
                    let request = NSURLRequest(URL: url!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                        let imageFile = PFFile(name: "avatar.jpg", data: data)
                        user["picture"] = imageFile
                        user.saveInBackgroundWithBlock(nil)
                    })
                })
            }
            else {
                println("User logged in through facebook!")
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
            self.presentViewController(vc!, animated: true, completion: nil)
            
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
