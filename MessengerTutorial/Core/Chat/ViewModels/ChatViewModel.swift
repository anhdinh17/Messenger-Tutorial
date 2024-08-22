//
//  ChatViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/21/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    // This is the text we send to someone
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    // Take in a User
    let user: User
    
    init(user: User) {
        self.user = user
        observeMessages()
    }
    
    func sendMessage() {
        MessageService.sendMessage(messageText, toUser: user)
    }
    
    func observeMessages() {
        MessageService.observeMessages(chatPartner: user) { messages in
            // append added message
            self.messages.append(contentsOf: messages)
        }
    }
}
