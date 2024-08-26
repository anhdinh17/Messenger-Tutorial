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
    
    let service: ChatService
    
    // Take in a User of someone else
    init(user: User) {
        // Pay attetntion to this kind of init
        // It's like Dependency Injection
        self.service = ChatService(chatPartner: user)
        observeMessages()
    }
    
    func sendMessage() {
        service.sendMessage(messageText)
    }
    
    func observeMessages() {
        service.observeMessages() { messages in
            // append added message
            // When first coming to ChatView, this will fetch all messages from DB
            // When adding new messages, it will update UI in ChatView to show new texts.
            self.messages.append(contentsOf: messages)
        }
    }
}
