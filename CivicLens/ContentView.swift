//
//  ContentView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var log: Bool = false;
    var body: some View {
        if log {
            ReportIssueView()
        } else {
            LoginView(logged: $log)
        }
    }
}

#Preview {
    ContentView(log: false)
}
