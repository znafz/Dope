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
        battleController.voteNope(battle, choice: Choice.Instigator)
        battleController.voteDope(battle, choice: Choice.Opponent)
    }
    
    @IBAction func dope(sender: UIButton) {
        battleController.voteDope(battle, choice: Choice.Instigator)
        battleController.voteNope(battle, choice: Choice.Opponent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battleController.watchSwitchRapper() { result in
            let contestant = result
            if contestant == self.battle.player1 {
                if contestant.user == CurrentUser.user() {
                    
                }
            } else if contestant == self.battle.player2 {
                if contestant.user == CurrentUser.user() {
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
