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
    @Published var currentUser: User? // nil at first
    
    static let shared = UserService()
    
    /// Fetch info of current user
    @MainActor
    func fetchCurrentUser() async throws {
        // Check if we have a loggined user
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        print("DEBUG: Snapshot of fetching user: \(snapshot)")
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
        print("DEBUG: Current user = \(currentUser)")
    }
    
    deinit{
        print("DEBUG: UserService deinit")
    }
}
