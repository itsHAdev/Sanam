//
//  RumorGameView.swift
//  Sanam
//

import SwiftUI

struct RumorGameView: View {

    @StateObject private var vm = RumorGameViewModel()
    @StateObject private var rewardVM = PortfolioViewModel()
    @ObservedObject var levelsVM: LevelsViewModel
    @EnvironmentObject var walletVM: WalletViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showReward = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("backFrame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                content
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if vm.showSuccess {
                LevelDoneButton {
                    showReward = true
                }
            }

            if showReward {
                PortfolioCongratsView(vm: rewardVM, onFinished: {
                    walletVM.collectReward(forLevel: 3)
                    if levelsVM.currentLevel <= 3 {
                        levelsVM.currentLevel = 4
                    }
                    dismiss()
                }, onClose: {
                    showReward = false
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReward)
        .navigationTitle("أسطورة الأسهم")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var content: some View {
        if vm.showSuccess {
            successView
        } else if vm.showFailure {
            failureView
        } else {
            playView
        }
    }

    // MARK: - Success View
    private var successView: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.green)
            }

            VStack(spacing: 12) {
                Text("كفو عليك!")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.green)

                Text("توقعك صح")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(vm.userChoseUp ? "ارتفع سعر السهم زي ما توقعت" : "نزل سعر السهم زي ما توقعت")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)

                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.15))
                    .frame(height: 92)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .overlay {
                        HStack {
                            VStack(spacing: 8) {
                                Text("التغيير")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text(vm.userChoseUp ? "+9.99" : "-9.99")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(vm.userChoseUp ? .green : .red)
                            }
                            Spacer()
                            Divider()
                                .frame(height: 50)
                                .background(Color.gray.opacity(0.5))
                            Spacer()
                            VStack(spacing: 8) {
                                Text("السعر الحين")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text(vm.userChoseUp ? "108.99" : "89.99")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.horizontal, 16)

                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.15))
                    .frame(height: 92)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .overlay {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 6) {
                                Text("السبب")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                Text(vm.userChoseUp ? vm.rumor.reasonIfUp : vm.rumor.reasonIfDown)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                            Image(systemName: "fuelpump.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Color(red: 109 / 255, green: 144 / 255, blue: 229 / 255))
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.horizontal, 16)

            }
        }
    }

    // MARK: - Failure View
    private var failureView: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 80, height: 80)
                Image(systemName: "xmark")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.red)
            }

            VStack(spacing: 12) {
                Text("ما جبتها صح")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.red)

                Text("توقعك مو بمحله")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(vm.userChoseUp ? "انخفض سعر السهم عكس توقعك" : "ارتفع سعر السهم عكس توقعك")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }

            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.15))
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .overlay {
                    HStack {
                        VStack(spacing: 8) {
                            Text("التغيير")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(vm.userChoseUp ? "-1.23" : "+1.23")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(vm.userChoseUp ? .red : .green)
                        }
                        Spacer()
                        Divider()
                            .frame(height: 50)
                            .background(Color.gray.opacity(0.5))
                        Spacer()
                        VStack(spacing: 8) {
                            Text("السعر الحين")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text("9.99")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.horizontal, 16)

            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.15))
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .overlay {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("السبب")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text(vm.userChoseUp ? vm.rumor.reasonUserChoseUpButFailed : vm.rumor.reasonUserChoseDownButFailed)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        Image(systemName: "fuelpump.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(red: 109 / 255, green: 144 / 255, blue: 229 / 255))
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.horizontal, 16)

            PrimaryButton(title: "جرب مرة ثانية") {
                vm.retry()
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)
        }
    }

    // MARK: - Play View
    private var playView: some View {
        VStack(spacing: 24) {
            VStack(alignment: .trailing, spacing: 4) {
                Text("من إشاعة اليوم والرسم البياني وش تتوقع تكون حالة السهم بكرة؟")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 20)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.2))

                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(vm.rumor.companyName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text(vm.rumor.sector)
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                        Text(vm.rumor.icon)
                            .font(.system(size: 24))
                    }
                    .environment(\.layoutDirection, .leftToRight)

                    HStack {
                        Spacer()
                        HStack(alignment: .bottom, spacing: 12) {
                            Text(vm.isStockUp ? "+٩.٩٪" : "-٩.٩٪")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(vm.isStockUp ? .green : .red)
                            Text("٩٩.٩٩")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .environment(\.layoutDirection, .leftToRight)
                    }

                    RumorStaticChart(isUp: vm.isStockUp)
                        .frame(height: 220)
                        .padding(.horizontal, 8)
                }
                .padding(16)
            }
            .frame(width: 358, height: 400)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.1))
            )

            HStack(spacing: 24) {
                Button {
                    vm.choose(up: false)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "chart.line.downtrend.xyaxis")
                        Text("ينزل")
                    }
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 130, height: 50)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.98, green: 0.35, blue: 0.32),
                                Color(red: 0.93, green: 0.25, blue: 0.22)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2))
                            .glassEffect()
                            .opacity(0.5)
                    )
                }

                Button {
                    vm.choose(up: true)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("يرتفع")
                    }
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 130, height: 50)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.20, green: 0.80, blue: 0.38),
                                Color(red: 0.12, green: 0.70, blue: 0.28)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2))
                            .glassEffect()
                            .opacity(0.5)
                    )
                }
            }
            .padding(.top, 16)
        }
        .overlay(rumorPopupOverlay)
    }

    // MARK: - Rumor Popup
    private var rumorPopupOverlay: some View {
        Group {
            if vm.showRumorPopup {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    Text("إشاعات اليوم")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white)

                    Image(systemName: "fuelpump.fill")
                        .font(.system(size: 84))
                        .foregroundColor(Color(red: 109 / 255, green: 144 / 255, blue: 229 / 255))

                    VStack(spacing: 12) {
                        Text(vm.rumor.headline)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        Text(vm.rumor.description)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    PrimaryButton(title: "حسنًا") {
                        vm.dismissRumorPopup()
                    }
                }
                .padding(32)
                .frame(width: 353)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black.opacity(0.45))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
            }
        }
    }

    // MARK: - Static Chart
    struct RumorStaticChart: View {

        let isUp: Bool

        var prices: [Double] {
            isUp
            ? [62, 65, 63, 68, 66, 71, 69, 74, 72, 76, 75, 79, 77, 82, 85, 83, 88, 86, 91, 90, 94, 92, 96, 95, 99]
            : [99, 95, 97, 92, 94, 89, 91, 86, 88, 83, 85, 80, 78, 75, 73, 76, 70, 72, 67, 69, 64, 66, 63, 65, 62]
        }

        var chartColor: Color { isUp ? .green : .red }
        let xLabels = ["٧", "٦", "٥", "٤", "٣", "٢", "١"]

        var body: some View {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    VStack {
                        let max = prices.max() ?? 1
                        let min = prices.min() ?? 0
                        let step = (max - min) / 4
                        ForEach(0..<5) { i in
                            if i > 0 { Spacer() }
                            Text(String(format: "%.0f", max - step * Double(i)))
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 30)

                    GeometryReader { geo in
                        let width = geo.size.width
                        let height = geo.size.height
                        let max = prices.max() ?? 1
                        let min = prices.min() ?? 0
                        let range = max - min

                        ZStack {
                            Path { path in
                                for i in 0...4 {
                                    let y = height * CGFloat(i) / 4
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: width, y: y))
                                }
                                for i in 0...6 {
                                    let x = width * CGFloat(i) / 6
                                    path.move(to: CGPoint(x: x, y: 0))
                                    path.addLine(to: CGPoint(x: x, y: height))
                                }
                            }
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)

                            Path { path in
                                for i in prices.indices {
                                    let x = width * CGFloat(i) / CGFloat(prices.count - 1)
                                    let y = height - CGFloat((prices[i] - min) / range) * height
                                    if i == 0 {
                                        path.move(to: CGPoint(x: x, y: height))
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.closeSubpath()
                            }
                            .fill(LinearGradient(
                                colors: [chartColor.opacity(0.35), chartColor.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))

                            Path { path in
                                for i in prices.indices {
                                    let x = width * CGFloat(i) / CGFloat(prices.count - 1)
                                    let y = height - CGFloat((prices[i] - min) / range) * height
                                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                                }
                            }
                            .stroke(chartColor, lineWidth: 2)
                        }
                    }
                }

                HStack {
                    Spacer().frame(width: 34)
                    ForEach(xLabels, id: \.self) { label in
                        Text(label)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                        if label != xLabels.last { Spacer() }
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    NavigationStack {
        RumorGameView(levelsVM: LevelsViewModel())
    }
    .environmentObject(WalletViewModel())
}
