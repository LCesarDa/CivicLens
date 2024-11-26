//
//  ReportIssueView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI
import CoreML
import Vision

import SwiftUI
import CoreML
import Vision

struct ReportIssueView: View {
    @State private var description: String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var predictionResult: String = ""
    @State private var showReportPreview = false
    @State private var showAlert = false  // State to control alert visibility

    var body: some View {
        NavigationView {
            VStack {
                Text("Report an Issue")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 20)

                HStack {
                    Spacer()

                    Button(action: {
                        imagePickerSourceType = .photoLibrary
                        isImagePickerPresented = true
                    }) {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            imagePickerSourceType = .camera
                            isImagePickerPresented = true
                        } else {
                            print("Camera not available")
                        }
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        selectedImage = nil
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 30))
                            .padding()
                    }

                    Spacer()
                }
                .padding(.bottom, 20)

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                }

                TextField("Add a description", text: $description)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    if let image = selectedImage {
                        classifyImage(image)
                    } else {
                        print("Please select an image to submit.")
                    }
                }) {
                    Text("Submit Report")
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
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
            }
            .sheet(isPresented: $showReportPreview) {
                if let image = selectedImage {
                    ReportPreviewView(image: image, predictionResult: predictionResult, description: description)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("No Report to Submit"),
                      message: Text("The image does not contain a pothole or crack."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    func classifyImage(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: CivicLens50It0AugV2().model) else {
            print("Failed to load model")
            return
        }

        guard let ciImage = CIImage(image: image) else {
            print("Could not convert UIImage to CIImage")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let firstResult = results.first else {
                print("Could not classify image")
                return
            }

            DispatchQueue.main.async {
                predictionResult = firstResult.identifier
                
                // Check if the result is a pothole or crack
                if predictionResult.lowercased() == "pothole" || predictionResult.lowercased() == "crack" {
                    showReportPreview = true
                } else {
                    showAlert = true  // Show alert if no pothole or crack detected
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing classification: \(error.localizedDescription)")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct ReportIssueView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIssueView()
    }
}
