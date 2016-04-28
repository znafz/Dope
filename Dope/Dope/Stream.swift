//
//  Stream.swift
//  R5ProStream
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit

class Stream: NSObject {
    
    static let sharedInstance = Stream()
    static var dictionary: NSMutableDictionary?
    static var tests: Array<NSMutableDictionary>?
    static var parameters: NSMutableDictionary?
    static var localParameters: NSMutableDictionary?
    
    override init() {
        super.init()
        loadTests()
    }
    
    static func sections() -> Int {
        return 1
    }
    
    static func rowsInSection() -> Int {
        return (Stream.tests?.count)!
    }
    
    static func testAtIndex(index: Int) -> NSDictionary? {
        return tests![index]
    }
    
    static func setHost(ip: String) {
        Stream.parameters?.setValue(ip, forKey: "host")
    }
    
    static func setStreamName(name: String) {
        Stream.parameters?.setValue(name, forKey: "stream1")
    }
    
    static func setStream1Name(name: String) {
        Stream.parameters?.setValue(name, forKey: "stream1")
    }
    
    static func setStream2Name(name: String) {
        Stream.parameters?.setValue(name, forKey: "stream2")
    }
    
    static func setDebug(on: Bool) {
        Stream.parameters?.setValue(true, forKey: "debug_view")
    }
    
    static func setVideo(on: Bool) {
        Stream.parameters?.setValue(true, forKey: "video_on")
    }
    
    static func setAudio(on: Bool) {
        Stream.parameters?.setValue(true, forKey: "audio_on")
    }
    
    static func setLocalOverrides(params: NSMutableDictionary?) {
        Stream.localParameters = params
    }
    
    static func getParameter(param: String) -> AnyObject? {
        if (Stream.localParameters != nil) {
            if (Stream.localParameters?[param] != nil) {
                return Stream.localParameters?[param]
            }
        }
        
        return Stream.parameters?[param]
    }
    
    func loadTests() {
        let path = NSBundle.mainBundle().pathForResource("tests", ofType: "plist")
        
        Stream.dictionary = NSMutableDictionary(contentsOfFile: path!)//readDictionaryFromFile(path!)
        Stream.tests = Array<NSMutableDictionary>()
        
        for (_, myValue) in (Stream.dictionary!.valueForKey("Tests") as? NSDictionary)! {
            Stream.tests?.append(myValue as! NSMutableDictionary)
        }
        
        Stream.tests!.sortInPlace({(dic1: NSMutableDictionary, dic2: NSMutableDictionary) -> Bool in
            if (dic1["name"] as! String == "Home") {
                return true
            } else if(dic2["name"] as! String == "Home") {
                return false
            }
            return dic2["name"] as! String > dic1["name"] as! String
        })
        
        Stream.parameters = Stream.dictionary!.valueForKey("GlobalProperties") as? NSMutableDictionary
        
    }
    
}
