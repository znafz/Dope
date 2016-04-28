//
//  LoginViewController.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {
    
    var loginViewController: FirebaseLoginViewController!
    
    @IBAction func login() {
        if (loginViewController.currentUser() == nil) {
            presentViewController(loginViewController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let firebaseRef = Firebase(url: "https://popping-inferno-6138.firebaseio.com/")
        loginViewController = FirebaseLoginViewController(ref: firebaseRef)
        
        loginViewController.enableProvider(.Password)
        loginViewController.enableProvider(.Facebook)
        //loginViewController.enableProvider(.Twitter)
        loginViewController.passwordAuthProvider = FirebasePasswordAuthProvider(ref: firebaseRef, authDelegate: loginViewController)
        
        loginViewController.didDismissWithBlock { (user: FAuthData!, error: NSError!) -> Void in
            if (user != nil) {
                // Handle user case
                FirebaseHelper().login(user, completionHandler: { success in
                    if(success){
                        self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
                    } else{
                        FirebaseHelper().logout()
                    }
                })
                
            } else if (error != nil) {
                // Handle error case
            } else {
                // Handle cancel case
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.hidden = false
    }

}
