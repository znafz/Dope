//
//  AppDelegate.swift
//  Dope
//
//  Created by Zach Nafziger on 4/16/16.
//  Copyright © 2016 Zach Nafziger. All rights reserved.
//

import UIKit
import FirebaseUI

@UIApplicationMain
class AppDelegate: FirebaseAppDelegate {

    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        _ = CurrentUser.sharedInstance
        _ = FirebaseHelper.sharedInstance
        _ = Stream.sharedInstance
        _ = Stream.dictionary
        _ = RhymeService.sharedInstance
        _ = MatchingService.sharedMatchingInstance
        MatchingService.startUpdating()
        
        PushServer.sharedInstance.server = OneSignal(launchOptions: launchOptions, appId: "bd07345d-ef11-4307-b129-d936a6810241"){ (message, additionalData, isActive) in
            NSLog("OneSignal Notification opened:\nMessage: %@", message)
            
            if additionalData != nil {
                NSLog("additionalData: %@", additionalData)
                // Check for and read any custom values you added to the notification
                // This done with the "Additonal Data" section the dashbaord.
                // OR setting the 'data' field on our REST API.
                if let noteType = additionalData["noteType"] as! String?{
                    print("notification type: \(noteType)")
                    if let opponent = additionalData["opponent"] as! String? {
                        NSLog("opponent: %@", opponent)
                        if let selectedAction = additionalData["actionSelected"] as! String?{
                            print("selected action: \(selectedAction)")
                            if(noteType == "battle" && selectedAction == "accept"){
                                //If the user accepts the fight, go to the battle screen
                                FirebaseHelper.getUser(opponent, completionHandler: {user in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewControllerWithIdentifier("rapBattleLive") as! LiveBattleVC
                                    vc.opponent = user
                                    self.window?.rootViewController = vc
                                })
                                
                            }
                        }
                    }
                }
                
            }
        }
        PushServer.sharedInstance.server.enableInAppAlertNotification(true)
        return true
    }

    override func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    override func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Stream.setAudio(false)
        Stream.setVideo(false)
        FirebaseHelper.setOffline()
    }

    override func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Stream.setAudio(true)
        Stream.setVideo(true)
        FirebaseHelper.setOnline()
    }

    override func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    override func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    override func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }


}

