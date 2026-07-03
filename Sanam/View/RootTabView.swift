//
//  RootTabView.swift
//  Sanam
//

import SwiftUI

// MARK: - Tab Items

enum TabItem: Int, CaseIterable {
    case simulator = 0
    case journey
    case portfolio

    var title: String {
        switch self {
        case .simulator: return "المحاكي"
        case .journey: return "رحلتك"
        case .portfolio: return "المحفظة"
        }
    }

    var icon: String {
        switch self {
        case .simulator: return "chart.line.uptrend.xyaxis"
        case .journey: return "flag.checkered"
        case .portfolio: return "creditcard"
        }
    }
}

// MARK: - Custom Tab Bar

struct RootTabView: View {
    @AppStorage("selectedTab") private var selectedTab: Int = 2

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("backFrame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )

                TabView(selection: Binding(
                    get: { TabItem(rawValue: selectedTab) ?? .portfolio },
                    set: { selectedTab = $0.rawValue }
                )) {

                    SimulatorView()
                        .tabItem {
                            Image(systemName: TabItem.simulator.icon)
                            Text(TabItem.simulator.title)
                        }
                        .tag(TabItem.simulator)

                    LevelsView()
                        .tabItem {
                            Image(systemName: TabItem.journey.icon)
                            Text(TabItem.journey.title)
                        }
                        .tag(TabItem.journey)

                    MainView()
                        .tabItem {
                            Image(systemName: TabItem.portfolio.icon)
                            Text(TabItem.portfolio.title)
                        }
                        .tag(TabItem.portfolio)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(SimulatorViewModel())
        .environmentObject(WalletViewModel())
}
