//
//  Battle.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/19/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

typealias Match = (User, User)

class Battle: NSObject {
    var uid: String
    var match: Match
    var player1, player2: Contestant
    dynamic var active: Bool
    dynamic var minutesAgoStarted: Int = 0
    
    init(uid: String, match: Match, active: Bool = false) {
        self.uid = uid
        self.match = match
        self.active = active
        self.player1 = Contestant(user: match.0)
        self.player2 = Contestant(user: match.1)
    }
}

extension Battle: Comparable {}

func == (x: Battle, y: Battle) -> Bool {
    return ((x.player1 == y.player1) &&
            (x.player2 == y.player2))
}

func < (x: Battle, y: Battle) -> Bool {
    return (x.minutesAgoStarted < y.minutesAgoStarted)
}