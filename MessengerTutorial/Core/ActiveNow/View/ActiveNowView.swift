//
//  ActiveNowView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject private var viewModel = ActiveNowViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach( viewModel.users) { user in
                    // Create a NavigationLink taking in a Route enum
                    NavigationLink(value: Route.chatView(user)) {
                        VStack {
                            // Push online circle to trailing bottom
                            // Thang nao frame nho hon 64 thi bi push
                            // Vi ZStack co frame 64 cua Image.
                            ZStack(alignment: .bottomTrailing) {
                                CircularProfileImageView(user: user,
                                                         size: .medium)
                                
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 14, height: 14)
                                }
                            }
                            
                            Text(user.lastName)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
        .border(.red, width: 1.5)
    }
}

#Preview {
    ActiveNowView()
}
