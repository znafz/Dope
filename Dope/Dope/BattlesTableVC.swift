//
//  BattlesTableVC.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/19/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class BattlesTableVC: UITableViewController {
    
    var dataSource = FirebaseTableViewDataSource()
    let battleController = BattleController()
    var selected: Battle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Firebase(url: "https://popping-inferno-6138.firebaseio.com/battles")
        let query:FQuery = ref.queryOrderedByChild("in_progress").queryEqualToValue(true)
        
        self.dataSource = FirebaseTableViewDataSource(query:query,
                                                      modelClass: FDataSnapshot.self,
                                                      cellClass: UITableViewCell.self,
                                                      cellReuseIdentifier: "battleCell",
                                                      view: self.tableView)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FDataSnapshot // Force cast to an FDataSnapshot
            let battleObject = snap.value
            let uid = snap.key
            var instigator:User!
            var opponent:User!
            FirebaseHelper.getUser(battleObject.valueForKey("instigator") as! String, completionHandler: {inst in
                instigator = inst
                FirebaseHelper.getUser(battleObject.valueForKey("opponent") as! String, completionHandler: {opp in
                    opponent = opp
                    let match = (instigator, opponent) as Match
                    let battle = Battle(uid: uid, match: match)
                    self.battleController.addBattle(battle)
                    cell.textLabel!.text = "\(instigator.displayName!) vs. \(opponent.displayName!)"
                })
                
            })
            
            
        }
        self.tableView.dataSource = self.dataSource
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let splitSequence = cell!.textLabel!.text!.componentsSeparatedByString(" vs. ")
        let player1 = splitSequence[0]
        let player2 = splitSequence[1]
        if let battle = battleController.getBattle(with: player1, and: player2) {
            battleController.viewBattle(battle)
            performSegueWithIdentifier("battleViewerSegue", sender: self)
        } else {
            print("Battle not found with contestants \(player1) and \(player2)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! BattleViewerVC
        dest.battle = selected
        dest.battleController = battleController
    }

}
