//
//  ReportIssueView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 14/10/24.
//

import SwiftUI

struct ReportIssueView: View {
    @State private var description: String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("Report an Issue")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 20)

                HStack {
                    Spacer()

                    // Botón para elegir una foto de la galería
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .padding()
                    }

                    Spacer()

                    // Botón para tomar una foto con la cámara
                    Button(action: {
                        // Acción para abrir la cámara
                        isImagePickerPresented = true
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .padding()
                    }

                    Spacer()

                    // Botón para recargar (refrescar o quitar imagen)
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

                // Campo para agregar una descripción
                TextField("Add a description", text: $description)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Spacer()

                // Botón para enviar el reporte
                Button(action: {
                    // Acción al enviar el reporte
                }) {
                    Text("Submit Report")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

// Estructura para el ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // Puedes cambiar a .camera si prefieres usar la cámara
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
    }
}

struct ReportIssueView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIssueView()
    }
}
