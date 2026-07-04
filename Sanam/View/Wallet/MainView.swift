//
//  MainView.swift
//  Sanam
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var walletVM: WalletViewModel
    @EnvironmentObject var simulatorVM: SimulatorViewModel

    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
               Background()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        headerBar
                        walletCardSection
                            .padding(.top, 20)
                        stocksSection
                            .padding(.top, 28)
                        Spacer().frame(height: 100)
                    }
                }

                if walletVM.showWalletSavedToast {
                    walletSavedToast
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 8)
                }
            }
            .navigationBarHidden(true)
            .environment(\.layoutDirection, .leftToRight)
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(walletVM)
            }
            .onChange(of: walletVM.showWalletSavedToast) { _, isShown in
                if isShown {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            walletVM.showWalletSavedToast = false
                        }
                    }
                }
            }
            .onChange(of: walletVM.requestDismissToMain) { _, shouldDismiss in
                if shouldDismiss {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSettings = false
                    }
                    DispatchQueue.main.async {
                        walletVM.requestDismissToMain = false
                    }
                }
            }
        }
    }

    private var headerBar: some View {
        HStack(alignment: .center) {
            Button(action: { showSettings = true }) {
                ZStack {
                    Color.clear
                        .cornerRadius(1000)
                        .shadow(color: .black.opacity(0.1), radius: 1)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                        .frame(width: 44, height: 44)
                        .glassEffect()

                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.textApp)
                }
            }

            Spacer()

            Text("محفظتك")
                .font(.system(size: 36, weight: .black))
                .fontWeight(.bold)
                .foregroundColor(.textApp)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    private var walletCardSection: some View {
        WalletCardView(
            theme: walletVM.selectedTheme,
            holderName: walletVM.holderName
        )
        .frame(height: 180)
        .padding(.horizontal, 24)
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: walletVM.selectedThemeID)
        .animation(.easeInOut(duration: 0.25), value: walletVM.holderName)
    }

    private var stocksSection: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("أسهمك")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textApp)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            Rectangle()
                .fill(Color.grayApp.opacity(0.12))
                .frame(height: 1)
                .padding(.horizontal, 24)

            if simulatorVM.ownedCompanies.isEmpty {
                Text("ما عندك أسهم بعد، اشتري من المحاكي!")
                    .font(.system(size: 14))
                    .foregroundColor(.grayApp)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                VStack(spacing: 0) {
                    ForEach(simulatorVM.ownedCompanies) { company in
                        CompanyRowView(
                            company: company,
                            shares: simulatorVM.ownedShares[company.id, default: 0]
                        )

                        if company.id != simulatorVM.ownedCompanies.last?.id {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 1)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
    }

    private var walletSavedToast: some View {
        ZStack {
            Rectangle()
                .frame(width: 359, height: 59)
                .cornerRadius(12)
                .foregroundStyle(.grayApp.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.primary.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)

            HStack(spacing: 10) {
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        walletVM.showWalletSavedToast = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textApp)
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 28, height: 28)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Circle())
                }

                Spacer(minLength: 10)

                Text("اعتمدنا الشكل الجديد!!!")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textApp)

                ZStack {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.greenApp.opacity(0.3))

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.greenApp)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
        }
    }
}

struct CompanyRowView: View {
    let company: Company
    let shares: Int

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(arabicNumerals(String(Int(company.stock.currentPrice))))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.textApp)
                Text("\(arabicNumerals(String(shares))) أسهم")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.grayApp)
            }
            .frame(width: 70, alignment: .leading)

            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text(company.fakeName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.textApp)
                    Text(company.sector)
                        .font(.system(size: 12))
                        .foregroundColor(.grayApp)
                }

                Text(company.imageName)
                    .font(.system(size: 24))
                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }
}

#Preview {
    MainView()
        .environmentObject(WalletViewModel())
        .environmentObject(SimulatorViewModel())
}
