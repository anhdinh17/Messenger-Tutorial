//
//  Message.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/21/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

/// Struct of text to store in Firestore
struct Message: Identifiable, Hashable, Codable {
    @DocumentID var messageId: String?
    let fromId: String // From this person
    let toId: String // To this person
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageId ?? UUID().uuidString
    }
    
    var chatPartnerId: String {
        // If fromId = current user's id,
        // return id of the one we are to talking to.
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var timestampString: String {
        // Convert timestamp from Firestore to Date
        let timeToDate = timestamp.dateValue()
        return timeToDate.timestampString()
    }
}
