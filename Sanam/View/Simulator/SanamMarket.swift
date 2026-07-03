//
//  SanamMarket.swift
//  Sanam
//
//  Created by Hadeel on 28/06/2026.
//

import SwiftUI

struct SanamMarket: View {
    let amounts = ["١٠٠", "٥٠٠", "١١٠٠", "٢٥٠٠"]
    var body: some View {
        
        ZStack{
            Background()
            
            VStack(spacing: 32){
            
                Header2(title: "سوق سنام")
    
                //MARK: - shareRectangle
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.backApp).opacity(0.6)
                        .frame(width: .infinity, height: 85)
                        .glassEffect(in: .rect(cornerRadius: 20))
                    
                    HStack{
                        
                        ShareLink(
                            item: URL(string: "https://apps.apple.com/app/id1234567890")!
                        ) {
                            ZStack {

                                Circle()
                                    .fill(.darkBlue)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .black.opacity(0.1), radius: 1)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.textApp)
                            }//z
                        }//b
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            Text("شارك سنام مع ربعك وبتربح ١٠٠ ")
                                .font(.system(size: 18,weight: .semibold))
                                .foregroundStyle(.textApp)
                            +
                            Text("سنام")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                            
                            Text("في محفظتك")
                                .font(.system(size: 18,weight: .semibold))
                                .foregroundStyle(.textApp)
                            
                        }//v
                    }//h
                    .padding()
                }//z
                
                
                    //MARK: - CoinsSection
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 32) {

                    ForEach(packages) { package in
                        CoinCard(package: package)
                    }
                }
              Spacer()
            }//vMain
            .padding()
        }//z
    }
}

struct CoinCard: View {
    let package: CoinPackage

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.backApp.opacity(0.6))
                .frame(width: 157, height: 210)
                .glassEffect(in: .rect(cornerRadius: 20))

            VStack(spacing: 32) {
                Text(package.amount)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.textApp)
                +
                Text(" سنام")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)

                Image("coins")
                    .resizable()
                    .frame(width: 76, height: 76)

                SmallButton(title: package.buttonTitle) {
                   
                }//b
            }//v
        }//z
    }
}

struct CoinPackage: Identifiable {
    let id = UUID()
    let amount: String
    let buttonTitle: String
}

let packages = [
    CoinPackage(amount: "١٠٠", buttonTitle: "إعلان"),
    CoinPackage(amount: "٢٥٠", buttonTitle: "٥ ريال"),
    CoinPackage(amount: "٥٠٠", buttonTitle: "٩ ريال"),
    CoinPackage(amount: "١٠٠٠", buttonTitle: "١٥ ريال")
]

#Preview {
    SanamMarket()
}
