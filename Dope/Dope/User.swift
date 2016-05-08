//
//  User.swift
//  Dope
//
//  Created by Zach Nafziger on 4/21/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

/// A user capable of participating in and viewing rap battles.
class User: NSObject {
    var uid:String?
    var imageURL:String?
    var displayName:String?
    var numberOfBattles:Int?
    var numberOfWins:Int?
    dynamic var minutesAgoLastSeen: Int = 0
    
    init(uid:String, imageURL:String, displayName:String, numberOfBattles:Int = 0, numberOfWins:Int = 0, minutesAgoLastSeen: Int = 0){
        self.uid = uid
        self.imageURL = imageURL
        self.displayName = displayName
        self.numberOfWins = numberOfWins
        self.numberOfBattles = numberOfBattles
        self.minutesAgoLastSeen = minutesAgoLastSeen
    }
    
    init(user: User) {
        self.uid = user.uid
        self.imageURL = user.imageURL
        self.displayName = user.displayName
        self.numberOfBattles = user.numberOfBattles
        self.numberOfWins = user.numberOfWins
        self.minutesAgoLastSeen = user.minutesAgoLastSeen
    }
}

extension User: Comparable {}

func == (x: User, y: User) -> Bool {
    return (x.uid == y.uid)
}

func < (x: User, y: User) -> Bool {
    return (x.minutesAgoLastSeen < y.minutesAgoLastSeen)
}
