import SwiftUI

struct ImageClassificationView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationResults: [ClassificationResult] = []
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Inference API \u{1F310}")
                .font(.largeTitle)
            
            Text("Image Classification")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // "Drag zone" or clickable box
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.gray)
                    .frame(height: 200)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Text("Tap here to take a photo or pick an image")
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                // Open camera or library
                isShowingImagePicker.toggle()
            }
            .padding(.horizontal)
            
            // Button to call the Django backend for image classification
            Button(action: {
                classifyImage()
            }) {
                Text("Classify Image")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(selectedImage == nil)
            
            // Display the results
            if !classificationResults.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Classification Results:")
                        .font(.title3)
                        .padding(.top, 10)
                    
                    ForEach(classificationResults) { result in
                        HStack {
                            Text(result.label)
                                .fontWeight(.medium)
                            Spacer()
                            Text(String(format: "%.3f", result.score))
                                .foregroundColor(.blue)
                        }
                        ProgressView(value: result.score, total: 1.0)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            // Present the custom ImagePicker
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func classifyImage() {
        guard let image = selectedImage else { return }
        
        // Call the DjangoService instead of HuggingFaceService
        DjangoService.shared.classifyImageViaBackend(image: image) { results in
            DispatchQueue.main.async {
                self.classificationResults = results
            }
        }
    }
}

struct ImageClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ImageClassificationView()
    }
}
