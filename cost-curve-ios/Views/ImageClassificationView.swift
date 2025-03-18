import SwiftUI

struct ImageClassificationView: View {
    // Image Picker + Classification
    @State private var selectedImage: UIImage?
    @State private var classificationResults: [ClassificationResult] = []
    @State private var isShowingImagePicker = false
    
    // Weight Input
    @State private var manualWeightString: String = ""
    @State private var selectedUnit: String = "lbs"
    
    private var calculatedWeight: Double {
        Double(manualWeightString) ?? 0.0
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("BackgroundTop"),
                    Color("BackgroundBottom")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Two-Column Layout
            HStack(alignment: .top, spacing: 20) {
                
                // MARK: - Left Column (Inference API)
                VStack(spacing: 20) {
                    // Titles
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Inference API \u{1F310}")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("Image Classification")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Dotted zone or image preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(Color("AccentColor"))
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
                                .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: 350)
                    .onTapGesture {
                        isShowingImagePicker.toggle()
                    }
                    
                    // Classify Button
                    Button(action: {
                        classifyImage()
                    }) {
                        Text("Classify Image")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
                    .frame(maxWidth: 350)
                    .disabled(selectedImage == nil)
                    
                    // Classification Results Card
                    if !classificationResults.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Classification Results:")
                                .font(.title3)
                                .padding(.top, 6)
                            
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
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .frame(maxWidth: 550)
                    }
                    
                    // MARK: - Record Item Weight
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Record Item Weight")
                            .font(.headline)
                        
                        HStack {
                            // Example text field to type in weight
                            TextField("Enter Size", text: $manualWeightString)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                            
                            Picker("Unit", selection: $selectedUnit) {
                                Text("lbs").tag("lbs")
                                Text("kg").tag("kg")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        HStack(spacing: 8) {
                            // Display the user’s input or IoT reading
                            Text("\(calculatedWeight, specifier: "%.2f") \(selectedUnit)")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            // Button to fetch from IoT scale (placeholder)
                            Button("Get from IoT Scale") {
                                // Some action to read from hardware or mock
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(Color("CardBackground").opacity(0.95))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .frame(maxWidth: 350)
                    
                    Spacer()
                }
                .frame(width: 420)
                .padding()
                
                // MARK: - Right Column (Queue / Staging)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Inventory Collection Queue")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Example Stage Cards
                            MinimalStageCard(
                                stageTitle: "Unstaged Products",
                                items: ["Item A", "Item B", "Item C"]
                            )
                            MinimalStageCard(
                                stageTitle: "Staging",
                                items: ["Staging Product 1"]
                            )
                            MinimalStageCard(
                                stageTitle: "Staged Products",
                                items: ["Staged Product 1"]
                            )
                            StageCycleCard(cycleID: "12345", isCommitted: false)
                        }
                        .padding(.top, 6)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    // MARK: - Classification Logic
    private func classifyImage() {
        guard let image = selectedImage else { return }
        DjangoService.shared.classifyImageViaBackend(image: image) { results in
            DispatchQueue.main.async {
                self.classificationResults = results
            }
        }
    }
}

// MARK: - MinimalStageCard for Unstaged, Staging, Staged
struct MinimalStageCard: View {
    let stageTitle: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stageTitle)
                .font(.headline)
                .padding(.bottom, 2)
            
            if items.isEmpty {
                Text("No items in this stage.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 6) {
                        Text("•")
                            .font(.headline)
                            .foregroundColor(Color("AccentColor"))
                        Text(item)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color("CardBackground").opacity(0.95))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - StageCycleCard for Stage Cycle Info
struct StageCycleCard: View {
    let cycleID: String
    let isCommitted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage Cycle")
                .font(.headline)
                .padding(.bottom, 2)
            
            Text("Cycle ID: \(cycleID)")
                .font(.subheadline)
            Text("Committed: \(isCommitted ? "true" : "false")")
                .font(.subheadline)
                .foregroundColor(isCommitted ? .green : .red)
        }
        .padding()
        .background(Color("CardBackground").opacity(0.95))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
struct ImageClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageClassificationView()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Light Mode")

            ImageClassificationView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Dark Mode")
        }
    }
}
