//
//  PortfolioSector.swift
//  Sanam
//

import Foundation

struct PortfolioSector: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
    var allocation: Int = 0
}
