//
//  companyView.swift
//  Sanam
//

import SwiftUI

struct companyView: View {
    @StateObject private var vm: CompanyDetailViewModel
    @State private var showTradeSheet = false
    @State private var showTradeToast = false
    @State private var tradeToastMessage = ""
    @State private var isTradeSuccess = true

    init(company: Company) {
        _vm = StateObject(wrappedValue: CompanyDetailViewModel(company: company))
    }


    var body: some View {
        ZStack {

            //MARK: - Main view

            Background()

            if showTradeToast {
                VStack {
                    HStack(spacing: 14) {
                        Button {
                            showTradeToast = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.textApp)
                                .font(.system(size: 15, weight: .semibold))
                        }

                        Spacer()

                        Text(tradeToastMessage)
                            .foregroundColor(.textApp)
                            .font(.system(size: 13))

                        ZStack {
                            Circle()
                                .fill(isTradeSuccess ? Color.greenApp.opacity(0.19) : Color.redApp.opacity(0.19))
                                .frame(width: 26, height: 26)

                            Image(systemName: isTradeSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isTradeSuccess ? .greenApp : .redApp)
                                .font(.system(size: 18))
                        }
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 59)
                    .background(Color.backApp.opacity(0.95))
                    .cornerRadius(12)
                    .padding(.horizontal, 17)
                    .padding(.top, 50)

                    Spacer()
                }
                .zIndex(999)
            }

            VStack(spacing: 12) {
                headr1(company: vm.company)
                Spacer()
                companyDetails(company: vm.company, changePercent: vm.periodChangePercent)
                picker(selectedPeriod: $vm.selectedPeriod)
                Chart(
                    prices: vm.prices,
                    selectedPeriod: vm.selectedPeriod,
                    xLabels: vm.xLabels
                )
                summary(company: vm.company, periodHigh: vm.periodHigh, periodLow: vm.periodLow)
                Spacer()
                PrimaryButton(title: "تداول"){
                    showTradeSheet = true
                }
                .sheet(isPresented: $showTradeSheet) {
                    TradeSheet(company: vm.company) { message, success in
                        tradeToastMessage = message
                        isTradeSuccess = success
                        showTradeToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showTradeToast = false
                        }
                    }
                    .presentationDetents([.height(650)])
                    .presentationBackground(.black)
                    .presentationDragIndicator(.visible)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//MARK: - Header

struct headr1: View {
    let company: Company
    @EnvironmentObject var walletVM: WalletViewModel
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

                        Text(arabicNumerals(String(Int(walletVM.balance))))
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
    let changePercent: Double

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

                Text(arabicNumerals(changePercent >= 0
                     ? "+\(String(format: "%.2f", changePercent))%"
                     : "\(String(format: "%.2f", changePercent))%"))
                    .font(.system(size: 16))
                    .foregroundStyle(changePercent >= 0 ? .greenApp : .redApp)

                Text(arabicNumerals(String(format: "%.2f", company.stock.currentPrice)))
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

                        Text(arabicNumerals(String(format: "%.0f", maxPrice - step * Double(i))))
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
    let company: Company
    let periodHigh: Double
    let periodLow: Double
    @State private var showInfo = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()

                Button {
                    showInfo = true
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
                .sheet(isPresented: $showInfo) {
                    StatisticsInfoSheet()
                        .presentationDetents([.height(560)])
                        .presentationBackground(.black)
                        .presentationDragIndicator(.visible)
                }
            }

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "الكمية المتداولة", value: arabicNumerals(compactNumber(Double(company.stock.statistics.volumeTraded))))
                    summaryRow(title: "القيمة المتداولة", value: arabicNumerals(compactNumber(company.stock.statistics.tradingValue)))
                }

                Divider()
                    .frame(height: 80)
                    .background(Color.white.opacity(0.2))

                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "إغلاق سابق", value: arabicNumerals(String(format: "%.2f", company.stock.statistics.previousClose)))
                    summaryRow(title: "عدد الصفقات", value: arabicNumerals(compactNumber(Double(company.stock.statistics.numberOfTrades))))
                    summaryRow(title: "متوسط الصفقة", value: arabicNumerals(compactNumber(Double(company.stock.statistics.averageTradeSize))))
                }

                Divider()
                    .frame(height: 80)
                    .background(Color.white.opacity(0.2))

                VStack(alignment: .trailing, spacing: 16) {
                    summaryRow(title: "افتتاح", value: arabicNumerals(String(format: "%.2f", company.stock.statistics.openPrice)))
                    summaryRow(title: "الأعلى", value: arabicNumerals(String(format: "%.2f", periodHigh)))
                    summaryRow(title: "الأدنى", value: arabicNumerals(String(format: "%.2f", periodLow)))
                }
            }
        }
        .padding()
    }
}

