//
//  ChatViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 19/07/20.
//

import Cocoa
import Parse

class ChatViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var channelDescription: NSTextField!
    
    var channel: PFObject?
    var chats : [PFObject] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
        // Do view setup here.
    }
    @IBAction func sendClicked(_ sender: Any) {
        let chat = PFObject(className: "Chat")
        chat["message"] = messageTextField.stringValue
        chat["user"] = PFUser.current()
        chat["channel"] = channel
        
        chat.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Message sent")
                self.messageTextField.stringValue = ""
                self.getChats()
            } else {
                print("Message couldn't be sent")
            }
        }
    }
    
    func getChats() {
        if channel != nil{
            let query = PFQuery(className: "Chat")
            query.includeKey("user")
            query.whereKey("channel", equalTo: channel!)
            query.order(byAscending: "createdAt")
            query.findObjectsInBackground { (chats:[PFObject]?, error:Error?) in
                if error == nil {
                    if chats != nil {
                        // print(chats!)
                        if chats?.count != self.chats.count {
                            self.chats = chats!
                            self.tableView.reloadData()
                            self.tableView.scrollRowToVisible(self.chats.count - 1)
                        }
                    }
                }
            }
        }
    }
    
    func updateWithChannel(channel: PFObject) {
        self.channel = channel
        self.getChats()
        if let title = channel["title"] as? String {
            titleLabel.stringValue = "#\(title)"
            messageTextField.placeholderString = "Messgae #\(title)"
        }
        if let descrip = channel["descrip"] as? String {
            channelDescription.stringValue = descrip
        }
        
        timer?.invalidate()
        // gets chats every 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer: Timer) in
            print("Getting chats...")
            self.getChats()
        })
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner: nil) as? ChatCell {
            let chat = chats[row]
            if let message = chat["message"] as? String {
                cell.messageLabel.stringValue = message
                if let user = chat["user"] as? PFUser{
                    if let name = user["name"] as? String {
                        cell.nameLabel.stringValue = name
                    }

                    if let imageFile = user["profilePic"] as? PFFileObject {
                        imageFile.getDataInBackground { (data: Data?, error: Error?) in
                            if error == nil {
                                if data != nil {
                                    let image = NSImage(data: data!)
                                    cell.profilePicImageView.image = image
                                }
                            }
                        }
                    }
                }
            }

            if let date = chat.createdAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a"
                cell.timeLabel.stringValue = dateFormatter.string(from: date)
            }
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100.0
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            sendClicked(self)
        }
        return false
        
    }
    
    override func viewWillAppear() {
        clearChat()
    }
    
    func clearChat() {
        channel = nil
        chats = []
        tableView.reloadData()
        titleLabel.stringValue = ""
        channelDescription.stringValue = ""
        messageTextField.placeholderString = ""
        timer?.invalidate()
    }
}
