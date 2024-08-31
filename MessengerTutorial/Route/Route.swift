//
//  Route.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/31/24.
//

import Foundation

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
