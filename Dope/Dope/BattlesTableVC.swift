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

class BattlesTableVC: UITableViewController{
    var dataSource = FirebaseTableViewDataSource()
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
            print(snap.value)
            let battle = snap.value
            var instigator:User!
            var opponent:User!
            FirebaseHelper().getUser(battle.valueForKey("instigator") as! String, completionHandler: {inst in
                instigator = inst
                FirebaseHelper().getUser(battle.valueForKey("opponent") as! String, completionHandler: {opp in
                    opponent = opp
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController
    }

}
