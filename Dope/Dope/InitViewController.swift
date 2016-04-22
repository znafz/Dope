//
//  InitViewController.swift
//  Dope
//
//  Created by Zach Nafziger on 4/21/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
    
    @IBAction func logout(segue:UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper().checkLoginState({loggedIn in
            if(loggedIn){
                self.performSegueWithIdentifier("homeSegue", sender: self)
            } else{
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        })
        // Do any additional setup after loading the view.
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
