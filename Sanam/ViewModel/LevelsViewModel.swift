//
//  LevelsViewModel.swift
//  Sanam
//

import SwiftUI
import Combine

final class LevelsViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    @AppStorage("currentLevel") private var storedLevel: Int = 1

    var currentLevel: Int {
        get { storedLevel }
        set {
            objectWillChange.send()
            storedLevel = newValue
        }
    }

    let levels: [Level] = Level.all

    func state(for id: LevelID) -> LevelState {
        let totalLevels = levels.count

        if id.rawValue < currentLevel { return .completed }
        if id.rawValue == currentLevel && currentLevel > totalLevels { return .completed }
        if id.rawValue == currentLevel { return .active }
        return .locked
    }
}
