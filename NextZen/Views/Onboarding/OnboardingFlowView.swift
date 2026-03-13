import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeStore: HomeStore
    @State private var currentStep = 0
    // Personalization answers
    @State private var homeType: String = ""
    @State private var homeSize: String = ""
    @State private var primaryGoal: String = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            switch currentStep {
            case 0: WelcomeScreen(onGetStarted: { next() })
            case 1: OnboardingQuestionView(
                        step: 0,
                        question: "What type of home do you live in?",
                        options: ["🏠 House", "🏢 Apartment", "🏡 Condo", "📦 Studio"],
                        selected: $homeType,
                        onContinue: { next() }, onBack: { prev() })
            case 2: OnboardingQuestionView(
                        step: 1,
                        question: "How big is your home?",
                        options: ["🛏 Studio / 1BR", "🏠 2–3 Bedrooms", "🏡 4+ Bedrooms", "🏢 Large Estate"],
                        selected: $homeSize,
                        onContinue: { next() }, onBack: { prev() })
            case 3: OnboardingQuestionView(
                        step: 2,
                        question: "What's your primary goal?",
                        options: ["📦 Track My Items", "🔔 Maintenance Alerts", "📄 Store Documents", "💰 Warranty Tracking"],
                        selected: $primaryGoal,
                        onContinue: { next() }, onBack: { prev() })
            case 4: OnboardingFeatureView(step: 0, onContinue: { next() }, onBack: { prev() })
            case 5: OnboardingFeatureView(step: 1, onContinue: { next() }, onBack: { prev() })
            default: PaywallView(
                        onContinue: {
                            applyPersonalization()
                            appState.hasCompletedOnboarding = true
                        },
                        onBack: { prev() })
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    private func next() { currentStep += 1 }
    private func prev() { if currentStep > 0 { currentStep -= 1 } }

    private func applyPersonalization() {
        if homeType.contains("Apartment") {
            homeStore.homeName = "My Apartment"
        } else if homeType.contains("Condo") {
            homeStore.homeName = "My Condo"
        } else {
            homeStore.homeName = "My Home"
        }
    }
}
