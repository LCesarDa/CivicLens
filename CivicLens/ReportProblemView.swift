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
                Text("Report an Issue")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("What type of issue are you reporting?")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                List {
                    ReportOptionRow(imageName: "exclamationmark.triangle.fill",
                                    title: "Pothole",
                                    description: "Report road potholes or surface damage")
                    
                    ReportOptionRow(imageName: "arrow.down.to.line.alt",
                                    title: "Crack",
                                    description: "Report road or sidewalk cracks")
                    
                    ReportOptionRow(imageName: "questionmark.diamond.fill",
                                    title: "Other Issues",
                                    description: "We aren't currently accepting other reports")
                }
                
                Spacer()
                
                NavigationLink(destination: ReportIssueView()) {
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

struct ReportProblemView_Previews: PreviewProvider {
    static var previews: some View {
        ReportProblemView()
    }
}
