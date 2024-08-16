//
//  AuthService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//MARK: - AuthService has funcs that are associated with Firebase Authentication

class AuthService {
    // Keep track of wheter or not a user is logged in
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        // If noone is logged in, userSession will be nil
        // and it broadcasts nil to contentViewModel
        // so we go LoginView
        //
        // If it has current user, we go to InboxView
        // and the fetch user below will go through
        // to fetch user's info.
        //
        // One more thing, because we use Combine to broadcast userSession
        // so contentViewModel will catch the change and go to either InboxView
        // or LoginView first before fetching user's info.
        self.userSession = Auth.auth().currentUser
        
        loadCurrentUserData()
        
        print("DEBUG: User session id is \(userSession?.uid)")
    }
    
    deinit {
        print("DEBUG: AuthService is deinit")
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // populate the change for routing logic
            self.userSession = result.user
            
            // Fetch data of user after logging in
            loadCurrentUserData()
        } catch {
            print("DEBUG: Fail to sign in with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Create a user and store the result
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // This print line is not triggered until the async await func above is through.
            print("DEBUG: User CREATED: \(result.user.uid)")
            self.userSession = result.user
            
            // Upload user's info to Firestore
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
            
            // Fetch user's data
            loadCurrentUserData()
        } catch {
            print("DEBUG: Error of sign up - \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            /** ---NOTE---
             - important to do both sign out from back end and make userSessioin = nil
             - If we don't make userSession = nil, we still see InboxView, we need it to be nill so that ContentView can listen to the change and route us to LoginView
             */
            try Auth.auth().signOut() //sign out from back end
            self.userSession = nil // update routing logic
            UserService.shared.currentUser = nil // make sure to clear current user after sign out
        } catch {
            print("DEBUG: Fail to sign out with error: \(error.localizedDescription)")
        }
    }
    
    /// Upload user's info to Firestore
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, profileImageURL: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
        print("DEBUG: User's info: uid - \(user.uid) id - \(user.id)")
    }
    
    private func loadCurrentUserData() {
        // Fetch current user's info
        // If there's no user loggined,
        // code inside fetchCurrentUser() will stop.
        Task {
            try await UserService.shared.fetchCurrentUser()
        }
    }
}
