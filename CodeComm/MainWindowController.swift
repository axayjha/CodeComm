//
//  MainWindowController.swift
//  CodeComm
//
//  Created by Akshay Anand on 15/07/20.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var loginVC: LoginViewController?
    var createAccountVC: CreateAccountViewController?
    var splitVC: SplitViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = "CodeComm"
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        loginVC = contentViewController as? LoginViewController
    }
    
    func moveToCreateAccount() {
        if createAccountVC == nil {
            createAccountVC = storyboard?.instantiateController(withIdentifier: "createAccountVC") as? CreateAccountViewController
        }
        window?.contentView = createAccountVC?.view
        
    }
    
    func moveToChat() {
        if splitVC == nil {
            splitVC = storyboard?.instantiateController(withIdentifier: "splitVC") as? SplitViewController
        }
        window?.contentView = splitVC?.view
    }
    
    func moveToLogin() {
        window?.contentView = loginVC?.view
    }
}
