//
//  ContentView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                // If ther's a user logged in,
                // then take us to InboxView
                InboxView()
            } else {
                // Take us to LoginView
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
