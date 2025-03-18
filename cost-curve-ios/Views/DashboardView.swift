import SwiftUI

enum DashboardTab {
    case dashboard, inventory, inventoryQueue, classify
}

struct DashboardView: View {
    @State private var selectedTab: DashboardTab = .dashboard
    @State private var showMoreSheet: Bool = false

    var body: some View {
        ZStack {
            // Background gradient using your named colors
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("BackgroundTop"),
                    Color("BackgroundBottom")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // MARK: - Top Bar
                HStack {
                    // Left: Logo and brand title
                    HStack(spacing: 8) {
                        Image("CostCurveLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("CostCurve.ai")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    // Right: User icon
                    Button(action: {
                        print("User icon tapped")
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .background(Color("CardBackground").opacity(0.8))

                Spacer()

                // MARK: - Main Content Area
                contentForTab(selectedTab)

                Spacer()

                // MARK: - Custom Bottom Bar with 5 Items
                // Bottom bar snippet in DashboardView:
                HStack {
                    bottomBarButton(icon: "square.grid.2x2.fill", title: "Dashboard", isSelected: selectedTab == .dashboard) {
                        selectedTab = .dashboard
                    }
                    Spacer()
                    bottomBarButton(icon: "chart.line.text.clipboard.fill", title: "Inventory", isSelected: selectedTab == .inventory) {
                        selectedTab = .inventory
                    }
                    Spacer()
                    // For Inventory Queue, we use an emoji (as before)
                    bottomBarButtonForEmoji(emoji: "🫙", title: "Queue", isSelected: selectedTab == .inventoryQueue) {
                        selectedTab = .inventoryQueue
                    }
                    Spacer()
                    // For Classify, use the CostCurveLogo
                    bottomBarButtonWithImage(imageName: "CostCurveLogo", title: "Classify", isSelected: selectedTab == .classify) {
                        selectedTab = .classify
                    }
                    Spacer()
                    // More tab remains the same
                    bottomBarButton(icon: "list.bullet", title: "More", isSelected: false) {
                        showMoreSheet = true
                    }
                }
                .padding()
                .background(Color("CardBackground").opacity(0.8))
            }
            .frame(maxWidth: .infinity) // Full width
        }
        .sheet(isPresented: $showMoreSheet) {
            MoreOptionsView()
        }
    }

    // MARK: - Content Switcher
    @ViewBuilder
    private func contentForTab(_ tab: DashboardTab) -> some View {
        switch tab {
        case .dashboard:
            DashboardHomeView()
        case .inventory:
            InventoryView()
        case .inventoryQueue:
            InventoryQueueView()
        case .classify:
            // Reference your actual ImageClassificationView from its file
            ImageClassificationView()
        }
    }

    // MARK: - Helper for Bottom Bar Buttons (using system icons)
    private func bottomBarButton(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? Color("AccentColor") : .primary)
        }
    }

    // MARK: - Helper for Bottom Bar Buttons (using Emoji)
    private func bottomBarButtonForEmoji(emoji: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(emoji)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? Color("AccentColor") : .primary)
        }
    }
    
    private func bottomBarButtonWithImage(imageName: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? Color("AccentColor") : .primary)
        }
    }
}

// MARK: - Placeholder Views

struct DashboardHomeView: View {
    var body: some View {
        VStack {
            Text("Dashboard Home")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct InventoryView: View {
    var body: some View {
        VStack {
            Text("Inventory Section")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct InventoryQueueView: View {
    var body: some View {
        VStack {
            Text("Inventory Collection Queue")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct MoreOptionsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                NavigationLink(destination: HelpView()) {
                    Text("Help")
                }
            }
            .navigationTitle("More Options")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Page")
            .font(.largeTitle)
            .padding()
    }
}

struct AboutView: View {
    var body: some View {
        Text("About Page")
            .font(.largeTitle)
            .padding()
    }
}

struct HelpView: View {
    var body: some View {
        Text("Help Page")
            .font(.largeTitle)
            .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
                .previewDisplayName("Light Mode")
            DashboardView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
