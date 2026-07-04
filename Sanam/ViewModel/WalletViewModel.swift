//
//  WalletViewModel.swift
//  Sanam
//

import SwiftUI
import Combine

final class WalletViewModel: ObservableObject {
    @Published var holderName: String = "مستخدم سنام"
    @Published var selectedThemeID: Int = 0
    @AppStorage("walletBalance") var balance: Double = 0
    @AppStorage("collectedLevelsData") private var collectedLevelsData: String = ""

    @AppStorage("appAppearance") private var appAppearanceRaw: String = AppAppearance.system.rawValue

    @Published var showWalletSavedToast: Bool = false
    @Published var requestDismissToMain: Bool = false

    var selectedTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == selectedThemeID }) ?? CardTheme.allThemes[0]
    }

    var collectedLevels: Set<Int> {
        Set(collectedLevelsData.split(separator: ",").compactMap { Int($0) })
    }

    var appAppearance: AppAppearance {
        get { AppAppearance(rawValue: appAppearanceRaw) ?? .system }
        set {
            appAppearanceRaw = newValue.rawValue
            objectWillChange.send()
        }
    }

    func collectReward(forLevel level: Int) {
        var collected = collectedLevels
        guard !collected.contains(level) else { return }
        collected.insert(level)
        collectedLevelsData = collected.map { String($0) }.joined(separator: ",")
        balance += 100
    }
}