//MARK: - StatisticsInfoSheet

private struct StatisticsInfoSheet: View {
    var body: some View {
        ZStack {
            Background()

            VStack(spacing: 24) {
                Text("معلومات")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textApp)
                    .padding(.top, 20)

                ScrollView {
                    VStack(alignment: .trailing, spacing: 22) {
                        infoRow(term: "إغلاق سابق", definition: "آخر سعر بيع به السهم بنهاية يوم التداول الأمس.")
                        infoRow(term: "افتتاح", definition: "أول سعر بدأ به السهم قيمته مع بداية تداول اليوم.")
                        infoRow(term: "الأعلى", definition: "أعلى قيمة سعرية وصل إليها السهم خلال جلسة اليوم.")
                        infoRow(term: "الأدنى", definition: "أقل قيمة سعرية هبط إليها السهم خلال جلسة اليوم.")
                        infoRow(term: "عدد الصفقات", definition: "مجموع عمليات البيع والشراء الناجحة التي تمت اليوم.")
                        infoRow(term: "متوسط الصفقة", definition: "معدل قيمة الصفقة الواحدة من إجمالي التداول اليوم.")
                        infoRow(term: "الكمية المتداولة", definition: "إجمالي عدد الأسهم التي تم تداولها بين البائعين والمشترين اليوم.")
                        infoRow(term: "القيمة المتداولة", definition: "مجموع المبالغ المالية والكاش التي دفعت في كل صفقات اليوم.")
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

private func infoRow(term: String, definition: String) -> some View {
    (
        Text("• \(term): ")
            .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
            .fontWeight(.semibold)
        +
        Text(definition)
            .foregroundColor(.textApp)
    )
    .font(.system(size: 16))
    .multilineTextAlignment(.trailing)
    .frame(maxWidth: .infinity, alignment: .trailing)
}

func arabicNumerals(_ text: String) -> String {
    let arabic = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
    return text.map { c in
        if let digit = c.wholeNumberValue {
            return arabic[digit]
        }
        return String(c)
    }.joined()
}

private func compactNumber(_ value: Double) -> String {
    switch abs(value) {
    case 1_000_000_000...:
        return String(format: "%.0fمليار", value / 1_000_000_000)
    case 1_000_000...:
        return String(format: "%.0fم", value / 1_000_000)
    case 1_000...:
        return String(format: "%.0fك", value / 1_000)
    default:
        return String(format: "%.0f", value)
    }
}

private func summaryRow(title: String, value: String) -> some View {
    HStack {
        Text(value)
            .font(.system(size: 10, weight: .regular))
            .foregroundColor(.white.opacity(0.9))
            .lineLimit(1)
            .frame(width: 40, alignment: .leading)

        Spacer()

        Text(title)
            .font(.system(size: 10, weight: .regular))
            .frame(width: 60, alignment: .trailing)
            .foregroundColor(.gray)
    }
}

#Preview {
    companyView(
        company: Company(
            id: 1,
            fakeName: "بيرن اكس",
            imageName: "🔮",
            sector: "قطاع التقنية",
            stock: Stock(
                currentPrice: 124.00,
                trend: "up",
                changePercent: 2.10,
                statistics: Statistics(
                    previousClose: 121.45,
                    openPrice: 118.0,
                    dayHigh: 124.0,
                    dayLow: 118.0,
                    volumeTraded: 2300000,
                    tradingValue: 285200000,
                    numberOfTrades: 23302,
                    averageTradeSize: 12240
                )
            ),
            chartData: ChartData(
                timeframes: Timeframes(
                    oneDay: [
                        PricePoint(timestamp: "2026-05-12T09:00:00Z", price: 118.0),
                        PricePoint(timestamp: "2026-05-12T11:00:00Z", price: 121.5),
                        PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)
                    ],
                    oneWeek: [
                        PricePoint(timestamp: "2026-05-06T14:00:00Z", price: 115.0),
                        PricePoint(timestamp: "2026-05-09T14:00:00Z", price: 117.5),
                        PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)
                    ],
                    oneMonth: [
                        PricePoint(timestamp: "2026-04-13T14:00:00Z", price: 108.0),
                        PricePoint(timestamp: "2026-04-29T14:00:00Z", price: 114.3),
                        PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)
                    ],
                    oneYear: [
                        PricePoint(timestamp: "2025-05-12T14:00:00Z", price: 88.0),
                        PricePoint(timestamp: "2026-01-12T14:00:00Z", price: 112.0),
                        PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)
                    ]
                )
            )
        )
    )
    .environmentObject(SimulatorViewModel())
    .environmentObject(WalletViewModel())
}
