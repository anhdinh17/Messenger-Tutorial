//
//  ChatMessageCell.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/8/24.
//

import SwiftUI

struct ChatMessageCell: View {
    // Foundation to determine if the text is from current user
    // or from someone else
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            // Message from current user of the app
            if isFromCurrentUser {
                Spacer()
                
                Text("This is text from current user of the app, it's gonna be a long text, let's see what happens.")
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundStyle(.white)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                // Use maxWidth to make the text not to bleed over too much
                // to the left when it gets long.
                // We set the width so that text will go to other line once it reaches the limit width.
                    .frame(maxWidth: UIScreen.main.bounds.width/1.5, alignment: .trailing)
            } else {
                // Message from someone else
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImageView(user: User.MOCK_USER,
                                             size: .xxSmall)
                    
                    Text("This is message from someone else")
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray5))
                        .foregroundStyle(.black)
                        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width/1.75, alignment: .leading)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ChatMessageCell(isFromCurrentUser: true)
}
