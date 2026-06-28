//
//  companyView.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import SwiftUI

struct companyView: View {
    @StateObject private var vm: CompanyDetailViewModel

    init(company: Company) {
        _vm = StateObject(wrappedValue: CompanyDetailViewModel(company: company))
    }

    var body: some View {
        ZStack {
            
            //MARK: - Main view
            
            Background()

            VStack(spacing: 12) {
                headr1(company: vm.company)
                Spacer()
                companyDetails(company: vm.company)
                picker(selectedPeriod: $vm.selectedPeriod)
                Chart(
                    prices: vm.prices,
                    selectedPeriod: vm.selectedPeriod,
                    xLabels: vm.xLabels
                )
                summary()
               Spacer()
                TadawlButton()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//MARK: - Header

struct headr1: View {
    let company: Company
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            //1
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.clear)

                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.textApp)
                }//z
            }
            .glassEffect()
            
            Spacer()
            
            //2
            Text(company.fakeName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.textApp)

            Spacer()
            
            //3
            NavigationLink {
                SanamMarket()
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: 94, height: 44)
                        .cornerRadius(9000)
                        .foregroundStyle(.clear)

                    HStack(alignment: .center) {
                        Image("coins")
                            .resizable()
                            .frame(width: 30, height: 30)

                        Spacer().frame(width: 12)

                        Text("٠٠.٠٠")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.textApp)
                    }//h
                }//z
            }
            .glassEffect()
        }//hMain
        .padding()
    }
}

//MARK: - CompanyDetails

struct companyDetails: View {
    let company: Company

    var body: some View {
        VStack {
            HStack {
                Spacer()

                VStack(spacing: 2) {
                    Text(company.fakeName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.textApp)

                    Text(company.sector)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }//v

                ZStack {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.gray.opacity(0.2))

                    Text(company.imageName)
                        .font(.system(size: 28))
                }//z
            }//h

            HStack(alignment: .bottom) {
                Spacer()

                Text(company.stock.changePercent >= 0
                     ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                     : "\(String(format: "%.2f", company.stock.changePercent))%")
                    .font(.system(size: 16))
                    .foregroundStyle(company.stock.changePercent >= 0 ? .greenApp : .redApp)

                Text("\(company.stock.currentPrice, specifier: "%.2f")")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.textApp)
            }//h
        }//vMain
        .padding()
    }
}

//MARK: - Picker

struct picker: View {
    let periods = ["سنه", "شهر", "اسبوع", "يوم"]
    @Binding var selectedPeriod: String

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(spacing: 0) {
                ForEach(periods, id: \.self) { item in
                    Button {
                        selectedPeriod = item
                    } label: {
                        Text(item)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textApp)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                }
            }//h
            .frame(width: 370, height: 36)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 900)
                        .fill(Color.clear)
                        .glassEffect()

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.gray.opacity(0.2))
                            .glassEffect()
                            .frame(width: geo.size.width / 4)
                            .offset(
                                x: CGFloat(periods.firstIndex(of: selectedPeriod) ?? 0)
                                * (geo.size.width / 4)
                            )
                            .animation(.easeInOut(duration: 0.2), value: selectedPeriod)
                    }
                    .padding(.vertical, 4)
                }//z
            )
            .clipShape(RoundedRectangle(cornerRadius: 900))
        }//vMain
    }
}

//MARK: - Chart

struct Chart: View {
    let prices: [Double]
    let selectedPeriod: String
    let xLabels: [String]

    var body: some View {
        StockChartContainer(
            prices: prices,
            xLabels: xLabels
        )
        .frame(width: 390, height: 220)
    }
}

private struct GridBackground: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let rows = 4
                let cols = 6

                let rowHeight = geo.size.height / CGFloat(rows)
                let colWidth = geo.size.width / CGFloat(cols)

                for i in 0...rows {
                    let y = CGFloat(i) * rowHeight
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }

                for i in 0...cols {
                    let x = CGFloat(i) * colWidth
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
            }
            .stroke(Color.white.opacity(0.06), lineWidth: 1)
        }
    }
}

private struct SimpleStockChart: View {
    let prices: [Double]

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let maxPrice = prices.max() ?? 1
            let minPrice = prices.min() ?? 0
            let range = max(maxPrice - minPrice, 0.1)

            ZStack {
                GridBackground()

                Path { path in
                    for i in prices.indices {
                        let x = width * CGFloat(i) / CGFloat(max(prices.count - 1, 1))
                        let y = height - CGFloat((prices[i] - minPrice) / range) * height

                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.green, lineWidth: 2)

                Path { path in
                    for i in prices.indices {
                        let x = width * CGFloat(i) / CGFloat(max(prices.count - 1, 1))
                        let y = height - CGFloat((prices[i] - minPrice) / range) * height

                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }

                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.3),
                            Color.green.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

private struct StockChartContainer: View {
    let prices: [Double]
    let xLabels: [String]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                SimpleStockChart(prices: prices)
                    .frame(maxWidth: .infinity)

                VStack {
                    let maxPrice = prices.max() ?? 1
                    let minPrice = prices.min() ?? 0
                    let step = (maxPrice - minPrice) / 3

                    ForEach(0..<4) { i in
                        Spacer()

                        Text(String(format: "%.0f", maxPrice - step * Double(i)))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 35)
            }

            HStack {
                ForEach(xLabels, id: \.self) { label in
                    Text(label)
                        .font(.caption2)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
        }
    }
}

//MARK: - Summary

struct summary: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()

                Button {
                    // showInfo = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 25, height: 25)

                        Text("!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.textApp)
                    }
                    .glassEffect()
                }
            }

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "الكمية المتداولة", value: "...")
                    summaryRow(title: "القيمة المتداولة", value: "...")
                }

                Divider()
                    .frame(height: 80)
                    .background(Color.white.opacity(0.2))

                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "إغلاق سابق", value: "...")
                    summaryRow(title: "عدد الصفقات", value: "...")
                    summaryRow(title: "متوسط الصفقة", value: "...")
                }

                Divider()
                    .frame(height: 80)
                    .background(Color.white.opacity(0.2))

                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "افتتاح", value: "...")
                    summaryRow(title: "الأعلى", value: "...")
                    summaryRow(title: "الأدنى", value: "...")
                }
            }
        }
        .padding()
    }
}

private func summaryRow(title: String, value: String) -> some View {
    HStack {
        Text(value)
            .font(.system(size: 10, weight: .regular))
            .foregroundColor(.white.opacity(0.9))
            .frame(width: 30, alignment: .leading)

        Spacer()

        Text(title)
            .font(.system(size: 10, weight: .regular))
            .frame(width: 70, alignment: .trailing)
            .foregroundColor(.gray)
    }
}

struct TadawlButton: View {
    var body: some View {
        Button {} label: {
            ZStack {
                Rectangle()
                    .frame(width: 300, height: 44)
                    .foregroundStyle(.primaryApp)
                    .cornerRadius(9000)

                Text("تداول")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.textApp)
            }//z
        }
        .glassEffect()
    }
}

#Preview {
    companyView(
        company: Company(
            id: 1,
            fakeName: "بيرن اكس",
            imageName: "🔮",
            sector: "قطاع التقنية",
            stock: Stock(currentPrice: 124.00, trend: "up", changePercent: 2.10)
        )
    )
}
