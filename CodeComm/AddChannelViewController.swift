//
//  AddChannelViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 19/07/20.
//

import Cocoa
import Parse

class AddChannelViewController: NSViewController {
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var descriptionTextFIeld: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func createChannelClicked(_ sender: Any) {
        let channel = PFObject(className: "Channel")
        channel["title"] = titleTextField.stringValue
        channel["descrip"] = descriptionTextFIeld.stringValue
        channel.saveInBackground { (success, error) in
            if success {
                print("Channel created!")
                if let channelVC = self.storyboard?.instantiateController(withIdentifier: "channelVC") as? ChannelsViewController {
                    let query = PFQuery(className: "Channel")
                    query.order(byAscending: "title")
                    query.findObjectsInBackground { (channels: [PFObject]?, error: Error?) in
                        if channels != nil {
                            channelVC.channels = channels!
                        }
                        
                    }
                }                
                self.view.window?.close()
            } else {
                print("Failed to create channel!")
            }
        }
    }
    
}
