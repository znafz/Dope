//
//  FirebaseHelper.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper{
    
    let baseRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com")
    let usersRef = Firebase(url:"https://popping-inferno-6138.firebaseio.com/users")
    
    func setOnline(){
        if let uid = CurrentUser.sharedInstance.uid{
            print("going online")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(true)
        }
    }
    
    func getUser(uid:String, completionHandler:(User)->(Void)){
        let ref = self.usersRef.childByAppendingPath(uid)
        ref.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let image = snapshot.value.objectForKey("image_url") as! String
            let dName = snapshot.value.objectForKey("display_name") as! String
            
            completionHandler(User(uid: uid, imageURL: image, displayName: dName))
        })
    }
    
    func setOffline(){
        if let uid = CurrentUser.sharedInstance.uid{
            print("going offline")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(false)
        }
    }
    
    func logout(){
        
        if let uid = CurrentUser.sharedInstance.uid{
            print("logging out")
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("logged_in").setValue(false)
            self.usersRef.childByAppendingPath(uid).childByAppendingPath("online").setValue(false)
        }
        baseRef.unauth()
    }
    func createUser(email:String, password:String, displayName:String, completionHandler:(Bool)->(Void)){
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
    
    func login(email:String, password:String, completionHandler:(Bool)->(Void)){
        baseRef.authUser(email, password: password,
                         withCompletionBlock: { error, authData in
                            if error != nil {
                                // There was an error logging in to this account
                                print("couldn't log in")
                                completionHandler(false)
                            } else {
                                // We are now logged in
                                //get the user's info
                                self.usersRef.childByAppendingPath(authData.uid).observeSingleEventOfType(.Value, withBlock: {
                                    snapshot in
                                    let dName = snapshot.value.objectForKey("display_name") as! String
                                    let numBattles = snapshot.value.objectForKey("number_of_battles") as! Int
                                    let numWins = snapshot.value.objectForKey("number_of_wins") as! Int
                                    var pData = authData.providerData as! Dictionary<String,AnyObject>
                                    self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("image_url").setValue(authData.providerData["profileImageURL"] as! String)
                                    CurrentUser.sharedInstance.login(authData.uid, email: pData["email"] as! String, token: authData.token, imageURL: pData["profileImageURL"] as! String, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
                                    print("logged in as \(CurrentUser.sharedInstance.email!)")
                                    //mark user as logged in and online
                                    self.usersRef.childByAppendingPath(authData.uid).childByAppendingPath("logged_in").setValue(true)
                                    self.setOnline()
                                    
                                    completionHandler(true)
                                })
                                
                            }
        })
    }
    
    func checkLoginState(completionHandler:(Bool)->(Void)){
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
                    CurrentUser.sharedInstance.login(authData.uid, email: pData["email"] as! String, token: authData.token, imageURL: pData["profileImageURL"] as! String, displayName: dName, numberOfBattles: numBattles, numberOfWins: numWins)
                    print("logged in as \(CurrentUser.sharedInstance.email!)")
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