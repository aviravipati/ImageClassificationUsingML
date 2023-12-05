//
//  ImageSelectionView.swift
//  ImageClassificationUsingML
//
//  Created by Avinash Ravipati on 12/3/23.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

@available(iOS 16.0, *)
struct ImageSelectionView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var classificationResult = ""
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 200)
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        Button("Classify") {
            classifyImage()
        }
        Spacer()
            .frame(height: 200)
        Text(classificationResult)
            .multilineTextAlignment(.center)
            // Remove the line limit or set a higher number if necessary
            .lineLimit(nil) // or .lineLimit(10) for example
            .font(.system(size: 16)) // Optional: Adjust the font size
            .padding() // Add padding around the text
            .frame(minHeight: 60) // Optional: Set a minimum frame height
            .fixedSize(horizontal: false, vertical: true) // This ensures that the text view expands vertically to fit the content

    }
    // Function to classify image

    // Function to classify image
    private func classifyImage() {
        guard let selectedImageData = selectedImageData,
              let image = UIImage(data: selectedImageData),
              let ciImage = CIImage(image: image) else {
            classificationResult = "Could not load image"
            return
        }

        // Load the ML model
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            classificationResult = "Failed to load model"
            return
        }

        // Create a request for classifying the image
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classificationResult = "Could not classify image"
                return
            }

            // Update classification label
            DispatchQueue.main.async {
                self.classificationResult = "Classification: \(topResult.identifier) with confidence \(topResult.confidence)"
            }
        }

        // Execute the request
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.classificationResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    
}
#Preview {
    ImageSelectionView()
}
