//
//  User.swift
//  Dope
//
//  Created by Zach Nafziger on 4/21/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class User{
    var uid:String?
    var imageURL:String?
    var displayName:String?
    var numberOfBattles:Int?
    var numberOfWins:Int?
    init(uid:String, imageURL:String, displayName:String, numberOfBattles:Int = 0, numberOfWins:Int = 0){
        self.uid = uid
        self.imageURL = imageURL
        self.displayName = displayName
        self.numberOfWins = numberOfWins
        self.numberOfBattles = numberOfBattles
    }
}