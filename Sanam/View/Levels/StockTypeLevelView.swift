//
//  StockTypeLevelView.swift
//  Sanam
//

import SwiftUI

struct StockTypeLevelView: View {
    @StateObject private var vm = StockTypeLevelViewModel()
    @StateObject private var rewardVM = PortfolioViewModel()
    @ObservedObject var levelsVM: LevelsViewModel
    @EnvironmentObject var simulatorVM: SimulatorViewModel
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

            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    Text("اختار نوع السهم")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    VStack(spacing: 16) {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                vm.selectSpeculative()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 80, weight: .medium))
                                    .foregroundColor(Color(red: 157 / 255, green: 181 / 255, blue: 239 / 255))
                                Spacer()
                                VStack(alignment: .trailing, spacing: 18) {
                                    Text("السهم المضارب")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("تشتري وتراقب وش يتغير بالسهم.")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            .padding(.horizontal, 28)
                            .frame(width: 361, height: 176)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                vm.selectSafe()
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 80, weight: .medium))
                                        .foregroundColor(Color(red: 157 / 255, green: 181 / 255, blue: 239 / 255))
                                    Image(systemName: "shield.fill")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(Color(red: 157 / 255, green: 181 / 255, blue: 239 / 255))
                                        .offset(x: 29, y: -18)
                                }
                                .frame(width: 90, height: 90)
                                Spacer()
                                VStack(alignment: .trailing, spacing: 18) {
                                    Text("السهم الآمن")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("تشتري بدون ما تراقب بشكل مستمر وش يتغير بالسهم.")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            .padding(.horizontal, 28)
                            .frame(width: 361, height: 176)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }

                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                vm.setCompany(simulatorVM.companies.randomElement())
            }

            if vm.visitedSpeculative && vm.visitedSafe {
                LevelDoneButton {
                    showReward = true
                }
            }

            if let selected = vm.selectedCard {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            vm.closePopup()
                        }
                    }

                popupContent(for: selected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }

            if showReward {
                PortfolioCongratsView(vm: rewardVM, onFinished: {
                    walletVM.collectReward(forLevel: 4)
                    if levelsVM.currentLevel <= 4 {
                        levelsVM.currentLevel = 5
                    }
                    dismiss()
                })
                .transition(.opacity.combined(with: .scale))
                .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReward)
        .navigationTitle("المستثمر الذكي")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Popup Content
    @ViewBuilder
    private func popupContent(for card: Int) -> some View {
        let isSpeculative = (card == 1)

        let timeLabel: String = isSpeculative
            ? vm.speculativeTimeLabels[min(vm.speculativeTimeIndex, vm.speculativeTimeLabels.count - 1)]
            : vm.safeTimeLabels[min(vm.safeTimeIndex, vm.safeTimeLabels.count - 1)]

        let titleText = isSpeculative ? "السهم المضارب" : "السهم الآمن"

        let showDescription: Bool = {
            if isSpeculative { return !vm.isSimulatingSpeculative && vm.ticksRemaining == 0 }
            return !vm.isSimulatingSafe && vm.safeTicksRemaining == 0
        }()

        let descriptionText: String = isSpeculative ? vm.model.speculativeDescription : vm.model.safeDescription

        let displayedPrices: [Double] = isSpeculative ? vm.pricesForChart : vm.pricesForSafeChart

        let livePrice: Double = isSpeculative
            ? (vm.pricesForChart.last ?? vm.company?.stock.currentPrice ?? 0)
            : (vm.pricesForSafeChart.last ?? vm.company?.stock.currentPrice ?? 0)

        let priceChange: Double = isSpeculative ? vm.speculativePriceChange : vm.safePriceChange
        let priceColor: Color = priceChange >= 0 ? .green : .red

        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                        vm.closePopup()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(10)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            VStack(spacing: 20) {

                HStack(alignment: .top) {
                    VStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 157 / 255, green: 181 / 255, blue: 239 / 255))
                        Text(timeLabel)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                            .animation(.easeInOut, value: timeLabel)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 12) {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("بيرن اكس")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text("قطاع الأعمال")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)

                                HStack(spacing: 8) {
                                    let changePrefix = priceChange >= 0 ? "+" : ""
                                    Text(arabicNumerals("\(changePrefix)\(String(format: "%.2f", priceChange))%"))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(priceColor)
                                        .animation(.easeInOut, value: priceChange)

                                    Text(arabicNumerals(String(format: "%.2f", livePrice)))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(priceColor)
                                        .animation(.easeInOut, value: livePrice)
                                }
                            }
                            Image("bx")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                }

                if !displayedPrices.isEmpty {
                    LiveChartWithAxes(
                        prices: displayedPrices,
                        isSpeculative: isSpeculative,
                        timeLabels: isSpeculative ? vm.speculativeTimeLabels : vm.safeTimeLabels,
                        timeIndex: isSpeculative ? vm.speculativeTimeIndex : vm.safeTimeIndex
                    )
                    .frame(height: 180)
                }

                Text(titleText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                if showDescription {
                    Text(descriptionText)
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.trailing)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .frame(width: 361)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - الشارت مع محورين X و Y
struct LiveChartWithAxes: View {
    let prices: [Double]
    let isSpeculative: Bool
    let timeLabels: [String]
    let timeIndex: Int

    var chartColor: Color {
        guard prices.count > 1 else { return .green }
        return prices.last! >= prices.first! ? .green : .red
    }

    var yLabels: [String] {
        let maxPrice = prices.max() ?? 1
        let minPrice = prices.min() ?? 0
        let step = (maxPrice - minPrice) / 3
        return (0..<4).map { i in
            String(format: "%.0f", maxPrice - step * Double(i))
        }
    }

    var xLabels: [String] {
        let count = Swift.min(timeIndex + 1, timeLabels.count)
        return Array(timeLabels.prefix(count))
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {

                VStack {
                    ForEach(Array(yLabels.enumerated()), id: \.offset) { i, label in
                        if i > 0 { Spacer() }
                        Text(arabicNumerals(label))
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 32)

                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    let maxPrice = prices.max() ?? 1
                    let minPrice = prices.min() ?? 0
                    let range = Swift.max(maxPrice - minPrice, 0.01)

                    ZStack {
                        Path { path in
                            for i in 0...3 {
                                let y = height * CGFloat(i) / 3
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            for i in 0...4 {
                                let x = width * CGFloat(i) / 4
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x, y: height))
                            }
                        }
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)

                        Path { path in
                            for i in prices.indices {
                                let x = width * CGFloat(i) / CGFloat(Swift.max(prices.count - 1, 1))
                                let y = height - CGFloat((prices[i] - minPrice) / range) * height
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
                            colors: [chartColor.opacity(0.3), chartColor.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        ))

                        Path { path in
                            for i in prices.indices {
                                let x = width * CGFloat(i) / CGFloat(Swift.max(prices.count - 1, 1))
                                let y = height - CGFloat((prices[i] - minPrice) / range) * height
                                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                else { path.addLine(to: CGPoint(x: x, y: y)) }
                            }
                        }
                        .stroke(chartColor, lineWidth: 2)

                        if let last = prices.last, prices.count > 1 {
                            let x = width
                            let y = height - CGFloat((last - minPrice) / range) * height
                            Circle()
                                .fill(chartColor)
                                .frame(width: 6, height: 6)
                                .offset(x: x - 3, y: y - 3)
                        }
                    }
                }
            }

            HStack {
                Spacer().frame(width: 36)
                ForEach(Array(xLabels.enumerated()), id: \.offset) { i, label in
                    Text(label)
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                    if i < xLabels.count - 1 { Spacer() }
                }
            }
            .animation(.easeInOut, value: timeIndex)
        }
    }
}

#Preview {
    NavigationStack {
        StockTypeLevelView(levelsVM: LevelsViewModel())
            .environmentObject(SimulatorViewModel())
            .environmentObject(WalletViewModel())
    }
}
