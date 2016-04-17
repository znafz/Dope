//
//  CurrentUser.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class CurrentUser{
    static let sharedInstance = CurrentUser()
    var uid:String?
    var email:String?
    var token:String?
    var imageURL:String?
    var displayName:String?
    var numberOfBattles:Int?
    var numberOfWins:Int?
    func login(uid:String, email:String, token:String, imageURL:String, displayName:String, numberOfBattles:Int = 0, numberOfWins:Int = 0){
        self.uid = uid
        self.email = email
        self.token = token
        self.imageURL = imageURL
        self.displayName = displayName
        self.numberOfWins = numberOfWins
        self.numberOfBattles = numberOfBattles
    }
}