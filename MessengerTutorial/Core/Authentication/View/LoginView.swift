//
//  LoginView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/4/24.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            VStack {
                Image("messenger_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                
                VStack(spacing: 12) {
                    TextField("Enter your email", text: $email)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 24)
                    
                   SecureField("Enter your password", text: $password)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 24)
                }
                
                // Forgot pass
                Button{
                    
                }label: {
                    Text("Forgot your password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top, 15)
                        .padding(.trailing, 24)
                }
                // Trick to push to trailing or leading
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // LOGIN BUTTON
                Button {
                    
                } label: {
                    Text("Log In")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color(.systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 24)
                }
                
                HStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/2 - 40, height: 0.5)
                    
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/2 - 40, height: 0.5)
                }
                .padding(.top)
                .foregroundStyle(.gray)
                
                HStack {
                    Image("facebook_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    Text("Continue with Facebook")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink{
                    Text("Sign up View")
                }label: {
                    HStack {
                        Text("Don't have an account?")
                        
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.top, 15)

            }
        }
    }
}

#Preview {
    LoginView()
}
