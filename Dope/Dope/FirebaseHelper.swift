//
//  FirebaseHelper.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    static let sharedInstance = FirebaseHelper()
    static let baseRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com")
    static let usersRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com/users")
    
    static func setOnline(){
        if let uid = CurrentUser.uid{
            print("going online")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(true)
        }
    }
    
    static func getUser(uid: String, completionHandler: User -> Void) {
        let ref = self.usersRef.childByAppendingPath(uid)
        ref.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let image = snapshot.value.objectForKey("image_url") as! String
            let dName = snapshot.value.objectForKey("display_name") as! String
            let numBattles = snapshot.value.objectForKey("number_of_battles") as! Int
            let numWins = snapshot.value.objectForKey("number_of_wins") as! Int
            
            completionHandler(User(uid: uid, imageURL: image, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins))
        })
    }
    
    static func setOffline(){
        if let uid = CurrentUser.uid{
            print("going offline")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(false)
        }
    }
    
    static func getOnline(completionHandler: Bool -> Void) {
        if let uid = CurrentUser.uid {
            let ref = self.usersRef.childByAppendingPath(uid)
            ref.observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                if let online = snapshot.value.objectForKey("online") {
                    let online = online as! Bool
                    completionHandler(online)
                }
            })
        }
    }
    
    static func logout(){
        if let uid = CurrentUser.uid{
            print("logging out")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("logged_in").setValue(false)
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(false)
        }
        baseRef.unauth()
    }
    
    static func createUser(email:String, password:String, displayName:String, completionHandler:(Bool)->(Void)){
        baseRef.createUser(email, password: password,
                    withValueCompletionBlock: { error, result in
                        if error != nil {
                            print("Couldn't create user, \(error)")
                            completionHandler(false)
                        } else {
                            let uid = result["uid"] as? String
                            print("Successfully created user account with uid: \(uid)")
                            let userInfo = ["display_name":displayName, "number_of_battles":0, "number_of_wins":0, "image_url":"http://www.gravatar.com/avatar/00000000000000000000000000000000"]
                            
                            if let id = uid{
                                self.usersRef.childByAppendingPath(id).setValue(userInfo)
                            }
                            completionHandler(true)
                        }
        })
    }
    
    static func login(authData:FAuthData, completionHandler:(Bool)->(Void)){
        // We are now logged in
        //get the user's info
        self.usersRef.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let dName = snapshot.value.objectForKey("display_name") as! String
            let numBattles = snapshot.value.objectForKey("number_of_battles") as! Int
            let numWins = snapshot.value.objectForKey("number_of_wins") as! Int
            var pData = authData.providerData as! Dictionary<String,AnyObject>
            self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("image_url").setValue(authData.providerData["profileImageURL"] as! String)
            CurrentUser.login(authData.uid, email: pData["email"] as! String, token: authData.token, imageURL: pData["profileImageURL"] as! String, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
            print("now logged in as \(CurrentUser.email!)")
            //mark user as logged in and online
            self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("logged_in").setValue(true)
            self.setOnline()
            PushServer.sharedInstance.server.IdsAvailable({ (userId, pushToken) in
                print("user id : \(userId)")
                self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("one_signal_id").setValue(userId)
                completionHandler(true)
            })
            
        })
    }
    
    static func checkLoginState(completionHandler:(Bool)->(Void)){
        baseRef.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                self.usersRef.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    let dName = snapshot.value.objectForKey("display_name") as! String
                    let numBattles = snapshot.value.objectForKey("number_of_battles") as! Int
                    let numWins = snapshot.value.objectForKey("number_of_wins") as! Int
                    var pData = authData.providerData as! Dictionary<String,AnyObject>
                    self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("image_url").setValue(authData.providerData["profileImageURL"] as! String)
                    CurrentUser.login(authData.uid, email: pData["email"] as! String, token: authData.token, imageURL: pData["profileImageURL"] as! String, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
                    print("logged in as \(CurrentUser.email!)")
                    //mark user as logged in and online
                    self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("logged_in").setValue(true)
                    self.setOnline()
                    completionHandler(true)
                })
            } else {
                // No user is signed in
                completionHandler(false)
            }
        })
    }
}