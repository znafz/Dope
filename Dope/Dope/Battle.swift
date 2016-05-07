//
//  Battle.swift
//  Dope
//
//  Created by Aaron Rosenberger on 4/19/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

typealias Match = (User, User)

class Battle {
    var match: Match
    var player1, player2: Contestant
    var active: Bool
    
    init(match: Match, active: Bool = false) {
        self.match = match
        self.active = active
        self.player1 = Contestant(user: match.0)
        self.player2 = Contestant(user: match.1)
    }
}