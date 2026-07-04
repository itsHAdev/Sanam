//
//  LevelDoneButton.swift
//  Sanam
//

import SwiftUI

struct LevelDoneButton: View {
    let action: () -> Void

    var body: some View {
        PrimaryButton(title: "خلصت", action: action)
            .padding(.horizontal, 16)
            .padding(.bottom, 36)
    }
}
