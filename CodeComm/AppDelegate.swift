//
//  AppDelegate.swift
//  CodeComm
//
//  Created by Akshay Anand on 15/07/20.
//

import Cocoa
import Parse

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let config = ParseClientConfiguration {
            (configThing: ParseMutableClientConfiguration) in
            configThing.applicationId = "zlak"
            configThing.server = "http://zlak.herokuapp.com/parse"        
        }
        Parse.initialize(with: config)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

