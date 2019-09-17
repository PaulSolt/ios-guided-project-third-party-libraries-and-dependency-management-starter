//
//  MessageDetailViewController.swift
//  Message Board
//
//  Created by Paul Solt on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageDetailViewController: MessagesViewController {
    
    var messageThreadController: MessageThreadController?
    var messageThread: MessageThread?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()  // YOU MUST CALL OR bad things happen
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
}

//MessagesDataSource
//MessagesLayoutDelegate
//MessagesDisplayDelegate

extension MessageDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        guard let user = messageThreadController?.currentUser else {
            fatalError("No user set")
        }
        
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        guard let message = messageThread?.messages[indexPath.item] else {
            fatalError("Missing Messsage Thread")
        }
        
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageThread?.messages.count ?? 0
    }
}

extension MessageDetailViewController: MessagesLayoutDelegate {
    
}

extension MessageDetailViewController: MessagesDisplayDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageStyle {
        
        guard let message = messageThread?.messages[indexPath.item] else {
            fatalError("Missing Messsage Thread")
        }
        
        guard let user = messageThreadController?.currentUser else {
            fatalError("No user set")
        }

        if message.senderId == user.senderId {
            return .bubbleTail(.bottomRight, .curved)
        } else {
            return .bubbleTail(.bottomLeft, .curved)
        }
        
        
    }
    
}

extension MessageDetailViewController: InputBarAccessoryViewDelegate {
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("text: \(text)")
        
        guard let thread = messageThread else {
            fatalError("No thread set!")
        }
        
        guard let user = messageThreadController?.currentUser else {
            fatalError("No user set")
        }
        
        
        messageThreadController?.createMessage(in: thread, withText: text, sender: user, completion: {
            
            // update the UI
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messageInputBar.inputTextView.text = ""
            }
        })
    }
}
