//
//  GaborFilter.swift
//  CivicLens
//
//  Created by Luis Fernando César Denicia on 17/10/24.
//

import UIKit
import Accelerate

func gaborKernel(ksize: Int, sigma: Double, theta: Double, lambda: Double, gamma: Double, psi: Double) -> [Float] {
    var kernel = [Float](repeating: 0, count: ksize * ksize)
    let halfSize = ksize / 2

    for x in 0..<ksize {
        for y in 0..<ksize {
            let xp = Double(x - halfSize) * cos(theta) + Double(y - halfSize) * sin(theta)
            let yp = -Double(x - halfSize) * sin(theta) + Double(y - halfSize) * cos(theta)
            let gaborValue = exp(-0.5 * (pow(xp, 2) + pow(gamma * yp, 2)) / pow(sigma, 2)) * cos(2 * .pi * xp / lambda + psi)
            kernel[y * ksize + x] = Float(gaborValue)
        }
    }

    return kernel
}

func applyGaborFilter(image: UIImage, ksize: Int, sigma: Double, theta: Double, lambda: Double, gamma: Double, psi: Double) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }
    let width = cgImage.width
    let height = cgImage.height
    let colorSpace = CGColorSpaceCreateDeviceGray()
    var imageBuffer = vImage_Buffer()
    var destinationBuffer = vImage_Buffer()
    
    let kernel = gaborKernel(ksize: ksize, sigma: sigma, theta: theta, lambda: lambda, gamma: gamma, psi: psi)
    let divisor: Int32 = 256
    
    // Prepare buffers for image processing
    defer {
        free(imageBuffer.data)
        free(destinationBuffer.data)
    }
    
    // Create the UIImage from the filtered data
    if let context = CGContext(data: destinationBuffer.data,
                               width: width,
                               height: height,
                               bitsPerComponent: 8,
                               bytesPerRow: destinationBuffer.rowBytes,
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.none.rawValue),
       let filteredCGImage = context.makeImage() {
        return UIImage(cgImage: filteredCGImage)
    }
    
    return nil
}
