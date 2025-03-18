//
//  SplashView.swift
//  cost-curve-ios
//
//  Created by Clayton Thompson on 3/17/25.
//

//
//  SplashView.swift
//  cost-curve-ios
//

import SwiftUI

struct SplashView: View {
    @Binding var isSplashActive: Bool
    
    // Example animation states
    @State private var logoScale: CGFloat = 0.6
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // A background color (could be a gradient if you prefer)
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // The Logo
            Image("CostCurveLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(logoScale)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            // 1) Start an animation (scaling or rotating) immediately
            withAnimation(.easeInOut(duration: 2.5)) {
                self.logoScale = 1.0
                self.rotation = 360
            }
            
            // 2) Hide the splash after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    isSplashActive = false
                }
            }
        }
    }
}

// MARK: - Preview
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isSplashActive: .constant(true))
    }
}
