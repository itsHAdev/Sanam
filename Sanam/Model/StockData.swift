//
//  StockData.swift
//  Sanam
//

import Foundation

struct StockData: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
}
