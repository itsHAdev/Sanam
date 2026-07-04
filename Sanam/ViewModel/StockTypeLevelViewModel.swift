//
//  StockTypeLevelViewModel.swift
//  Sanam
//

import Foundation
import Combine

final class StockTypeLevelViewModel: ObservableObject {
    let model = StockTypeModel()

    @Published var company: Company?
    @Published var selectedCard: Int? = nil
    @Published var visitedSpeculative = false
    @Published var visitedSafe = false

    // مضارب
    @Published var isSimulatingSpeculative = false
    @Published var pricesForChart: [Double] = []
    @Published var ticksRemaining: Int = 0
    @Published var speculativeTimeIndex: Int = 0
    @Published var speculativePriceChange: Double = 0
    private var speculativeTimer: Timer?

    // آمن
    @Published var isSimulatingSafe = false
    @Published var pricesForSafeChart: [Double] = []
    @Published var safeTicksRemaining: Int = 0
    @Published var safeTimeIndex: Int = 0
    @Published var safePriceChange: Double = 0
    private var safeTimer: Timer?

    var speculativeTimeLabels: [String] { model.speculativeTimeLabels }
    var safeTimeLabels: [String] { model.safeTimeLabels }

    func setCompany(_ company: Company?) {
        self.company = company
    }

    func selectSpeculative() {
        selectedCard = 1
        visitedSpeculative = true
        stopSafeSimulation()
        startSpeculativeSimulation()
    }

    func selectSafe() {
        selectedCard = 2
        visitedSafe = true
        stopSpeculativeSimulation()
        startSafeSimulation()
    }

    func closePopup() {
        if selectedCard == 1 { stopSpeculativeSimulation() }
        else if selectedCard == 2 { stopSafeSimulation() }
        selectedCard = nil
    }

    // MARK: - Speculative Simulation
    private func startSpeculativeSimulation() {
        guard let company else { return }
        stopSpeculativeSimulation()

        let base = max(1.0, company.stock.currentPrice)
        var seed = base
        pricesForChart = [seed]
        speculativeTimeIndex = 0
        speculativePriceChange = 0

        isSimulatingSpeculative = true
        ticksRemaining = 60

        speculativeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            let volatility = Swift.max(0.5, base * 0.015)
            let jump = Double.random(in: -2.5...2.5) * volatility
            seed = Swift.max(0.1, seed + jump)

            if self.pricesForChart.count > 120 { self.pricesForChart.removeFirst() }
            self.pricesForChart.append(seed)

            let elapsed = 60 - self.ticksRemaining
            self.speculativeTimeIndex = Swift.min(elapsed / 15, self.speculativeTimeLabels.count - 1)
            self.speculativePriceChange = ((seed - base) / base) * 100

            self.ticksRemaining -= 1
            if self.ticksRemaining <= 0 { self.stopSpeculativeSimulation() }
        }
        RunLoop.main.add(speculativeTimer!, forMode: .common)
    }

    private func stopSpeculativeSimulation() {
        speculativeTimer?.invalidate()
        speculativeTimer = nil
        isSimulatingSpeculative = false
    }

    // MARK: - Safe Simulation
    private func startSafeSimulation() {
        guard let company else { return }
        stopSafeSimulation()

        let base = Swift.max(1.0, company.stock.currentPrice)
        var seed = base
        pricesForSafeChart = [seed]
        safeTimeIndex = 0
        safePriceChange = 0

        isSimulatingSafe = true
        safeTicksRemaining = 60

        safeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            let tinyVolatility = Swift.max(0.02, base * 0.0008)
            let jump = Double.random(in: -1.0...1.0) * tinyVolatility
            seed = Swift.max(0.1, seed + jump)

            if self.pricesForSafeChart.count > 120 { self.pricesForSafeChart.removeFirst() }
            self.pricesForSafeChart.append(seed)

            let elapsed = 60 - self.safeTicksRemaining
            self.safeTimeIndex = Swift.min(elapsed / 15, self.safeTimeLabels.count - 1)
            self.safePriceChange = ((seed - base) / base) * 100

            self.safeTicksRemaining -= 1
            if self.safeTicksRemaining <= 0 { self.stopSafeSimulation() }
        }
        RunLoop.main.add(safeTimer!, forMode: .common)
    }

    private func stopSafeSimulation() {
        safeTimer?.invalidate()
        safeTimer = nil
        isSimulatingSafe = false
    }
}
