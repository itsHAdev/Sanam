//
//  RootTabView.swift
//  Sanam
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            SimulatorView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("المحاكي")
                }

            MainView()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("المحفظة")
                }
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(SimulatorViewModel())
        .environmentObject(WalletViewModel())
}
