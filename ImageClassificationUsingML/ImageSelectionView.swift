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
        Text(classificationResult)

    }
    func classifyImage() {
        guard selectedImageData != nil else { return }
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            let request = VNCoreMLRequest(model: model) { request, error in
                
                print("\(request)\(String(describing: error))")
                if let results = request.results as? [VNClassificationObservation] {
                    if let topResult = results.first {
                        self.classificationResult = "Classification: \(topResult.identifier)\nConfidence: \(topResult.confidence)"
                    } else {
                        self.classificationResult = "No results found."
                    }
                } else if let error = error {
                    self.classificationResult = "Error: \(error.localizedDescription)"
                }
            }
            print("I'm here")
            //            let handler = VNImageRequestHandler(cgImage: image as! CGImage)
            //               do {
            //                   try handler.perform([request])
            //               } catch {
            //                   self.classificationResult = "Error performing image classification."
            //               }
        }
        else {
            // Handle the error gracefully
            print("Error: Failed to initialize VNCoreMLModel.")
        }
    }
}
#Preview {
    ImageSelectionView()
}
