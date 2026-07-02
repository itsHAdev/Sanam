//
//  CardTheme.swift
//  Sanam
//
//  Created by Hadeel on 02/07/2026.
//

import SwiftUI

//MARK: - Model
struct CardTheme: Identifiable, Equatable {
    let id: Int
    let name: String
    let background: String // Asset name
    let camel: String
    let textColor: Color
    
}

extension CardTheme {
    static let allThemes: [CardTheme] = [
        CardTheme(id: 0, name: "Default", background: "DefaultCard", camel: "WhiteCamel", textColor: .textApp),
        CardTheme(id: 1, name: "PingGlitter", background: "PingGlitterCard", camel: "WhiteCamel", textColor: .textApp),
        CardTheme(id: 2, name: "Saudi", background: "SaudiCard", camel: "WhiteCamel", textColor: .textApp),
        CardTheme(id: 3, name: "Matcha", background: "MatchaCard", camel: "GreenCamel", textColor: .darkGreen)
    ]
}

struct CardView: View {
    let theme: CardTheme
    let holderName: String
    var isPreview: Bool = false
    
    var body: some View {
        
        ZStack{
            Image(theme.background)
                .resizable()
                .frame(width: 323,height: 170)
            
            
                
                VStack(alignment: .center,spacing: 12){
                    Text("دراهمك الافتراضية")
                        .font(.system(size: 16,weight: .semibold))
                        .foregroundStyle(theme.textColor)
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 4)
                    
                    Text("٠٠.٠٠")
                        .font(.system(size: 40,weight: .black))
                        .foregroundStyle(theme.textColor)
                        .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 4)
                    
                }//v
             
                HStack(alignment: .bottom ,spacing: 1){
                    Text(holderName)
                        .font(.system(size: 12,weight: .bold))
                        .foregroundStyle(theme.textColor)
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 4)
                    
                    Image(theme.camel)
                        .resizable()
                        .frame(width: 27,height: 19)
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 4)
                }//h
                .offset(x:100,y: 50)
                    
        
        }//z
    }
}
#Preview {
    CardView( theme: CardTheme.allThemes[1],
              holderName: "مزنة سنام"
    )
}


