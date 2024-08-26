//
//  Constatns.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/26/24.
//

import Foundation
import Firebase

struct FirestoreConstants {
    static let UsersCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
}
