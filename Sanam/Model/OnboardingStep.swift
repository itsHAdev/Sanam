//
//  OnboardingStep.swift
//  Sanam
//

import Foundation

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: StepType

    enum StepType {
        case cards
        case coins
    }
}

extension OnboardingStep {
    static let all: [OnboardingStep] = [
        OnboardingStep(title: "هلا بك في سنام", description: "بنساعدك تدخل عالم الأسهم وتستثمر فلوسك صح...", type: .cards),
        OnboardingStep(title: " استمتع بالتعلم ", description: "بنعلمك بطريقة تشدك، وتخليك تستمتع بكل معلومة جديدة...", type: .coins)
    ]
}
