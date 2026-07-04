//
//  WalletAppearanceView.swift
//  Sanam
//

import SwiftUI

struct WalletAppearanceView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var walletVM: WalletViewModel

    @State private var draftName: String = ""
    @State private var draftThemeID: Int = 0
    @FocusState private var isNameFocused: Bool

    @State private var showUnsavedAlert: Bool = false

    private var hasChanges: Bool {
        draftName != walletVM.holderName || draftThemeID != walletVM.selectedThemeID
    }

    private var previewTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == draftThemeID }) ?? CardTheme.allThemes[0]
    }

    var body: some View {
        ZStack {
            Background()

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        currentWalletSection
                        nameSection
                        themeSelectorSection
                        Spacer().frame(height: 100)
                    }
                }
            }
        }
        .navigationTitle("شكل محفظتك")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if hasChanges {
                    Button {
                        saveChangesAndClose()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            draftName = walletVM.holderName
            draftThemeID = walletVM.selectedThemeID
        }
        .alert("تبي تطلع بدون حفظ؟", isPresented: $showUnsavedAlert) {
            Button("تراجع", role: .cancel) {}
            Button("اطلع", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("التعديلات اللي سويتها على المحفظة ما انحفظت، متأكد تبي تطلع؟")
        }
    }

    private func saveChanges() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            walletVM.holderName = draftName.isEmpty ? walletVM.holderName : draftName
            walletVM.selectedThemeID = draftThemeID
        }
        isNameFocused = false
    }

    private func saveChangesAndClose() {
        saveChanges()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            walletVM.showWalletSavedToast = true
        }
        walletVM.requestDismissToMain = true
    }

    private var currentWalletSection: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Text("محفظتك الحاليه")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            WalletCardView(
                theme: previewTheme,
                holderName: draftName.isEmpty ? " " : draftName
            )
            .padding(.horizontal, 24)
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: draftThemeID)
            .animation(.easeInOut(duration: 0.2), value: draftName)
        }
    }

    private var nameSection: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("اسمك")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 12)

            TextField("", text: $draftName)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isNameFocused
                                    ? LinearGradient(
                                        colors: [Color.primary.opacity(0.35), Color.primary.opacity(0.15)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing)
                                    : LinearGradient(
                                        colors: [Color.primary.opacity(0.20), Color.primary.opacity(0.08)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 1.0
                                )
                        )
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                )
                .focused($isNameFocused)
                .submitLabel(.done)
                .onSubmit { isNameFocused = false }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var themeSelectorSection: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("اختر شكل المحفظة اللي ودك فيه")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            VStack(spacing: 20) {
                ForEach(CardTheme.allThemes) { theme in
                    ThemeOptionRow(
                        theme: theme,
                        holderName: draftName.isEmpty ? " " : draftName,
                        isSelected: theme.id == draftThemeID
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            draftThemeID = theme.id
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    let vm = WalletViewModel()
    NavigationStack {
        WalletAppearanceView(walletVM: vm)
    }
    .environmentObject(vm)
}
