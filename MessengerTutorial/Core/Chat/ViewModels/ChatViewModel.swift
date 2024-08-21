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
    // Take in a User
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func sendMessage() {
        MessageService.sendMessage(messageText, toUser: user)
    }
}
