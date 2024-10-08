//
//  InboxView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User? // nil at first
    @State private var showChat = false
    
    var user: User? {
        return viewModel.currentUser
    }
    
    init() {
        print("DEBUG: InboxView Init")
    }
    
    var body: some View {
        NavigationStack {
            // List of users that we are talking to
            // Display recent message for each user
            // As of Aug 05, 2024
            // List acts strangly in ScrollView
            // Gotta have .listStyle and .frame so it can display
            List {
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical)
                    .padding(.horizontal,4)
                
                ForEach(viewModel.recentMessages) { message in
                    // Use this workaround way to hide the
                    // default indicator right chevron of List
                    ZStack {
                        NavigationLink(value: message) {
                            EmptyView()
                                .border(.pink)
                        }
                        .opacity(0.0)
                        .border(.blue)
                        
                        InboxRowView(message: message)
                    }
                }
            }
            .listStyle(.plain)
            .onAppear{
                print("DEBUG: OnAppear of InboxView")
                print("DEBUG: SHOWCHAT: \(showChat)")
                print("DEBUG: ShowMessageView: \(showNewMessageView)")
            }
            //MARK: - Change value of selectedUser
            // if selectedUser has value and it's not nil, showChat = true
            .onChange(of: selectedUser, { oldValue, newValue in
                showChat = newValue != nil
            })
            
            //MARK: - Navigate to ChatView by clicking on 1 chat
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }
            })
            
            //MARK: - Navigate to ProfileView or ChatView
            // Depending on the take in enum
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .profile(let user):
                    ProfileView(user: user)
                case .chatView(let user):
                    ChatView(user: user)
                }
            })
            
            //MARK: - Navigate to ChatView
            // Use another way of navigation to navigate to ChatView
            // depends on showChat
            .navigationDestination(isPresented: $showChat, destination: {
                // if selectedUser not nil
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            
            // Show New Message View
            // This is like modal present, not a Navigation push
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        // NavLink taking in a Route enum
                        if let user = user {
                            NavigationLink(value: Route.profile(user)) {
                                CircularProfileImageView(user: user,
                                                         size: .xSmall)
                            }
                        }
                        
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                        
                        //MARK: - Fix bug
                        // The bug is if we go to NewMessageView and select a user, it works fine.
                        // But if we go to NewMessageView again and select the same user, it not gonna navigate.
                        // Because the second time we select user, the object doesn't change => .onchange not triggered.
                        // So we have to make selectedUser = nil every time we hit button so that we can have
                        // value change
                        selectedUser = nil
                    }label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    InboxView()
}
