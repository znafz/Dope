//
//  BattleViewerVC.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/28/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit

class BattleViewerVC: UIViewController {

    @IBOutlet weak var str1: UIView!
    
    @IBAction func quit(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // **************************************************************
    // TODO: MAKE THIS CLASS A FIREBASEUI TABLE. It's so much easier.
    // **************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
