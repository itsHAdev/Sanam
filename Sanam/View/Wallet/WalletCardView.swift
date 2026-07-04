//
//  WalletCardView.swift
//  Sanam
//

import SwiftUI

struct WalletCardView: View {
    let theme: CardTheme
    let holderName: String
    var isPreview: Bool = false

    @EnvironmentObject var walletVM: WalletViewModel

    var body: some View {
        ZStack {
            Image(theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .clipped()

            VStack(spacing: isPreview ? 4 : 8) {
                Text("دراهمك الافتراضية")
                    .font(.system(size: isPreview ? 14 : 14, weight: .bold))
                    .foregroundColor(theme.textColor)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(arabicNumerals(String(Int(walletVM.balance))))
                    .font(.system(size: isPreview ? 40 : 40, weight: .black))
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .foregroundColor(theme.textColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack {
                Spacer()
                HStack(spacing: isPreview ? 10 : 10) {
                    Spacer()
                    Text(holderName)
                        .font(.system(size: isPreview ? 12 : 12, weight: .semibold))
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        .foregroundColor(theme.textColor)
                        .padding(.trailing, isPreview ? -7 : -7)

                    Image(theme.camelColor)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        .frame(width: isPreview ? 24 : 27, height: isPreview ? 17 : 19)
                }
                .padding(.trailing, isPreview ? 20 : 20)
                .padding(.bottom, isPreview ? 20 : 20)
            }
            
            //plus button to snamMarket
            NavigationLink{
                SanamMarket()
                    .navigationBarBackButtonHidden(true)
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 23,height: 23)
                        .foregroundStyle(.clear)
                        .glassEffect()
                    
                    Image(systemName: "plus")
                        .font(.system(size: 14,weight: .medium))
                        .foregroundStyle(theme.textColor)
                }//z
                
                
            } .offset(x: -40,y: 10)
        }
        .frame(
            width: isPreview ? nil : UIScreen.main.bounds.width - 48,
            height: isPreview ? 172 : 180
        )
        .frame(maxWidth: isPreview ? .infinity : nil)
        .clipShape(RoundedRectangle(cornerRadius: isPreview ? 16 : 20, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: isPreview ? 8 : 14, x: 0, y: 6)
    }
}

struct ThemeOptionRow: View {
    let theme: CardTheme
    let holderName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                WalletCardView(
                    theme: theme,
                    holderName: holderName,
                    isPreview: true
                )
                .frame(height: 172)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                .frame(maxWidth: .infinity, alignment: .center)

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.lightBlue)
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)

                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 16, y: -16)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 6)
    }
}

#Preview {
    WalletCardView(
        theme: CardTheme.allThemes[3],
        holderName: "مستخدم سنام"
    )
    .environmentObject(WalletViewModel())
}
