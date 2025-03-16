import SwiftUI

struct ImageClassificationView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationResults: [ClassificationResult] = []
    @State private var isShowingImagePicker = false

    var body: some View {
        ZStack {
            // MARK: - Gradient Background using named colors
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("BackgroundTop"),
                    Color("BackgroundBottom")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Main Content (Centered and Constrained)
            VStack(spacing: 20) {
                Text("Inference API \u{1F310}")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Image Classification")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // MARK: - Image Selection Card (Drag Zone)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(Color("TextFieldBackground"))
                        .frame(height: 230)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 230)
                    } else {
                        Text("Tap here to take a photo or pick an image")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: 350)
                .onTapGesture {
                    isShowingImagePicker.toggle()
                }
                .padding(.horizontal)
                
                // MARK: - Classification Button using AccentColor
                Button(action: {
                    classifyImage()
                }) {
                    Text("Classify Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color("AccentColor"))
                .cornerRadius(8)
                .frame(maxWidth: 350)
                .disabled(selectedImage == nil)
                
                // MARK: - Display Classification Results
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
                                    .foregroundColor(Color("AccentColor"))
                            }
                            ProgressView(value: result.score, total: 1.0)
                        }
                    }
                    .padding()
                    .background(Color("CardBackground").opacity(0.95))
                    .cornerRadius(8)
                    .frame(maxWidth: 550)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: 600) // Constrain overall width
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func classifyImage() {
        guard let image = selectedImage else { return }
        DjangoService.shared.classifyImageViaBackend(image: image) { results in
            DispatchQueue.main.async {
                self.classificationResults = results
            }
        }
    }
}

struct ImageClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageClassificationView()
                .previewDisplayName("Light Mode")
            ImageClassificationView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
