//
//  Contestant.swift
//  Dope
//
//  Created by Aaron Rosenberger on 5/7/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class Contestant: NSObject {
    let user: User
    var aid: Bool
    var votes: Int
    var stream: String?
    
    init(user: User, aid: Bool = false, votes: Int = 0) {
        self.user = user
        self.aid = aid
        self.votes = votes
        self.stream = user.uid
    }
}

extension Contestant: Comparable {}

func == (x: Contestant, y: Contestant) -> Bool {
    return (x.user == y.user)
}

func < (x: Contestant, y: Contestant) -> Bool {
    return (x.user < y.user)
}