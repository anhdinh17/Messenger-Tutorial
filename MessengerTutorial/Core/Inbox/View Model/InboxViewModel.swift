//
//  InboxViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/13/24.
//

import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User? // nil at first
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriber()
    }
    
    private func setupSubscriber() {
        UserService.shared.$currentUser
            .sink { [weak self] userFromUserService in
                self?.currentUser = userFromUserService
            }
            .store(in: &cancellables)
    }
}
