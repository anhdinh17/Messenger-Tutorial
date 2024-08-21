//
//  ChatBubble.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/9/24.
//

import SwiftUI
//MARK: - Create custom clipshape
// Create the bubble clipshape for the chat
struct ChatBubble: Shape {
    let isFromCurrentUser: Bool
    
    // So basically this func creates the bubble
    // If we look at the "byRoundingCorners",
    // it makes the top left and top right of the rectangle to be rounded
    // If it's from current user, it will make bottom left rounded.
    // If it's from someone else, it will make bottom right rounded.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    isFromCurrentUser ? .bottomLeft : .bottomRight
                                ],
                                cornerRadii: CGSize(width: 16,
                                                    height: 16))
        return Path(path.cgPath)
    }
}

#Preview {
    ChatBubble(isFromCurrentUser: true)
}
