//
//  User.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let fullname: String
    let email: String
    var profileImageURL: String?
}

extension User {
    static let MOCK_USER = User(fullname: "Bruce Wayne", email: "batman@gmail.com", profileImageURL: "batman_image")
}

