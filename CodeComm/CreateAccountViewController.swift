//
//  CreateAccountViewController.swift
//  CodeComm
//
//  Created by Akshay Anand on 15/07/20.
//

import Cocoa
import Parse

class CreateAccountViewController: NSViewController {

    @IBOutlet weak var profilePicImageView: NSImageView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    
    var profilePicFile : PFFileObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(50)) {
            if var frame = self.view.window?.frame {
                frame.size = CGSize(width: 500, height: 450)
                self.view.window?.setFrame(frame, display: true, animate: true)
            }
        }
        // Do view setup here.
    }
    @IBAction func loginClicked(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToLogin()
        }
    }
    @IBAction func chooseImageClicked(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                if let imageURL = openPanel.urls.first {
                    if let image = NSImage(contentsOf: imageURL) {
                        self.profilePicImageView.image = image
                        let imageData = self.jpegDataFrom(image: image)
                        self.profilePicFile = PFFileObject(data: imageData)
                        self.profilePicFile?.saveInBackground()
                    }
                }
            }
        }
        
    }
    
    func jpegDataFrom(image:NSImage) -> Data {
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        PFUser.logOut()
        let user = PFUser()
        user.email = emailTextField.stringValue
        user.password = passwordTextField.stringValue
        user.username = emailTextField.stringValue
        user["name"] = nameTextField.stringValue
        user["profilePic"] = profilePicFile
        
        user.signUpInBackground {
            (success: Bool, error: Error?) in
            if success {
                print("Made a user")
                if let mainWC = self.view.window?.windowController as? MainWindowController {
                    mainWC.moveToChat()
                }
            } else {
                print("Couldn't create a user")
            }
        }
    }
    
    override func viewDidAppear() {
        if var frame = view.window?.frame {
            frame.size = CGSize(width: 500, height: 450)
            view.window?.setFrame(frame, display: true, animate: true)
        }
    }
    
}
