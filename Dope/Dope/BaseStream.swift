//
//  BaseStream.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

class BaseStream: UIViewController, R5StreamDelegate {
    
    func onR5StreamStatus(stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        NSLog("Status: %s ", r5_string_for_status(statusCode))
        let s =  String(format: "Status: %s (%@)",  r5_string_for_status(statusCode), msg)
        ALToastView.toastInView(self.view, withText:s)
    }
    
    var currentView: R5VideoViewController? = nil
    var publishStream: R5Stream? = nil
    var subscribeStream: R5Stream? = nil
    
    func closeTest() {
        NSLog("closing view")
        if (self.publishStream != nil) {
            self.publishStream!.stop()
        }
        if (self.subscribeStream != nil) {
            self.subscribeStream!.stop()
        }
        self.removeFromParentViewController()
    }
    
    func getConfig() -> R5Configuration {
        // Set up the configuration
        let config = R5Configuration()
        print(Stream.parameters)
        config.host = Stream.getParameter("host") as! String
        config.port = Int32(Stream.getParameter("port") as! Int)
        config.contextName = Stream.getParameter("context") as! String
        config.`protocol` = 1;
        config.buffer_time = Stream.getParameter("buffer_time") as! Float
        return config
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (currentView != nil) {
            currentView?.setFrame(view.frame);
        }
    }
    
    func setupPublisher(connection: R5Connection) {
        
        self.publishStream = R5Stream(connection: connection)
        self.publishStream!.delegate = self
        
        if (Stream.getParameter("video_on") as! Bool) {
            // Attach the video from camera to stream
            let videoDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).last as? AVCaptureDevice
            let camera = R5Camera(device: videoDevice, andBitRate: Int32(Stream.getParameter("bitrate") as! Int))
            camera.width = 900
            camera.height = 600
            camera.orientation = 90
            self.publishStream!.attachVideo(camera)
        }
        if (Stream.getParameter("audio_on") as! Bool) {
            // Attach the audio from microphone to stream
            let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
            let microphone = R5Microphone(device: audioDevice)
            microphone.bitrate = 32
            microphone.device = audioDevice;
            NSLog("Got device %@", audioDevice)
            self.publishStream!.attachAudio(microphone)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().requestRecordPermission { (gotPerm: Bool) -> Void in
            
        };
        
        r5_set_log_level((Int32)(r5_log_level_debug.rawValue))
        self.view.autoresizesSubviews = true
    }
    
    func setupDefaultR5VideoViewController() -> R5VideoViewController {
        let r5View: R5VideoViewController = getNewR5VideoViewController(self.view.frame);
        self.addChildViewController(r5View);
        view.addSubview(r5View.view)
        r5View.showPreview(true)
        if let debug = Stream.getParameter("debug_view") {
            let debug = debug as! Bool
            r5View.showDebugInfo(debug)
        }
        currentView = r5View;
        return currentView!
    }
    
    func getNewR5VideoViewController(rect : CGRect) -> R5VideoViewController{
        let view : UIView = UIView(frame: rect)
        let r5View : R5VideoViewController = R5VideoViewController();
        r5View.view = view;
        return r5View;
    }

}
