//
//  ChatView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/8/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    // Take in a User, this user is someone else
    let user: User
    
    //MARK: - Init with syntax for StateObject
    init(user: User) {
        // Syntax to init @StateObject
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
        self.user = user
    }
    
    var body: some View {
        VStack {
            ScrollView {
                // Other User
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
                ForEach(viewModel.messages) { message in
                    ChatMessageCell(message: message)
                }
            }
            .border(.blue)
            
            // Tam thoi ko xai Spacer thi van thay ScrollView
            // keo dai toi ZStack
            //Spacer()
            
            // Text TextField
            ZStack(alignment: .trailing) {
                // .vertical is to make the text in TextField
                // extend vertically
                TextField("Message ...", text: $viewModel.messageText, axis: .vertical)
                    .font(.subheadline)
                    .padding(12)
                    // This trailing padding makes the text not bleed over
                    // Send button
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                
                Button {
                    viewModel.sendMessage()
                    // empty the text after hitting send
                    viewModel.messageText = ""
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
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
