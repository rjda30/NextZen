import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0

    var body: some View {
        Group {
            switch currentStep {
            case 0: WelcomeScreen(onGetStarted: { currentStep = 1 })
            case 1: OnboardingStepView(step: 0, onContinue: { currentStep = 2 }, onBack: { currentStep = 0 })
            case 2: OnboardingStepView(step: 1, onContinue: { currentStep = 3 }, onBack: { currentStep = 1 })
            case 3: OnboardingStepView(step: 2, onContinue: { currentStep = 4 }, onBack: { currentStep = 2 })
            default: HomeTypeScreen(onFinish: { appState.hasCompletedOnboarding = true }, onBack: { currentStep = 3 })
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
}
