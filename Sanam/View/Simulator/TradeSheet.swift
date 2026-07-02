//
//  TradeSheet.swift
//  Sanam
//
//  Created by Hadeel on 28/06/2026.
//

import SwiftUI

struct TradeSheet: View {
    @State private var isBuy = true
    @State private var quantity = 1
    var body: some View {
        ZStack{
            Background()
            VStack{
                
                
                Text("صفحة التداول")
                    .font(.system(size: 20,weight: .bold))
                    .foregroundStyle(.textApp)
              
                Spacer()
                
                Text("١٢٣.٠٠")
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
                        Text("٢")
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

                            Text("1")
                                .font(.system(size: 22,weight: .medium))
                                .foregroundColor(.white)

                            Button {
                                quantity += 1
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
                    
                }
                
            }//vMain
            .padding()
        }
    }
}

#Preview {
    TradeSheet()
}
