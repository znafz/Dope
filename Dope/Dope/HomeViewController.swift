//
//  HomeViewController.swift
//  Dope
//
//  Created by Zach Nafziger on 4/21/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    @IBAction func logout(){
        FirebaseHelper.logout()
        performSegueWithIdentifier("logout", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "08 Underground", size: 28)!,  NSForegroundColorAttributeName: UIColor.blackColor()]
        self.navigationController?.navigationBarHidden = false
        
        FirebaseHelper.getOnlineUsers({user in (print(user.displayName))})
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        
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
