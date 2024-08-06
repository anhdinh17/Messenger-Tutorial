//
//  ProfileView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/6/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(Color(.systemGray4))
            
            Text("Bruce Wayne")
                .font(.title2)
                .fontWeight(.semibold)
            
            List {
                Section {
                    // .allCases because we conform enum to CaseIterable
                    // "option" is each case
                    // This is a way to loop through enum
                    ForEach(SettingsOptionsViewModel.allCases){ option in
                        HStack {
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(option.imageBackgroundColor)
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    Button{
                        
                    } label: {
                        Text("Log Out")
                    }
                    
                    Button{
                        
                    } label: {
                        Text("Delete")
                    }
                }
                .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    ProfileView()
}
