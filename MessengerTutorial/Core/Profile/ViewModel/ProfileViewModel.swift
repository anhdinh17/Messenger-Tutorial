//
//  ProfileViewModel.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class ProfileViewModel: ObservableObject {
    
    // When we select a photo from Photo Library
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
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
    }
}
