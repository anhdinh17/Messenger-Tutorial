//
//  UserService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/13/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserService {
    // Use Combine to publish this to InboxViewModel
    @Published var currentUser: User? // nil at first
    
    static let shared = UserService()
    
    /// Fetch info of current user
    @MainActor
    func fetchCurrentUser() async throws {
        // Check if we have a loggined user
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Get user's data from Firestore
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        // Change of this will publish to InboxVM
        self.currentUser = user
        print("DEBUG: Current user = \(currentUser)")
    }
    
    /// Fetch all users in "users" collection
    ///
    /// specify "limit" if we want to set litmit for number of users.
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User] {
        let query = FirestoreConstants.UsersCollection
        if let limit {
            query.limit(to: limit)
        }
        let snapshot = try await query.getDocuments() // Plural
        // cast each element into User object.
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self)})
        return users
    }
    
    deinit{
        print("DEBUG: UserService deinit")
    }
    
    /// Fetch a User
    /// Go to uid and fetch the user at that ID
    static func fetchUser(withId uid: String, completion: @escaping (User) -> Void) {
        FirestoreConstants.UsersCollection.document(uid).getDocument { snapshot, _ in
            // get a User object to "user"
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
