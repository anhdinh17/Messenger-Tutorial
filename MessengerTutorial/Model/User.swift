//
//  User.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import Foundation
import FirebaseFirestore

/** ---NOTE---
 - Explain @DocumentID:
 - This is an Property Wrapper for FirebaseFirestore
 - It has to be optional
 - Everytime we fetch/read data from Firestore, it will go to document path and read the info in it and store it into this @DocumentID property automatically
    - In this case, we have user's ID given by backend inside the "document" path, so that ID will be stored in "uid" property
 
 - Khi mình tạo user rồi up lên Firestore, lúc đó uid vẫn nil vì ta ko fetch.
 - Lúc fetch về mới có uid và id sẽ dùng uid luôn
 */

struct User: Identifiable, Codable, Hashable {
    @DocumentID var uid: String?
    
    let fullname: String
    let email: String
    var profileImageURL: String?
    
    var id: String {
        return uid ?? UUID().uuidString
    }
    
    // Get the last name from fullname
    var lastName: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullname)
        return components?.givenName ?? fullname
    }
}

extension User {
    static let MOCK_USER = User(fullname: "Bruce Wayne", email: "batman@gmail.com", profileImageURL: "batman_image")
}

