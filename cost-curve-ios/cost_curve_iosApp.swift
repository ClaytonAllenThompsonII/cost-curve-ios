//
//  cost_curve_iosApp.swift
//  cost-curve-ios
//
//  Created by Clayton Thompson on 2/22/25.
//

import SwiftUI
import SwiftData

@main
struct cost_curve_iosApp: App {
    // Tracks whether the user is logged in
    @State private var isLoggedIn = false
    
    // Tracks whether the splash screen is still active
    @State private var isSplashActive = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            // We can skip NavigationView here if we want the splash to be full screen
            Group {
                if isSplashActive {
                    // Show the splash first
                    SplashView(isSplashActive: $isSplashActive)
                } else {
                    // Once the splash is done, show Login or Dashboard
                    if isLoggedIn {
                        DashboardView()
                            .modelContainer(sharedModelContainer)
                    } else {
                        LoginView(isLoggedIn: $isLoggedIn)
                            .modelContainer(sharedModelContainer)
                    }
                }
            }
        }
    }
}
