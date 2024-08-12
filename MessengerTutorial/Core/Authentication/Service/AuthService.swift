//
//  AuthService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/11/24.
//

import Foundation
import FirebaseAuth

//MARK: - AuthService has funcs that are associated with Firebase Authentication

class AuthService {
    // Keep track of wheter or not a user is logged in
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        // If someone is logged in
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User sessiong id is \(userSession?.uid)")
    }
    
    deinit {
        print("DEBUG: AuthService is deinit")
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // populate the change for routing logic
            self.userSession = result.user
        } catch {
            print("DEBUG: Fail to sign in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Create a user and store the result
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // This print line is not triggered until the async await func above is through.
            print("DEBUG: User CREATED: \(result.user.uid)")
            self.userSession = result.user
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
        } catch {
            print("DEBUG: Fail to sign out with error: \(error.localizedDescription)")
        }
    }
}
