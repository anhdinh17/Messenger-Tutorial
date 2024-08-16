//
//  NewMessageViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/16/24.
//

import Foundation
import FirebaseAuth

@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        // Fetch all users but ourselves when init
        Task {
            try await fetchAllUsers()
        }
    }
    
    func fetchAllUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        // Remove current user from the fetch
        // Because we want to fetch all users but ourselves
        self.users = users.filter({ $0.id != currentUid})
    }
}
