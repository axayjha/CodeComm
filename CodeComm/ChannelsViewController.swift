//
//  ChannelsViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 19/07/20.
//

import Cocoa
import Parse

class ChannelsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var profilePicImageView: NSImageView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var channels : [PFObject] = []
    var chatVC: ChatViewController?
    var addChannelWC : NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        getChannels()
        if let user = PFUser.current() {
            if let name = user["name"] as? String {
                nameLabel.stringValue = name
            }
            
            if let imageFile = user["profilePic"] as? PFFileObject {
                imageFile.getDataInBackground { (data: Data?, error: Error?) in
                    if error == nil {
                        if data != nil {
                            let image = NSImage(data: data!)
                            self.profilePicImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        chatVC?.clearChat()
        PFUser.logOut()
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToLogin()
        }
    }
    @IBAction func addClicked(_ sender: Any) {
        addChannelWC = storyboard?.instantiateController(withIdentifier: "addChannelWC") as? NSWindowController
        addChannelWC?.showWindow(nil)
        
    }
    
    func getChannels() {
        let query = PFQuery(className: "Channel")
        query.order(byAscending: "title")
        query.findObjectsInBackground { (channels: [PFObject]?, error: Error?) in
            if channels != nil {
                self.channels = channels!
                self.tableView.reloadData()
            }
            
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.channels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let channel = self.channels[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelCell"), owner: nil) as? NSTableCellView {
            
            if let title = channel["title"] as? String {
                
                cell.textField?.stringValue = "#\(title)"
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let channel = channels[tableView.selectedRow]
            chatVC?.updateWithChannel(channel: channel)
        }
    }
}
