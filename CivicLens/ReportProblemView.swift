//
//  ReportProblemView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI

struct ReportProblemView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Report a problem")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("What are you reporting?")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                List {
                    ReportOptionRow(imageName: "car.fill", title: "Illegally parked vehicle", description: "Vehicles on the sidewalk, in a bike lane or bus stop")
                    
                    ReportOptionRow(imageName: "wrench.fill", title: "Public infrastructure damage", description: "Damaged street furniture, potholes, etc.")
                    
                    ReportOptionRow(imageName: "lightbulb.fill", title: "Poor lighting", description: "Report areas with insufficient lighting")
                    
                    ReportOptionRow(imageName: "drop.fill", title: "Water leaks", description: "Leaks from pipes, hydrants, etc.")
                    
                    ReportOptionRow(imageName: "leaf.fill", title: "Urban biodiversity analysis", description: "Report wildlife sightings")
                }
                
                Spacer()
                
                Button(action: {
                    // Acción al presionar el botón "Next"
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct ReportOptionRow: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReportProblemView()
    }
}
