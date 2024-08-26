//
//  ChatService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/26/24.
//

import Foundation
import Firebase
import FirebaseAuth

struct ChatService {
    let chatPartner: User
    
    /// Send message to back end
    /// The trick is every time we send a message, both current user and other user have the message at back end
    ///
    /// This func stores every text into Firestore @ a specific document ID
    ///
    /// parameter "user" is someone else, not us.
    func sendMessage(_ messageText: String) {
        // Check if there's a logged in user.
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        // id of other user
        let chatPartnerId = chatPartner.id
        
        // This is a path to a document, inside this document is a text between us and other people
        // .document() creates a path to a new document
        // AND it automatically creates 1 ID.
        let currentUserRef =
        FirestoreConstants.MessagesCollection.document(currentId).collection(chatPartnerId).document()
        
        let chatPartnerRef =
        FirestoreConstants.MessagesCollection.document(chatPartnerId).collection(currentId)
        
        // Get id that .document() creates above
        let messageId = currentUserRef.documentID
        
        // Create object of the Message
        let message = Message(messageId: messageId,
                              fromId: currentId,
                              toId: chatPartnerId,
                              messageText: messageText,
                              timestamp: Timestamp())
        
        // Encode Message object
        guard let messageData = try? Firestore.Encoder().encode(message) else {
            return
        }
        
        //MARK: - Set data for both current user path and other user path
        // Inside the document ID, set data for the message
        currentUserRef.setData(messageData)
        
        // go to the document with the same id as currentUserRef and set data
        chatPartnerRef.document(messageId).setData(messageData)
    }
    
    /// For simple understanding, don't try to remember all syntax
    /// The logic is every time we send a new message to DB,
    /// it will immediately notificates the app and gives us the info of added text
    /// => "message" in ChatVM gets appended new elements
    /// => updates UI in ChatView
    func observeMessages(completion: @escaping ([Message]) -> Void) {
        // Get current user's id
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        
        // Go to this path and sort the text by order of timestamp
        let query = FirestoreConstants.MessagesCollection
            .document(currentId)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)
        
        // We use addSnapshotListener so that
        // every time a document(text) is added to Firestore,
        // Firestore will send notification and information
        // to the app about new added document right away.
        //
        // This is how we get real time update for the chat.
        query.addSnapshotListener { snapshot, _ in
            // Every time a text(document) is added to Firestore,
            // We want to receive it immediately.
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added}) else {
                return
            }
            
            print("DEBUG: SNAPSHOT OF CHANGES: \(changes)")
            
            // decode the changed message into Message object
            //
            // When we first get to the ChatView with other user
            // it has all messages in DB.
            // When we add new message, it only has new message
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
            print("DEBUG: messages = \(messages)------------------------")
            
            // CQ gì vậy?
            // This is message which is not from us
            for (index, message) in messages.enumerated() where message.fromId != currentId {
                messages[index].user = chatPartner
            }
            
            completion(messages)
        }
    }
}
