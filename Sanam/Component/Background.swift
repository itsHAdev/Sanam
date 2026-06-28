//
//  Background.swift
//  Sanam
//
//  Created by Hadeel on 28/06/2026.
//

import SwiftUI

struct Background: View {
    var body: some View {
        
        Color.backApp
            .ignoresSafeArea()
            .overlay(
                Image("backFrame")
                    .resizable()
                    .opacity(0.7)
                    .ignoresSafeArea())
    }
}
