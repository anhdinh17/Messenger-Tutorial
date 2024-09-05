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
    @Published var recentMessages: [Message] = []
    private var cancellables = Set<AnyCancellable>()
    let service = InboxService()
    private var didInitialLoad: Bool = false
    
    // AppStuff fix recent message bug
    private var didCompleteInitialLoad = false
    
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
            if ((self?.didCompleteInitialLoad) != nil) {
                self?.updateMessages(changes)
            } else {
                self?.loadInitialMessages(fromChanges: changes)
            }

            //--------My way to fix recent message bug-------//
            //self?.loadInitialMessagesWithMyWayToFixBug
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        var messages = changes.compactMap({
            try? $0.document.data(as: Message.self)
        })
        for i in 0 ..< messages.count {
            // message is a Message object
            let message = messages[i]
            
            // Fetch user we are talking to
            UserService.fetchUser(withId: message.chatPartnerId) { [weak self] user in
                messages[i].user = user
                print("DEBUG: message[i].user - \(messages[i].user)")
                self?.recentMessages.append(messages[i])
                if i == messages.count - 1 {
                    self?.didCompleteInitialLoad = true
                }
            }
        }
    }
    
    private func loadInitialMessagesWithMyWayToFixBug(fromChanges changes: [DocumentChange]) {
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
                    // After all users are fetched when first coming to InboxView, make didInitialLoad = true
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
    
    /// Update the recent message of the user that has same toID as
    /// take-in Message
    /// Or add new Message Object to array
    private func updateRecentMessage(_ message: Message) {
        // check if there's already a ToID in existing array
        // If so, update recent message of exisiting user
        if isNewConversation(message) {
            self.recentMessages.append(message)
        } else {
            for i in 0 ..< self.recentMessages.count {
                if recentMessages[i].toId == message.toId {
                    self.recentMessages[i] = message
                }
            }
        }
    }
    
    private func isNewConversation(_ message: Message) -> Bool {
        var existingToID: [String] = []
        for message in recentMessages {
            existingToID.append(message.toId)
        }
        return !existingToID.contains(message.toId)
    }
}

// MARK: - Fix bug When adding a new message, we add new element to recentMessages but not replacing the existing one
// -> array has new element -> we have more rows in InboxView
// -> check if array already has Message object of the user we are talking to
// -> replace message @ that Message object
// If array doesn't have Message object from a user -> add new element to array.
// FIX: add var didInitialLoad and updateRecentMessage

//MARK: - Appstuff's way to fix bug
extension InboxViewModel {
    private func updateMessages(_ changes: [DocumentChange]) {
        // snapshotListener will know if it's a new document added or
        // an modified document.
        // We don't have to check like what I did.
        for change in changes {
            if change.type == .added {
                createNewConversation(change)
            } else if change.type == .modified {
                updateMessagesFromExistingConversation(change)
            }
        }
    }
    
    private func createNewConversation(_ change: DocumentChange) {
        // cast the change into Message object
        guard var message = try? change.document.data(as: Message.self) else { return }
        
        // Do this because message.user above is nil when we fetch from DB
        // Again, we need user because we need to fetch user's fullname and image
        UserService.fetchUser(withId: message.chatPartnerId) { [weak self] user in
            message.user = user
            // Insert new message to the first index of array
            self?.recentMessages.insert(message, at: 0)
        }
    }
    
    private func updateMessagesFromExistingConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Message.self) else { return }
        // Check if there's arealdy an existing user.
        guard let index = self.recentMessages.firstIndex(where: { $0.user?.id == message.chatPartnerId}) else { return }
        // Becase we already same user at index,
        // get that user for message.user, we don't have to fetch user.
        message.user = self.recentMessages[index].user
        // Remove Message object at index and
        // add a new one to the first index so it can pop up
        // as the first thing.
        recentMessages.remove(at: index)
        recentMessages.insert(message, at: 0)
    }
}

