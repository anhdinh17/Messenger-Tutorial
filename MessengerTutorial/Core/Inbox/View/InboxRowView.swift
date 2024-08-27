//
//  InboxRowView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct InboxRowView: View {
    // Take in a Message Object
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: message.user,
                                     size: .medium)
            
            VStack(alignment: .leading) {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    // So far, this is to leave room for the timestamp
                    // That's why we set maxWidth
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            .border(.green,width: 1.5)
            
            HStack {
                Text("Yesterday")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
    }
}

//#Preview {
//    InboxRowView()
//}
