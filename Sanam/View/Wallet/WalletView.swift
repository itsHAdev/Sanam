//
//  WalletView.swift
//  Sanam
//
//  Created by Hadeel on 02/07/2026.
//

import SwiftUI

struct WalletView: View {
    var body: some View {
        
        ZStack{
            
            Background()
            
            VStack(spacing: 32){
                
                Headr1(title: "المحفظة", icon: "gear"){}
                
                CardView( theme: CardTheme.allThemes[1],holderName: "مزنة سنام")
                
                yourStocks()
                
                Spacer()
            }//vMain
            .padding()
        }//z
    }
}

struct yourStocks: View {
    var body: some View {
        
        VStack{
           Text("أسهمك")
                .font(.system(size: 22,weight: .semibold))
                .foregroundStyle(.textApp)
            
        }//v
        .frame(maxWidth: .infinity,alignment: .trailing)
    }
}


#Preview {
    WalletView()
}
