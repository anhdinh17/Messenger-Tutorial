//
//  ActiveNowViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/30/24.
//

import Foundation
import FirebaseAuth

class ActiveNowViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        Task {
            try await fetchUsers()
        }
    }
    
    /// Fetch users for ActiveNow
    @MainActor
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers(limit: 10)
        // Remove current user from the fetch
        // Because we want to fetch all users but ourselves
        self.users = users.filter({ $0.id != currentUid})
    }
}
