//
//  InboxService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/27/24.
//

import Foundation
import Firebase
import FirebaseAuth

class InboxService {
    @Published var documentChanges = [DocumentChange]()
    
    // Observe the change of recent-messages collection
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Go to "recent-messages" collection and sort the document by order of timestamp
        let query = FirestoreConstants.MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        // Listen to the change of document
        // When we go to InboxView, this will fetch all recent messages
        // of each user that we are talking to.
        //
        // And when we send a new text, this will tell the app about the new text added,
        // and publish changes to InboxVM
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else {
                return
            }
            
            print("DEBUG: Changes from observeRecentMessage: \(changes)")
            
            // Publish changes
            // InboxVM listens to this change
            self.documentChanges = changes
        }
    }
}
