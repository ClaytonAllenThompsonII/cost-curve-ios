import SwiftUI

struct ImageClassificationView: View {
    // Image Picker + Classification
    @State private var selectedImage: UIImage?
    @State private var classificationResults: [ClassificationResult] = []
    @State private var isShowingImagePicker = false
    
    // Product Classifications
    @State private var productClassifications: [ProductClassification] = []
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
                            // 1) Large, monospaced font (44pt).
                                //    If you have "Digital-7" as a custom font, use .font(.custom("Digital-7", size: 44))
                                .font(.system(size: 22, weight: .regular, design: .monospaced))

                                // 2) Text color: bright green (#00ff00)
                                .foregroundColor(Color.green)
                                
                                // 3) Background color: dark gray (#333)
                                .padding(20)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2)) // #333 is approximately (0.2, 0.2, 0.2)
                                
                                // 4) Rounded corners + shadow
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                                
                                // 5) Constrain width (similar to max-width: 300px)
                                .frame(maxWidth: 300)
                                
                                // 6) Optional: center horizontally + add top margin
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Button to fetch from IoT scale (placeholder)
                            Button("Get from IoT Scale") {
                                // Some action to read from hardware or mock
                            }
                            .buttonStyle(.borderedProminent)
                            // 6) Optional: center horizontally + add top margin
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
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
                    
                    Spacer()
                            
                            // Start Inventory Cycle button
                            Button("Start Inventory Cycle") {
                                // TODO: Add logic for starting cycle
                                print("Start Inventory Cycle tapped")
                            }
                            .buttonStyle(.borderedProminent)
                            
                    
                    ScrollView { VStack(alignment: .leading, spacing: 16) {
                        // Unstaged Products
                        CollapsibleResizableCard(
                            stageTitle: "Unstaged Products",
                            items: productClassifications.map { $0.name }
                        )
                        
                        // Staging
                        CollapsibleResizableCard(
                            stageTitle: "Staging",
                            items: ["Staging Product 1"]
                        )
                        
                        // Staged
                        CollapsibleResizableCard(
                            stageTitle: "Staged Products",
                            items: ["Staged Product 1"]
                        )
                        
                        // Stage Cycle
                        CollapsibleResizableCard(
                            stageTitle: "Cycle Commit Summary",
                            items: [
                                "Cycle ID: 12345",
                                "Committed: false"
                            ]
                        )
                        // Commit Cycle button
                        Button("Commit Cycle") {
                            // TODO: Add logic for committing cycle
                            print("Commit Cycle tapped")
                        }
                        .buttonStyle(.borderedProminent)
                        
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
                                            
        // MARK: - Image Picker Sheet
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        // MARK: - Fetch Products on Appear
                .onAppear {
                    ProductService.shared.fetchProductClassifications { fetched in
                        DispatchQueue.main.async {
                            self.productClassifications = fetched
                        }
                    }
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

// MARK: - Now, CollapsibleStageCard -- prev MinimalStageCard for Unstaged, Staging, Staged
/// A card that can collapse/expand and has a drag-resizable content area.
/// Perfect for showing a header and a scrollable list of items.
struct CollapsibleResizableCard: View {
    let stageTitle: String
    let items: [String]
    
    // Whether the card is expanded (content visible) or collapsed (content hidden)
    @State private var isExpanded: Bool = true
    
    // The dynamic height of the content area when expanded
    @State private var cardHeight: CGFloat = 200
    
    // Minimum and maximum allowable heights
    let minHeight: CGFloat = 100
    let maxHeight: CGFloat = 600
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Header (title + chevron)
            HStack {
                Text(stageTitle)
                    .font(.headline)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 2)
            
            // MARK: - Expandable/Collapsible Content
            if isExpanded {
                // We wrap the list in a scrollable container
                VStack(spacing: 0) {
                    if items.isEmpty {
                        Text("No items in this stage.")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .padding(.vertical, 6)
                    } else {
                        // A scrollable list of items with subtle dividers
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(items.indices, id: \.self) { index in
                                    HStack {
                                        Text(items[index])
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                    .padding(.vertical, 6)
                                    
                                    // Divider after each row except the last
                                    if index < items.count - 1 {
                                        Divider()
                                            .background(Color.gray.opacity(0.3))
                                    }
                                }
                            }
                        }
                    }
                }
                // The card's content is sized by cardHeight
                .frame(height: cardHeight)
                .clipped()
                // Overlay a transparent rectangle at the bottom to handle drag gestures
                .overlay(
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 8)  // A small "handle" area
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newHeight = cardHeight + value.translation.height
                                    // Clamp between minHeight and maxHeight
                                    cardHeight = min(max(newHeight, minHeight), maxHeight)
                                }
                        ),
                    alignment: .bottom
                )
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
