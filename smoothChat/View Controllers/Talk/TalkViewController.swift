//
//  ChatViewController.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import Firebase
import UIKit
import MessengerKit

class TalkViewController: MSGMessengerViewController {

    var user : [String:Any]!
    var messages = [MSGMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getTalks()
        
        self.addTalkListener()
    }
    
    private func getTalks(){
        FirebaseHelper.shared.getTalks(talkID: FirebaseHelper.shared.getTalkID(user: self.user), completion: { (snapshot:QuerySnapshot?, error:Error?) in
            self.storeMessages(snapshot: snapshot)
        })
    }
    
    private func addTalkListener(){
        FirebaseHelper.shared.onTalkAdded(talkID: FirebaseHelper.shared.getTalkID(user: self.user)) { (snapshot:QuerySnapshot?, error : Error?) in
            self.storeMessages(snapshot: snapshot)
        }
    }
    
    private func storeMessages(snapshot:QuerySnapshot?){
        if let documents = snapshot?.documents {
            self.messages = [MSGMessage]()
            
            for document in documents.enumerated() {
                let isSender = document.element.data()["senderID"] as! String == FirebaseHelper.shared.getCurrentUserID()
                let user = MessageUser(avatar:nil, displayName: "",isSender: isSender)
                let message = MSGMessage(id: document.offset, body: .text(document.element.data()["message"] as! String) , user: user, sentAt: Date(timeIntervalSinceReferenceDate: Date().timeIntervalSince1970)
                )
                
                self.messages.append(message)
            }
            
            self.dataSource = self
            self.delegate = self
            
            self.collectionView.reloadData()
            
            self.collectionView.scrollToBottom(animated: true)
        }
    }
    
}

extension TalkViewController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages.count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        let user = MessageUser(avatar:nil, displayName: "",isSender: false)
        
        return messages.count > 0 ? messages[indexPath.item] : MSGMessage(id: indexPath.row, body: .text(""), user: user, sentAt: Date())
    }
    
    func footerTitle(for section: Int) -> String? {
        return ""
    }
    
    func headerTitle(for section: Int) -> String? {
        return ""
    }
}

extension TalkViewController : MSGDelegate {
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        
        FirebaseHelper.shared.createNewTalk(talkID: FirebaseHelper.shared.getTalkID(user: self.user) ,data: [
            "senderID" : FirebaseHelper.shared.getCurrentUserID(),
            "receiverID" : self.user["authID"] as! String,
            "message" : inputView.message
        ])
    }
    
}
