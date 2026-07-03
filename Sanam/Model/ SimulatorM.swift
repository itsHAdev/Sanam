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
    let statistics: Statistics

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case trend
        case changePercent = "change_percent"
        case statistics
    }
}

struct Statistics: Codable {
    let previousClose: Double
    let openPrice: Double
    let dayHigh: Double
    let dayLow: Double
    let volumeTraded: Int
    let tradingValue: Double
    let numberOfTrades: Int
    let averageTradeSize: Int

    enum CodingKeys: String, CodingKey {
        case previousClose = "previous_close"
        case openPrice = "open_price"
        case dayHigh = "day_high"
        case dayLow = "day_low"
        case volumeTraded = "volume_traded"
        case tradingValue = "trading_value"
        case numberOfTrades = "number_of_trades"
        case averageTradeSize = "average_trade_size"
    }
}

