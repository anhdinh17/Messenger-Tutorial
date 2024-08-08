//
//  ActiveNowView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach( 0 ... 10, id: \.self) { _ in
                    VStack {
                        // Push online circle to trailing bottom
                        // Thang nao frame nho hon 64 thi bi push
                        // Vi ZStack co frame 64 cua Image.
                        ZStack(alignment: .bottomTrailing) {
                            CircularProfileImageView(user: User.MOCK_USER,
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
                        
                        Text("Bruce")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
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
