//
//  ProfileViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth

@MainActor
class ProfileViewModel: ObservableObject {
    
    // When we select a photo from Photo Library
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            // This runs when we select a photo from Library.
            Task {try await loadImage()}
        }
    }
    
    @Published var profileImage: Image?
    
    // Conversion from what we select from Photo Library to what
    // is displayed on profile image.
    func loadImage() async throws {
        guard let item = selectedItem else {return}
        guard let imageData = try await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: imageData) else {return}
        self.profileImage = Image(uiImage: uiImage)
        
        // After select a photo for Profile Image.
        // We need to upload that image to Storage
        // And also update the imageUrl for User.
        guard let imageUrl = try await ImageUploader().uploadImage(uiImage) else {return}
        
        // Fix Bug
        // When select profile image, the profile image of Nav bar doesn't change.
        // InboxView's viewModel listen to this property "currentUser"
        // So changing this will change "viewModel.currentUser" in InboxView
        // -> Nav Bar image changes.
        UserService.shared.currentUser?.profileImageURL = imageUrl
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await FirestoreConstants.UsersCollection.document(uid).updateData(
            // The key of dictionary must match the property name
            // in User model
            ["profileImageURL" : imageUrl]
        )
    }
}
