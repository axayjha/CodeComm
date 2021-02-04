//
//  LoginViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 15/07/20.
//

import Cocoa
import Parse

class LoginViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(50)) {
            if var frame = self.view.window?.frame {
                frame.size = CGSize(width: 500, height: 450)
                self.view.window?.setFrame(frame, display: true, animate: true)
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func loginClicked(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: emailTextField.stringValue, password: passwordTextField.stringValue) { (user, error) in
            if error == nil {
                print("Logged in successfully")
                if let mainWC = self.view.window?.windowController as? MainWindowController {
                    mainWC.moveToChat()
                }
            } else {
                print("Couldn't log in")
            }
        }
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToCreateAccount()
        }
    }
    
    override func viewDidAppear() {
        if var frame = view.window?.frame {
            frame.size = CGSize(width: 500, height: 450)
            view.window?.setFrame(frame, display: true, animate: true)
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            loginClicked(self)
        }
        return false
        
    }
    

}

