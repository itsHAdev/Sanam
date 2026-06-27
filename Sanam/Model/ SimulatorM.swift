//
//   SimulatorM.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import Foundation

struct MarketResponse: Codable {
    let companies: [Company]
}

struct Company: Codable, Identifiable {
    let id: Int
    let fakeName: String
    let imageName: String
    let sector: String
    let stock: Stock

    enum CodingKeys: String, CodingKey {
        case id = "company_id"
        case fakeName = "fake_name"
        case imageName = "image_name"
        case sector
        case stock
    }
}

struct Stock: Codable {
    let currentPrice: Double
    let trend: String
    let changePercent: Double

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case trend
        case changePercent = "change_percent"
    }
}

