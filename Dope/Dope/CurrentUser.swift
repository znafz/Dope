//
//  CurrentUser.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class CurrentUser: NSObject {
    static let sharedInstance = CurrentUser()
    static var uid:String?
    static var email:String?
    static var token:String?
    static var imageURL:String?
    static var displayName:String?
    static var numberOfBattles:Int?
    static var numberOfWins:Int?
    static func login(uid:String, email:String, token:String, imageURL:String, displayName:String, numberOfBattles:Int = 0, numberOfWins:Int = 0){
        self.uid = uid
        self.email = email
        self.token = token
        self.imageURL = imageURL
        self.displayName = displayName
        self.numberOfWins = numberOfWins
        self.numberOfBattles = numberOfBattles
    }
    
    static func user() -> User {
        return User(uid: uid!, imageURL: imageURL!, displayName: displayName!, numberOfBattles: numberOfBattles!, numberOfWins: numberOfWins!)
    }
}