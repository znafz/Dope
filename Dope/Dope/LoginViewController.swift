//
//  LoginViewController.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var invalidLabel:UILabel!
    
    
    
    @IBAction func login(){
        // Create a reference to a Firebase location
        indicator.hidden = false
        loginButton.hidden = true
        loginButton.enabled = false
        if let email = emailField.text, password = passwordField.text{
            FirebaseHelper().login(email, password: password, completionHandler: {success in
                if(success){
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                } else{
                    self.indicator.hidden = true
                    self.loginButton.hidden = false
                    self.loginButton.enabled = true
                    self.invalidLabel.hidden = false
                }
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidden = true
        invalidLabel.hidden = true
        self.navigationController?.navigationBarHidden = true

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
