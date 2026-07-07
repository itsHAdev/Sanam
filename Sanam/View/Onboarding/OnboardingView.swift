//
//  OnboardingView.swift
//  Sanam
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()

    var body: some View {
        Group {
            if vm.showMainTab {
                RootTabView()
            } else {
                ZStack {
                    Color(.backApp)
                        .ignoresSafeArea()
                        .overlay(
                            Image("Frame")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                        )

                    VStack {
                        HStack {
                            Spacer()
                            if vm.isFirstStep {
                                Button("تخطي") {
                                    withAnimation {
                                        vm.skip()
                                    }
                                }
                                .foregroundColor(.textApp)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 10)

                        TabView(selection: $vm.currentStep) {
                            ForEach(Array(vm.steps.enumerated()), id: \.element.id) { index, step in
                                OnboardingStepContentView(step: step, isCurrent: vm.currentStep == index)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))

                        HStack(spacing: 8) {
                            ForEach(Array(vm.steps.enumerated()), id: \.element.id) { index, _ in
                                Circle()
                                    .fill(vm.currentStep == index ? Color.primaryApp : Color.grayApp)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)

                        if vm.isLastStep {
                            PrimaryButton(title: "ابدأ الآن") {
                                withAnimation {
                                    vm.start()
                                }
                            }
                        }
                        Spacer().frame(height: 30)
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
}

// MARK: - Step Content

struct OnboardingStepContentView: View {
    let step: OnboardingStep
    let isCurrent: Bool

    @State private var startAnimation = false

    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()

            ZStack {
                if step.type == .cards {
                    ZStack {
                        Image("right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230)
                            .rotationEffect(.degrees(-22))
                            .offset(x: startAnimation ? 25 : 500, y: -30)
                            .animation(.spring(response: 1.2, dampingFraction: 0.85), value: startAnimation)

                        Image("left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230)
                            .rotationEffect(.degrees(-12))
                            .offset(x: startAnimation ? -15 : -500, y: 35)
                            .animation(.spring(response: 1.2, dampingFraction: 0.85), value: startAnimation)
                    }
                } else {
                    ZStack {
                        Image("1").resizable().scaledToFit().frame(width: 75, height: 75)
                            .rotationEffect(.degrees(-5))
                            .offset(x: -5, y: startAnimation ? -100 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.0), value: startAnimation)

                        Image("2").resizable().scaledToFit().frame(width: 70, height: 70)
                            .rotationEffect(.degrees(15))
                            .offset(x: -55, y: startAnimation ? -30 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.25), value: startAnimation)

                        Image("3").resizable().scaledToFit().frame(width: 72, height: 72)
                            .rotationEffect(.degrees(-20))
                            .offset(x: 45, y: startAnimation ? 20 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.5), value: startAnimation)

                        Image("4").resizable().scaledToFit().frame(width: 68, height: 68)
                            .rotationEffect(.degrees(10))
                            .offset(x: -35, y: startAnimation ? 85 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.75), value: startAnimation)

                        Image("5").resizable().scaledToFit().frame(width: 38, height: 65)
                            .rotationEffect(.degrees(-35))
                            .offset(x: 40, y: startAnimation ? 145 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(1.0), value: startAnimation)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 350)

            Spacer()

            VStack(alignment: .leading, spacing: 15) {
                Text(step.title)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.textApp)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(step.description)
                    .font(.system(size: 20))
                    .foregroundColor(.textApp)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 70)
        }
        .onChange(of: isCurrent) { active in
            startAnimation = active
        }
        .onAppear {
            if isCurrent { startAnimation = true }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(SimulatorViewModel())
        .environmentObject(WalletViewModel())
}
