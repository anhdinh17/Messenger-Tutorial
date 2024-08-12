//
//  LoginViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/11/24.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email,
                                      password: password)
    }
}
