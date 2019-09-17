//
//  Message.swift
//  Message Board
//
//  Created by Paul Solt on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable {
    
    let text: String
    let timestamp: Date
    let displayName: String
    
    // Add
    let senderId: String
    let messageId: String
    
    init(text: String,
         sender: Sender,
         timestamp: Date = Date(),
        messageId: String = UUID().uuidString) {
        
        self.text = text
        self.displayName = sender.displayName
        self.senderId = sender.senderId
        self.timestamp = timestamp
        self.messageId = messageId
    }
}

public struct Sender: SenderType {
    public var senderId: String
    public let displayName: String
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    
    var sentDate: Date {
        return timestamp
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
