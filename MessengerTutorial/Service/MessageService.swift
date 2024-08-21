//
//  MessageService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/21/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct MessageService {
    // use static to use it in static func
    static let messagesCollection = Firestore.firestore().collection("messages")
    
    /// Send message to back end
    /// The trick is every time we send a message, both current user and other user have the message at back end
    ///
    /// This func stores every text into Firestore @ a specific document ID
    ///
    /// parameter "user" is someone else, not us.
    static func sendMessage(_ messageText: String, toUser user: User) {
        // Check if there's a logged in user.
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        // id of other user
        let chatPartnerId = user.id
        
        // This is a path to a document, inside this document is a text between us and other people
        // .document() creates a path to a new document
        // AND it automatically creates 1 ID.
        let currentUserRef =
        messagesCollection.document(currentId).collection(chatPartnerId).document()
        
        let chatPartnerRef =
        messagesCollection.document(chatPartnerId).collection(currentId)
        
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
        // set data
        currentUserRef.setData(messageData)
        
        // go to the document with the same id as currentUserRef and set data
        chatPartnerRef.document(messageId).setData(messageData)
    }
}
