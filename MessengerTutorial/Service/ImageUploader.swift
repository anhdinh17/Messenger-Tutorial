//
//  ImageUploader.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 9/5/24.
//

import Foundation
import FirebaseStorage
import UIKit

struct ImageUploader {
    /// Upload the image to Storage and get the url of that image.
    /// So that we can have the url for imageUrll of a user.
    func uploadImage(_ image: UIImage) async throws -> String? {
        // compressionQuality makes the size of the image.
        // We don't want the image to be too big to download or upload
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return nil}
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        // Upload image to Storage
        let _ = try await ref.putDataAsync(imageData)
        // Get the url of the image
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
