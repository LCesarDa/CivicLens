//
//  ContentView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var log: Bool = false;
    @State private var showMenu = false
    var body: some View {
        if log {
            VStack {
                HStack{
                    if !showMenu {
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                    Spacer()
                }
                ZStack {
                    ReportProblemView()
                        .offset(x: showMenu ? 250 : 0)
                        .scaleEffect(showMenu ? 0.8 : 1) // Shrink effect
                        .blur(radius: showMenu ? 5 : 0)  // Blur effect
                    SideMenuView()
                        .offset(x: showMenu ? 0 : -250)  // Slide menu
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -100 {
                                withAnimation {
                                    showMenu = false
                                }
                            }
                        }
                )
            }
        } else{
            LoginView(logged: $log)
        }
    }
}

#Preview {
    ContentView(log: true)
}
