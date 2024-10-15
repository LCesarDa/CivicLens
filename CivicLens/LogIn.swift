//
//  LogIn.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI
import Auth0

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Image(systemName: "eye.circle") // Placeholder for the logo
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                Text("CIVIC LENS")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 40)
            
            // Username field
            HStack {
                TextField("User", text: $username)
                    .padding()
                    .background(Color(UIColor.systemBlue).opacity(0.2))
                    .cornerRadius(10)
                
                if !username.isEmpty {
                    Button(action: {
                        username = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            // Password field
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemBlue).opacity(0.2))
                        .cornerRadius(10)
                } else {
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemBlue).opacity(0.2))
                        .cornerRadius(10)
                }
                
                if !password.isEmpty {
                    Button(action: {
                        password = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }            }
            .padding(.horizontal)
            
            HStack{
                Button(action: {
                    // Action for forgot password
                }) {
                    Text("Forgot your password?")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            // Login and Register buttons
            VStack(spacing: 10) {
                Button(action: {
                    Auth0
                        .webAuth()
                        .start { result in
                            switch result {
                            case .success(let credentials):
                                print("Obtained credentials: \(credentials)")
                            case .failure(let error):
                                print("Failed with: \(error)")
                            }
                        }
                }) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Action for register
                }) {
                    Text("Register")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
