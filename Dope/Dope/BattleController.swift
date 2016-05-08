//
//  BattleController.swift
//  Dope
//
//  Created by Aaron Rosenberger on 5/7/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation
import Firebase

class BattleController: NSObject {
    
    // MARK: - Properties
    
    private let battlesRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com/battles")
    private var battles: [Battle] = []
    
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    
    // MARK: - Methods
    
    /**
     Adds a battle to the list of battles.
     - parameter battle: The battle to add
     - returns: If the battle is added, returns the index in the `battles` list.
    */
    func addBattle(battle: Battle) -> Int? {
        if !battles.contains(battle) {
            battles.append(battle)
        } else {
            return nil
        }
        // In order for accessing the latest battle to remain a constant time operation,
        //   we must sort this list by lowest minutesAgoStarted.
        battles.sortInPlace()
        return battles.indexOf(battle)
    }
    
    /**
     Retrieves a battle from the list, given a UID.
     - parameter uid: The identifier string of the battle to search for
     - returns: If the battle was found it is returned, otherwise `nil`
    */
    func getBattle(from uid: String) -> Battle? {
        for battle in battles {
            if battle.uid == uid {
                return battle
            }
        }
        return nil
    }
    
    /**
     Retrieves a battle from the list, given two players' names.
     - parameter player1: The name of player1
     - parameter player2: The name of player2
     - returns: If the battle was found it is returned, otherwise `nil`
    */
    func getBattle(with player1: String, and player2: String) -> Battle? {
        for battle in battles {
            if battle.player1.user.displayName == player1 &&
               battle.player2.user.displayName == player2 {
                return battle
            }
        }
        return nil
    }
    
    /**
     Sets all the parameters necessary to view the battle's live stream.
     Assumes Player1 will start rapping first.
     - parameter battle: The battle to view
    */
    func viewBattle(battle: Battle) {
        if let player1stream = battle.player1.stream {
            if let player2stream = battle.player2.stream {
                Stream.setStream1Name(player1stream)
                Stream.setStream2Name(player2stream)
            }
        }
    }
    
    /// Votes `.Dope` for the given `Battle`.
    func voteDope(battle: Battle, choice: Choice) {
        let ref = battlesRef.childByAppendingPath(battle.uid)
        ref.runTransactionBlock({ currentData in
            let obj = currentData.value
            var value = obj.valueForKey("\(choice.description)_dope") as? Int
            if value == nil {
                value = 0
            }
            currentData.value = value! + 1
            return FTransactionResult.successWithValue(currentData)
        })
    }
    
    /// Votes `.Nope` for the given `Battle`.
    func voteNope(battle: Battle, choice: Choice) {
        let ref = battlesRef.childByAppendingPath(battle.uid)
        ref.runTransactionBlock({ currentData in
            let obj = currentData.value
            var value = obj.valueForKey("\(choice.description)_nope") as? Int
            if value == nil {
                value = 0
            }
            currentData.value = value! + 1
            return FTransactionResult.successWithValue(currentData)
        })
    }
    
    /// Un-votes `.Dope` for the given `Battle`.
    func unVoteDope(battle: Battle, choice: Choice) {
        let ref = battlesRef.childByAppendingPath(battle.uid)
        ref.runTransactionBlock({ currentData in
            let obj = currentData.value
            var value = obj.valueForKey("\(choice.description)_dope") as? Int
            if value == nil {
                value = 0
            }
            currentData.value = value! - 1
            return FTransactionResult.successWithValue(currentData)
        })
    }
    
    /// Un-votes `.Nope` for the given `Battle`.
    func unVoteNope(battle: Battle, choice: Choice) {
        let ref = battlesRef.childByAppendingPath(battle.uid)
        ref.runTransactionBlock({ currentData in
            let obj = currentData.value
            var value = obj.valueForKey("\(choice.description)_nope") as? Int
            if value == nil {
                value = 0
            }
            currentData.value = value! - 1
            return FTransactionResult.successWithValue(currentData)
        })
    }
    
}

enum Vote {
    case Dope
    case Nope
}

enum Choice {
    case Instigator
    case Opponent
}

extension Choice: CustomStringConvertible {
    var description: String {
        switch self {
        case .Instigator:
            return "instigator"
        case .Opponent:
            return "opponent"
        }
    }
}




