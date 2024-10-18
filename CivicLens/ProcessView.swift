//
//  ProcessView.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 15/10/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ProcessView: View {
    @State var image: UIImage?
    @State var resizedImage: UIImage?
    @State var filteredImage: UIImage?
    @State var sobelImage: UIImage?

    var body: some View {
        VStack {
            VStack {
                HStack{
                    // Mostrar imagen original
                    if let image = image {
                        VStack {
                            Text("Original")
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                    if let resizedImage = resizedImage {
                        VStack {
                            Text("Resized")
                            Image(uiImage: resizedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                }

                HStack{
                    // Mostrar imagen filtrada con Gabor
                    if let filteredImage = filteredImage {
                        VStack {
                            Text("Filtrada con Gabor")
                            Image(uiImage: filteredImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }

                    // Mostrar imagen filtrada con Sobel
                    if let sobelImage = sobelImage {
                        VStack {
                            Text("Filtrada con Sobel")
                            Image(uiImage: sobelImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                }
            }
            Button("Resize & Apply Filters") {
                if let selectedImage = image {
                    // Redimensionar la imagen
                    let resizeImage = resizeImage(inputImage: selectedImage, to: CGSize(width: 300, height: 300))
                    
                    // Aplicar los filtros
                    if let resizedImage = resizedImage {
                        let gaborFilteredImage = applyGaborKernelFilter(image: resizedImage)
                        filteredImage = gaborFilteredImage
                        
                        let sobelFilteredImage = applySobelFilter(image: resizedImage)
                        sobelImage = sobelFilteredImage
                    }
                    resizedImage = resizeImage
                }
            }
        }
        .padding()
    }

    // Función para redimensionar la imagen
    func resizeImage(inputImage: UIImage, to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            inputImage.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }

    // Función para aplicar el filtro Gabor
    // Función para aplicar un filtro Gabor simulado
    func applyGaborKernelFilter(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let context = CIContext()
        
        // Crear un filtro de desenfoque Gaussiano
        let gaussianBlur = CIFilter.gaussianBlur()
        gaussianBlur.inputImage = ciImage
        gaussianBlur.radius = 5.0  // Ajusta el radio según lo necesario
        
        guard let blurredImage = gaussianBlur.outputImage else { return nil }
        
        // Crear un filtro de mezcla con seno para simular las ondas
        let theta: CGFloat = .pi / 4.0  // Ajuste del ángulo theta
        let colorMatrixFilter = CIFilter.colorMatrix()
        colorMatrixFilter.inputImage = blurredImage
        colorMatrixFilter.rVector = CIVector(x: 1, y: 0, z: 0, w: 0)
        colorMatrixFilter.gVector = CIVector(x: 0, y: cos(theta), z: 0, w: 0)
        colorMatrixFilter.bVector = CIVector(x: 0, y: 0, z: sin(theta), w: 0)
        colorMatrixFilter.aVector = CIVector(x: 0, y: 0, z: 0, w: 1)
        colorMatrixFilter.biasVector = CIVector(x: 0.5, y: 0.5, z: 0.5, w: 0)
        
        guard let outputImage = colorMatrixFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    // Función para aplicar el filtro Sobel usando CIKernel
    func applySobelFilter(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let context = CIContext()

        // Kernel personalizado de Sobel
        let sobelKernelString = """
        kernel vec4 sobel(sampler image) {
            vec2 d = destCoord();
            float Gx = -1.0 * sample(image, samplerTransform(image, d + vec2(-1.0, -1.0))).r +
                        -2.0 * sample(image, samplerTransform(image, d + vec2(-1.0, 0.0))).r +
                        -1.0 * sample(image, samplerTransform(image, d + vec2(-1.0, 1.0))).r +
                         1.0 * sample(image, samplerTransform(image, d + vec2(1.0, -1.0))).r +
                         2.0 * sample(image, samplerTransform(image, d + vec2(1.0, 0.0))).r +
                         1.0 * sample(image, samplerTransform(image, d + vec2(1.0, 1.0))).r;
            float Gy = -1.0 * sample(image, samplerTransform(image, d + vec2(-1.0, -1.0))).r +
                        -2.0 * sample(image, samplerTransform(image, d + vec2(0.0, -1.0))).r +
                        -1.0 * sample(image, samplerTransform(image, d + vec2(1.0, -1.0))).r +
                         1.0 * sample(image, samplerTransform(image, d + vec2(-1.0, 1.0))).r +
                         2.0 * sample(image, samplerTransform(image, d + vec2(0.0, 1.0))).r +
                         1.0 * sample(image, samplerTransform(image, d + vec2(1.0, 1.0))).r;
            float magnitude = sqrt(Gx * Gx + Gy * Gy);
            return vec4(vec3(magnitude), 1.0);
        }
        """

        guard let kernel = try? CIKernel(source: sobelKernelString) else { return nil }
        let arguments: [Any] = [ciImage]
        let extent = ciImage.extent

        // Aplicar el kernel y obtener la imagen de salida
        guard let outputImage = kernel.apply(extent: extent, roiCallback: { _, rect in rect }, arguments: arguments),
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
    
    
}

struct ProcessView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView(image: UIImage(systemName: "cloud"))
    }
}
