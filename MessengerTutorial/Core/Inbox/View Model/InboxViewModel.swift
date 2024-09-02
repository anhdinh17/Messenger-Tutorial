//
//  InboxViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/13/24.
//

import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User? // nil at first
    @Published var recentMessages = [Message]()
    private var cancellables = Set<AnyCancellable>()
    let service = InboxService()
    private var didInitialLoad: Bool = false
    
    init() {
        print("InboxViewModel init")
        setupSubscriber()
        
        // fetch recent messages from DB
        service.observeRecentMessages()
    }
    
    // Setup Subscriber and Publisher
    private func setupSubscriber() {
        UserService.shared.$currentUser
            .sink { [weak self] userFromUserService in
                self?.currentUser = userFromUserService
            }
            .store(in: &cancellables)
        
        // Listen to $documentChanges
        // In init, setup subscriber, at this point $documentChanges is an empty array
        // -> changes has 0 values (break point) -> UI has nothing
        // we call observeRecentMessages() -> $documentChanges has data
        // -> publish data -> this junk runs -> recentMessages array updates.
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        // Return an array of Message
        // When we come to InboxView, it will be an array of multi Messages objects
        // because we have multiple users that we are talking to and each user has a recent message with us.
        //
        // But when we send a new message to A user, the snapshotListener in InboxService is triggered.
        // And we only have 1 element of this array.
        var messages = changes.compactMap({
            try? $0.document.data(as: Message.self)
        })
        
        print("DEBUG: messages in loadInitialMessages: \(messages)")
        // At this point, each Message element of "messages" array
        // has the property of user = nil.
        
        // Loop through "messages" array and fetch user we are talking to.(chatPartnerId)
        // The reason we are doing this is because
        // before this for loop, each element of "messages" array has "user" property = nil.
        // We need to loop through the array and fetch user from chatPartnerId of each Message element
        // so that the property "user" of each element can have value(not nil anymore) which contains full name
        // of the users we are talking to
        if didInitialLoad == false {
            for i in 0 ..< messages.count {
                // message is a Message object
                let message = messages[i]
                
                // Fetch user we are talking to
                UserService.fetchUser(withId: message.chatPartnerId) { [weak self] user in
                    messages[i].user = user
                    print("DEBUG: message[i].user - \(messages[i].user)")
                    // Publish changes to InboxView
                    // BUG HERE: add thêm làm tăng size array
                    // We need to add new message to existing user
                    self?.recentMessages.append(messages[i])
                    
                    // Fix bug
                    // After all users are fetched, make didInitialLoad = true
                    // so when we add new message, it comes to else block.
                    if i == messages.count - 1 {
                        self?.didInitialLoad = true
                    }
                }
            }
        }
        else {
            for i in 0 ..< messages.count {
                // message is a Message object
                let message = messages[i]
                
                // Fetch user we are talking to
                UserService.fetchUser(withId: message.chatPartnerId) { [weak self] user in
                    messages[i].user = user
                    print("DEBUG: message[i].user - \(messages[i].user)")
                    self?.updateRecentMessage(messages[i])
                }
            }
        }
    }
    
    /// Update the recent message of the user that has same toId as
    /// take-in Message
    func updateRecentMessage(_ message: Message) {
        for i in 0 ..< self.recentMessages.count {
            if recentMessages[i].toId == message.toId {
                self.recentMessages[i] = message
            }
        }
    }
}

//MARK: - Fix bug
//When add a new message to a User, InboxView adds a new recent message for the same user.
//Check if recentMessages already has that user.
// If it does, get the new recent message.
// If it does not, add a new element to recentMessages array.
