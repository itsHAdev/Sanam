//
//   SimulatorVM.swift
//  Sanam
//


import Foundation
import Combine

class SimulatorViewModel: ObservableObject {

    @Published var companies: [Company] = []
    @Published var filteredCompanies: [Company] = []
    @Published var selectedSector = "الكل"
    @Published var ownedShares: [Int: Int] = [:]

    let sectors = [
        "الكل",
        "قطاع الطاقة",
        "قطاع البنوك",
        "قطاع الاتصالات",
        "قطاع التقنية",
        "قطاع الأغذية",
        "قطاع مواد البناء",
        "قطاع النقل الجوي",
        "قطاع الرعاية الصحية",
        "قطاع الخدمات اللوجستية"
    ]

    init() {
        loadData()
    }

    func loadData() {
        guard let url = Bundle.main.url(forResource: "MarketData", withExtension: "json") else {
            print("JSON Not Found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(MarketResponse.self, from: data)

            self.companies = result.companies
            self.filteredCompanies = result.companies

        } catch {
            print(error.localizedDescription)
        }
    }

    func filterCompanies() {
        if selectedSector == "الكل" {
            filteredCompanies = companies
        } else {
            filteredCompanies = companies.filter {
                $0.sector == selectedSector
            }
        }
    }

    var ownedCompanies: [Company] {
        companies.filter { (ownedShares[$0.id, default: 0]) > 0 }
    }

    @discardableResult
    func buyStock(company: Company, quantity: Int, wallet: WalletViewModel) -> Bool {
        let cost = company.stock.currentPrice * Double(quantity)
        guard wallet.balance >= cost else { return false }
        wallet.balance -= cost
        ownedShares[company.id, default: 0] += quantity
        return true
    }

    @discardableResult
    func sellStock(company: Company, quantity: Int, wallet: WalletViewModel) -> Bool {
        guard ownedShares[company.id, default: 0] >= quantity else { return false }
        ownedShares[company.id, default: 0] -= quantity
        wallet.balance += company.stock.currentPrice * Double(quantity)
        return true
    }
}

class CompanyDetailViewModel: ObservableObject {
    let company: Company

    @Published var selectedPeriod = "يوم"

    init(company: Company) {
        self.company = company
    }

    var prices: [Double] {
        switch selectedPeriod {
        case "اسبوع":
            return company.chartData.timeframes.oneWeek.map { $0.price }
        case "شهر":
            return company.chartData.timeframes.oneMonth.map { $0.price }
        case "سنه":
            return company.chartData.timeframes.oneYear.map { $0.price }
        default:
            return company.chartData.timeframes.oneDay.map { $0.price }
        }
    }

    var periodChangePercent: Double {
        let baseline = selectedPeriod == "يوم"
            ? company.stock.statistics.previousClose
            : prices.first ?? company.stock.currentPrice
        guard baseline != 0 else { return 0 }
        return (company.stock.currentPrice - baseline) / baseline * 100
    }

    var periodHigh: Double {
        prices.max() ?? company.stock.statistics.dayHigh
    }

    var periodLow: Double {
        prices.min() ?? company.stock.statistics.dayLow
    }

    var xLabels: [String] {
        switch selectedPeriod {
        case "يوم":
            return ["١١ص", "١٠ص", "٩ص", "٨ص", "٧ص", "٦ص"]
        case "اسبوع":
            return ["جمعة", "خميس", "أربعاء", "ثلاثاء", "اثنين", "سبت"]
        case "شهر":
            return ["الأسبوع٤", "الأسبوع٣", "الأسبوع٢", "الأسبوع١"]
        case "سنه":
            return ["رجب", "جمادى٢", "جمادى١", "ربيع١", "صفر", "محرم"]
        default:
            return []
        }
    }
}
