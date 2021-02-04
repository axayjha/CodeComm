//
//  ChatCell.swift
//  CodeComm
//
//  Created by Akshay Anand on 19/07/20.
//

import Cocoa

class ChatCell: NSTableCellView {

    @IBOutlet weak var messageLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var profilePicImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
