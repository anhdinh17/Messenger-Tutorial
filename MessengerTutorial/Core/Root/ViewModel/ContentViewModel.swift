//
//  ContentViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/12/24.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    // Combine
    private var cancellables: Set<AnyCancellable> = Set()
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        AuthService().$userSession
            .sink{ [weak self] userSessionFromAuthService in
                // Using Combine to listen to userSession from AuthService
                // and publish it to ContentView to decide which screen to go to
                self?.userSession = userSessionFromAuthService
            }
            .store(in: &cancellables)
            
    }
}
