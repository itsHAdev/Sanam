//
//  RumorGameViewModel.swift
//  Sanam
//

import SwiftUI
import Combine

final class RumorGameViewModel: ObservableObject {
    let rumor = RumorModel()

    @Published var showSuccess = false
    @Published var showFailure = false
    @Published var showRumorPopup = true
    @Published var isStockUp: Bool = Bool.random()
    @Published var userChoseUp: Bool = true

    func newRound() {
        isStockUp = Bool.random()
    }

    func choose(up: Bool) {
        userChoseUp = up
        if up == isStockUp {
            showSuccess = true
        } else {
            showFailure = true
        }
    }

    func retry() {
        showFailure = false
        newRound()
    }

    func dismissRumorPopup() {
        showRumorPopup = false
    }
}
