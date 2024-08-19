//
//  ChatView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/8/24.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    let user: User
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    CircularProfileImageView(user: user,
                                             size: .medium)
                    
                    VStack {
                        Text(user.fullname)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Messeneger")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                
                // Messages
                ForEach(0 ... 15, id:\.self) { message in
                    ChatMessageCell(isFromCurrentUser: Bool.random())
                }
            }
            .border(.blue)
            
            // Tam thoi ko xai Spacer thi van thay ScrollView
            // keo dai toi ZStack
            //Spacer()
            
            ZStack(alignment: .trailing) {
                // .vertical is to make the text in TextField
                // extend vertically
                TextField("Message ...", text: $messageText, axis: .vertical)
                    .font(.subheadline)
                    .padding(12)
                    // This trailing padding makes the text not bleed over
                    // Send button
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                
                Button {
                    
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
            .padding()
            .border(.green)
        }
        .border(.red)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
