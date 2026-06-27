//
//   SimulatorVM.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import Foundation
import Combine

class SimulatorViewModel: ObservableObject {

    @Published var companies: [Company] = []
    @Published var filteredCompanies: [Company] = []
    @Published var selectedSector = "الكل"

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
            return [118, 119.2, 121.5, 120.3, 122.8, 124]
        case "شهر":
            return [110, 114, 116, 121, 119, 124]
        case "سنه":
            return [94, 101, 108, 112, 117, 124]
        default:
            return [118, 119.2, 121.5, 120.3, 122.8, 124]
        }
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
