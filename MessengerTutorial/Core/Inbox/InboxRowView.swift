//
//  InboxRowView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct InboxRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: User.MOCK_USER,
                                     size: .medium)
            
            VStack(alignment: .leading) {
                Text("Bruce Wayne")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("A message that spans more than 1 line for now")
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

#Preview {
    InboxRowView()
}
