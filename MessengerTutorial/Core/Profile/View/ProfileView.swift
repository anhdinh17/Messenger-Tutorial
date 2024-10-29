//
//  ProfileView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    let user: User
    
    init(user: User) {
        self.user = user
        print("ProfileView init")
    }
    
    var body: some View {
        VStack {
            // Profile Image
            // Select a photo from Photo Library
            PhotosPicker(selection: $viewModel.selectedItem) {
                // If we select a photo from photo library
                if let profileImage = viewModel.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    // If there's no image selected,
                    // we use user's url for image
                    CircularProfileImageView(user: user,
                                             size: .xLarge)
                   
                }
            }
            
            Text(user.fullname)
                .font(.title2)
                .fontWeight(.semibold)
            
            List {
                Section {
                    // .allCases because we conform enum to CaseIterable
                    // "option" is each case
                    // This is a way to loop through enum
                    ForEach(SettingsOptionsViewModel.allCases){ option in
                        HStack {
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(option.imageBackgroundColor)
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    Button{
                        AuthService.shared.signOut()
                    } label: {
                        Text("Log Out")
                    }
                    
                    Button{
                        
                    } label: {
                        Text("Delete")
                    }
                }
                .foregroundStyle(.red)
            }
        }
    }
}

//#Preview {
//    ProfileView(user: User.MOCK_USER)
//}
