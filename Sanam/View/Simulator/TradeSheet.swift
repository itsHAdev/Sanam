//
//  TradeSheet.swift
//  Sanam
//
//  Created by Hadeel on 28/06/2026.
//

import SwiftUI

struct TradeSheet: View {
    let company: Company
    var onResult: (String, Bool) -> Void = { _, _ in }

    @EnvironmentObject var simulatorVM: SimulatorViewModel
    @EnvironmentObject var walletVM: WalletViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isBuy = true
    @State private var quantity = 1

    private var ownedShares: Int {
        simulatorVM.ownedShares[company.id, default: 0]
    }

    var body: some View {
        ZStack{
            Background()
            VStack{


                Text("صفحة التداول")
                    .font(.system(size: 20,weight: .bold))
                    .foregroundStyle(.textApp)

                Spacer()

                Text(arabicNumerals(String(format: "%.2f", company.stock.currentPrice * Double(quantity))))
                    .font(.system(size: 55,weight: .semibold))
                    .foregroundStyle(.textApp)
                +
                Text(" سنام")
                    .font(.system(size: 18,weight: .light))
                    .foregroundStyle(.gray)

                Spacer()
                
                HStack{
                    VStack(alignment: .leading, spacing: 40) {
                        //1
                        Text(arabicNumerals("\(ownedShares)"))
                            .font(.system(size: 16))
                            .foregroundStyle(.textApp)
                        +

                        Text(" من الاسهم")
                            .font(.system(size: 16))
                            .foregroundStyle(.textApp)
                        //2
                        HStack(spacing: 8) {
                            
                            Button {
                                isBuy = false
                                if quantity > ownedShares {
                                    quantity = max(ownedShares, 1)
                                }
                            } label: {
                                Text("بيع")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textApp)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                            
                            Button {
                                isBuy = true
                            } label: {
                                Text("شراء")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textApp)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                        }
                        .frame(width: 110, height: 34)
                        .padding(.horizontal,6)
                        .background(
                            ZStack {
                                //mainBackground
                                RoundedRectangle(cornerRadius: 90000)
                                    .fill(Color.backApp)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.1)
                                  
                                
                                //highlight
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: geo.size.width / 2)
                                        .offset(x: isBuy ? geo.size.width / 2 : 0)
                                        .animation(.easeInOut(duration: 0.2), value: isBuy)
                                }.glassEffect()
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        HStack(spacing: 20) {

                            Button {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            Text(arabicNumerals("\(quantity)"))
                                .font(.system(size: 22,weight: .medium))
                                .foregroundColor(.white)

                            Button {
                                if isBuy || quantity < ownedShares {
                                    quantity += 1
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }.padding(.horizontal,16)
                        .background(
                            Color.gray.opacity(0.2)
                                .frame(width: 112,height: 44)
                                .cornerRadius(100)
                        )
                        
                    }//v
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 40) {
                        
                        Text("عدد الأسهم بمحفظتك")
                        
                        Text("العملية اللي ودك تسويها")
                        
                        Text("العدد")
                    }
                    .foregroundColor(.textApp)
                    .font(.system(size: 18,weight: .medium))
                
                }//h
                
                Spacer()
                
                PrimaryButton(title: isBuy ? "اشتر" : "بع"){
                    if isBuy {
                        if simulatorVM.buyStock(company: company, quantity: quantity, wallet: walletVM) {
                            onResult("تم شراء السهم بنجاح", true)
                        } else {
                            onResult("رصيدك غير كافٍ", false)
                        }
                    } else {
                        if simulatorVM.sellStock(company: company, quantity: quantity, wallet: walletVM) {
                            onResult("تم بيع السهم بنجاح", true)
                        } else {
                            onResult("ما عندك أسهم كافية للبيع", false)
                        }
                    }
                    dismiss()
                }
                
            }//vMain
            .padding()
        }
    }
}

#Preview {
    TradeSheet(
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
                    oneDay: [PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)],
                    oneWeek: [PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)],
                    oneMonth: [PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)],
                    oneYear: [PricePoint(timestamp: "2026-05-12T14:00:00Z", price: 124.0)]
                )
            )
        )
    )
    .environmentObject(SimulatorViewModel())
    .environmentObject(WalletViewModel())
}
