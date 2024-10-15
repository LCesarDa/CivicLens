//
//  LogIn.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI
import Auth0

struct LoginView: View {
    @Binding var logged: Bool
    var body: some View {
        VStack() {
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
            
            // Login and Register buttons
            VStack(spacing: 10) {
                Button(action: {
                    Auth0
                        .webAuth()
                        .start { result in
                            switch result {
                            case .success(let credentials):
                                print("Obtained credentials: \(credentials)")
                                logged = true;
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
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(logged: .constant(false))
    }
}
