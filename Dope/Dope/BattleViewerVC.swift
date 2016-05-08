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
    @IBOutlet weak var currentPlayer: UILabel!
    
    var battle: Battle!
    var battleController: BattleController!
    
    @IBAction func quit(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nope(sender: UIButton) {
        
    }
    
    @IBAction func dope(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
