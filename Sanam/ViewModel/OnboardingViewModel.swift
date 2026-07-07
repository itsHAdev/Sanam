//
//  OnboardingViewModel.swift
//  Sanam
//

import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var showMainTab = false

    let steps: [OnboardingStep] = OnboardingStep.all

    var isFirstStep: Bool { currentStep == 0 }
    var isLastStep: Bool { currentStep == steps.count - 1 }

    func skip() {
        showMainTab = true
    }

    func start() {
        showMainTab = true
    }
}
