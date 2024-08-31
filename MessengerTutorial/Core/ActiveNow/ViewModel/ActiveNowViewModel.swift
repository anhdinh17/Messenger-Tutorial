//
//  ActiveNowViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/30/24.
//

import Foundation
import Firebase

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
        self.users = try await UserService.fetchAllUsers(limit: 10)
    }
}
