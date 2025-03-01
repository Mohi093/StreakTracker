import SwiftUI

struct ContentView: View {
    @StateObject private var streakManager = StreakManager()
    @State private var showingFreezeModal = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: streakManager.currentTheme), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Current Streak")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("\(streakManager.currentStreak)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: { showingFreezeModal = true }) {
                    Text("Freeze Streak")
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showingFreezeModal) {
            FreezeModal(isPresented: $showingFreezeModal, streakManager: streakManager)
        }
    }
}

struct FreezeModal: View {
    @Binding var isPresented: Bool
    @ObservedObject var streakManager: StreakManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Freeze Your Streak?")
                .font(.headline)
            
            Text("This will pause your streak temporarily")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button("Cancel") {
                    isPresented = false
                }
                
                Button("Confirm") {
                    streakManager.freezeStreak()
                    isPresented = false
                }
            }
        }
        .padding()
    }
}

class StreakManager: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var currentTheme: [Color] = []
    
    init() {
        loadStreak()
        updateTheme()
    }
    
    private func loadStreak() {
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
    }
    
    func freezeStreak() {
        // Implement freeze logic
        saveStreak()
    }
    
    private func saveStreak() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
    }
    
    private func updateTheme() {
        let themes: [[Color]] = [
            [.red, .yellow, .teal],
            [.blue, .green, .yellow],
            [.purple, .green, .pink],
            [.blue, .indigo, .pink],
            [.purple, .green, .orange]
        ]
        currentTheme = themes[min(currentStreak, themes.count - 1)]
    }
}
