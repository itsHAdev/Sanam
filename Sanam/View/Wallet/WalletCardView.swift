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
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(arabicNumerals(String(Int(walletVM.balance))))
                    .font(.system(size: isPreview ? 40 : 48, weight: .bold))
                    .shadow(color: Color.black, radius: 4, x: 0, y: 4)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack {
                Spacer()
                HStack(spacing: isPreview ? 2 : 4) {
                    Spacer()
                    Text(holderName)
                        .font(.system(size: isPreview ? 12 : 14, weight: .semibold))
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        .foregroundColor(.white)
                        .padding(.trailing, isPreview ? -7 : -7)

                    Image("WhiteCamel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isPreview ? 24 : 32, height: isPreview ? 24 : 32)
                }
                .padding(.trailing, isPreview ? 12 : 16)
                .padding(.bottom, isPreview ? 12 : 16)
            }
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
                            .fill(Color.darkBlue)
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
        theme: CardTheme.allThemes[0],
        holderName: "مستخدم سنام"
    )
    .environmentObject(WalletViewModel())
}
