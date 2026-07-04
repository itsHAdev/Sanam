//
//  SanamApp.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import SwiftUI

@main
struct SanamApp: App {
    @StateObject private var simulatorVM = SimulatorViewModel()
    @StateObject private var walletVM = WalletViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(simulatorVM)
                .environmentObject(walletVM)
            NavigationStack {
             
            }
        }
    }
}
