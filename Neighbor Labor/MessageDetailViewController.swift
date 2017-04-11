//
//  MessageDetailViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 4/10/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import NMessenger
import IQKeyboardManagerSwift
class MessageDetailViewController: NMessengerViewController{

    @IBOutlet weak var messageOutletView: NMessenger!
    let current = AuthManager.currentUser()!
    
    var thread: Thread!
    var messages = [Message]()
 
//    
//   
    var allowinsert = false
    
    func loadMessages() {
        let query = Message.query()
        query?.whereKey("threadId", equalTo: thread.objectId!)
        
        query?.findObjectsInBackground(block: { (objs, error) in
            
            guard let err = error else {
                
                self.messages = objs as! [Message]
                
                for mes in self.messages {
                   
                     _ = self.sendText(mes.body, isIncomingMessage: mes.userId != self.current.objectId! )
                }
             self.allowinsert = true
             return
            }
            print(err.localizedDescription)
            
        })

    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        messengerView.delegate = self
        self.view.addSubview(self.messengerView)

        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        loadMessages()
        
    }
    
   
     override func sendText(_ text: String, isIncomingMessage:Bool) -> GeneralMessengerCell {
        
        if (allowinsert == true){
            let message = Message()
            message.body = text
            message.userId = self.current.objectId!
            message.threadId = thread.objectId!
            
            message.saveInBackground(block: { (sucess, error) in
                
            })
        }
        
        return super.sendText(text, isIncomingMessage: isIncomingMessage)
    }
}




 
