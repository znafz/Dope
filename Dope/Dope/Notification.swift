//
//  Notification.swift
//  Dope
//
//  Created by Zach Nafziger on 4/28/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import Foundation

class Notification: NSObject {
    var message:String!
    var recipientId:String!
    func push(){
        let ref = FirebaseHelper.usersRef.childByAppendingPath(recipientId)
        ref.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if let pushID = snapshot.value.objectForKey("one_signal_id"){
                PushServer.sharedInstance.server.postNotification(["contents": ["en": self.message], "include_player_ids": [pushID as! String]])
            }
            
            
        })
        
    }
    init(message:String, recipientId:String){
        self.message = message
        self.recipientId = recipientId
    }
}

class PushServer{
    static let sharedInstance = PushServer()
    var server:OneSignal!
    
}