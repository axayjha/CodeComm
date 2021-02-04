//
//  SplitViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 19/07/20.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        if let channelsVC = splitViewItems[0].viewController as? ChannelsViewController {
            if let chatVC = splitViewItems[1].viewController as? ChatViewController {
                channelsVC.chatVC = chatVC
            }
        }
        
        if var frame = view.window?.frame {
            frame.size = CGSize(width: 1000, height: 600)
            view.window?.setFrame(frame, display: true, animate: true)
        }
    }
    
    
}
