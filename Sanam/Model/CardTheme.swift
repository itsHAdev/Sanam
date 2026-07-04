//
//  CardTheme.swift
//  Sanam
//

import SwiftUI

struct CardTheme: Identifiable, Equatable {
    let id: Int
    let name: String
    let backgroundImage: String
    let camelColor: String
    let textColor: Color
    let accentColor: Color
}

extension CardTheme {
    static let allThemes: [CardTheme] = [
        CardTheme(
            id: 0,
            name: "الكلاسيكي الداكن",
            backgroundImage: "DefaultCard",
            camelColor: "WhiteCamel",
            textColor: .white,
            accentColor: .darkBlue
        ),
        CardTheme(
            id: 1,
            name: "الوطني السعودي",
            backgroundImage: "SaudiCard",
            camelColor: "WhiteCamel",
            textColor: .white,
            accentColor: .darkGreen
        ),
        CardTheme(
            id: 2,
            name: "الوردي اللامع",
            backgroundImage: "PingGlitterCard",
            camelColor: "WhiteCamel",
            textColor: .white,
            accentColor: .redApp
        ),
        CardTheme(
            id: 3,
            name: "الماتشا",
            backgroundImage: "MatchaCard",
            camelColor: "GreenCamel",
            textColor: .darkGreen,
            accentColor: .darkGreen
        ),
    ]
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "يتبع النظام"
        case .light: return "فاتح"
        case .dark: return "داكن"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
