//
//  RegistrationViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/11/24.
//

import Foundation
import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email,
                                           password: password,
                                           fullname: fullname)
    }
}
