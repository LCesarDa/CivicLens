//
//  ReportPreviewView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 25/11/24.
//

import SwiftUI

struct ReportPreviewView: View {
    var image: UIImage
    var predictionResult: String
    var description: String

    var body: some View {
        VStack {
            Text("Report Preview")
                .font(.title2)
                .bold()
                .padding()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .cornerRadius(12)
                .padding()

            Text("Detected Issue:")
                .font(.headline)
                .padding(.top, 10)

            Text(predictionResult.capitalized)
                .font(.largeTitle)
                .bold()
                .foregroundColor(predictionResult == "pothole" || predictionResult == "crack" ? .red : .green)
                .padding(.bottom, 20)

            Text("Description:")
                .font(.headline)
                .padding(.top, 10)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: {
                // Cierra la vista de preview
                // Implementa la lógica si necesitas enviar el reporte aquí
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}


