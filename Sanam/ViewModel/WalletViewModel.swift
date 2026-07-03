//
//  WalletViewModel.swift
//  Sanam
//

import SwiftUI
import Combine

final class WalletViewModel: ObservableObject {
    @Published var holderName: String = "مستخدم سنام"
    @Published var selectedThemeID: Int = 0
    @AppStorage("walletBalance") var balance: Double = 10000

    @AppStorage("appAppearance") private var appAppearanceRaw: String = AppAppearance.system.rawValue

    @Published var showWalletSavedToast: Bool = false
    @Published var requestDismissToMain: Bool = false

    var selectedTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == selectedThemeID }) ?? CardTheme.allThemes[0]
    }

    var appAppearance: AppAppearance {
        get { AppAppearance(rawValue: appAppearanceRaw) ?? .system }
        set {
            appAppearanceRaw = newValue.rawValue
            objectWillChange.send()
        }
    }
}
