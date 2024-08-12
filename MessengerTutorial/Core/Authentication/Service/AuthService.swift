//
//  AuthService.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/11/24.
//

import Foundation
import FirebaseAuth

class AuthService {
    func login(withEmail email: String, password: String) async throws {
        print("DEBUG: Email is \(email)")
        print("DEBUG: Email is \(password)")
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Create a user and store the result
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // This print line is not triggered until the async await func above is through.
            print("DEBUG: User CREATED: \(result.user.uid)")
        } catch {
            print("DEBUG: Error of sign up - \(error.localizedDescription)")
        }
    }
}
