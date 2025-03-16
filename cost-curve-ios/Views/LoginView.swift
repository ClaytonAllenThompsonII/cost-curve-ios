import SwiftUI
import CoreHaptics

struct LoginView: View {
    // MARK: - State Variables
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var errorMessage: String?
    
    // Loading indicator for the login button
    @State private var isLoading: Bool = false
    
    // For fade-in animation of the card
    @State private var cardOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // MARK: - Gradient Background Using Named Colors
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("BackgroundTop"),
                    Color("BackgroundBottom")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Main VStack (centering the card)
            VStack {
                Spacer()
                
                // MARK: - Card Container
                VStack(spacing: 20) {
                    
                    // MARK: - Logo
                    Image("CostCurveLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    
                    // MARK: - Brand Title & Tagline
                    VStack(spacing: 4) {
                        Text("Cost Curve")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Welcome to Cost Curve")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Log in to continue to iOS app")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    
                    // MARK: - Text Fields (with SF Symbols)
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Username", text: $username)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(8)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $password)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: 300)
                    
                    // MARK: - Remember Me Toggle
                    Toggle("Remember Me", isOn: $rememberMe)
                        .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 300, alignment: .leading)
                    
                    // MARK: - Login Button
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        isLoading = true
                        AuthService.shared.login(username: username, password: password) { token in
                            isLoading = false
                            if let token = token {
                                TokenManager.shared.saveToken(token)
                                print("Login successful, token = \(token)")
                            } else {
                                errorMessage = "Invalid credentials"
                            }
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 20, height: 20)
                        } else {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                    }
                    .background(Color("AccentColor"))
                    .cornerRadius(8)
                    .frame(maxWidth: 300)
                    
                    // MARK: - Forgot Password Link
                    Button("Forgot Password?") {
                        print("Forgot password tapped")
                    }
                    .font(.footnote)
                    .foregroundColor(Color("AccentColor"))
                    
                    // MARK: - Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color("CardBackground").opacity(0.95))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 0)
                .padding(.horizontal, 24)
                .opacity(cardOpacity)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                cardOpacity = 1.0
            }
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .previewDisplayName("Light Mode")
            LoginView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
