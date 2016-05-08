//
//  SubscribeTestViewController.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

class Subscribe: BaseStream {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultR5VideoViewController()
    }
    
    func play() {
        let config = getConfig()
        // Set up the connection and stream
        let connection = R5Connection(config: config)
        self.subscribeStream = R5Stream(connection: connection)
        self.subscribeStream!.delegate = self
        self.subscribeStream?.client = self;
        currentView?.attachStream(subscribeStream)
        self.subscribeStream!.play(Stream.getParameter("stream1") as! String)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        closeTest()
    }
    
    func onMetaData(data: String) {
        
    }
    
}
