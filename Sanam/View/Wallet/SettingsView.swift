//
//  SettingsView.swift
//  Sanam
//

//  Created by Hadeel on 02/07/2026.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var walletVM: WalletViewModel

    var body: some View {
        ZStack {
            Color(.backApp)
                .ignoresSafeArea()
                .overlay(
                    Image("backFrame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 34) {

                        settingsGroup(
                            title: "المحفظة",
                            items: [
                                SettingsItem(
                                    icon: "paintbrush.fill",
                                    title: "شكل محفظتك",
                                    destination: AnyView(
                                        WalletAppearanceView(walletVM: walletVM)
                                            .environmentObject(walletVM)
                                    )
                                )
                            ]
                        )

                        generalGroup

                        Spacer().frame(height: 60)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 26)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .navigationTitle("الإعدادات")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var generalGroup: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("إعدادات عامة")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.textApp)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                appearanceRow

                Rectangle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(height: 1)
                    .padding(.leading, 18)

                NavigationLink {
                    PrivacySecurityView()
                        .environmentObject(walletVM)
                } label: {
                    HStack(spacing: 8) {
                        Spacer()

                        Text("الخصوصية والأمان")
                            .font(.system(size: 16))
                            .foregroundColor(.textApp)

                        Image(systemName: "shield.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.textApp)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.secondary.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.primary.opacity(0.25), lineWidth: 1.0)
                    )
            )
        }
    }

    private var appearanceRow: some View {
        HStack(spacing: 8) {
            Spacer()

            Menu {
                ForEach(AppAppearance.allCases) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            walletVM.appAppearance = option
                        }
                    } label: {
                        HStack {
                            if walletVM.appAppearance == option {
                                Image(systemName: "checkmark")
                            }
                            Text(option.title)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text("(\(walletVM.appAppearance.title))")
                        .font(.system(size: 16))
                        .foregroundColor(.grayApp)
                    
                    Text("نمط الظهور")
                        .font(.system(size: 16))
                        .foregroundColor(.textApp)
                  
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Image(systemName: "sun.max.fill")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.textApp)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func settingsGroup(title: String, items: [SettingsItem]) -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.textApp)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    NavigationLink(destination: items[index].destination) {
                        settingsRow(item: items[index])
                    }
                    .buttonStyle(PlainButtonStyle())

                    if index < items.count - 1 {
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                            .frame(height: 1)
                            .padding(.leading, 18)
                    }
                }
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.secondary.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.primary.opacity(0.25), lineWidth: 1.0)
                    )
            )
        }
    }

    @ViewBuilder
    private func settingsRow(item: SettingsItem) -> some View {
        HStack(spacing: 8) {
            Spacer()

            Text(item.title)
                .font(.system(size: 16))
                .foregroundColor(.textApp)

            Image(systemName: item.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.textApp)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let destination: AnyView
}

struct PrivacySecurityView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var walletVM: WalletViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("backFrame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 28) {
                        VStack(alignment: .trailing, spacing: 16) {
                            Text("سياسة الخصوصية والأمان")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.textApp)
                                .multilineTextAlignment(.trailing)

                            Text("نحن نهتم بأن خصوصيتك هي داخل اهتمامنا. لقد صممنا هذه التجربة التصميمة لكي تكون مساحة خالية من التتبع، حيث نحترم بياناتك ونحافظ على أمانها. توضح هذه السياسة كيف نتعامل مع بياناتك داخل التطبيق بشكل مبسط.")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.textApp)
                                .multilineTextAlignment(.trailing)
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 26)
                        .padding(.top, 14)

                        VStack(alignment: .trailing, spacing: 26) {
                            numberedSectionRow(
                                number: 1,
                                title: "تطبيق سنام مبني على مبدأ الخصوصية أولاً.",
                                subtitle: "لا نقوم بجمع أي بيانات شخصية حساسة مثل الاسم، عنوان، أو رقم الهاتف. يتم استخدام بيانات استخدام عامة لتحسين التجربة فقط."
                            )
                            numberedSectionRow(
                                number: 2,
                                title: "التحليلات على الجهاز",
                                subtitle: "أغلب التحليلات تتم محلياً على جهازك دون إرسال البيانات لخوادم خارجية. في حال الحاجة، يتم إخفاء هوية البيانات بالكامل."
                            )
                            numberedSectionRow(
                                number: 3,
                                title: "حفظ آمن",
                                subtitle: "تُحفظ معلومات محفظتك محلياً وبشكل مشفر. يمكنك حذفها في أي وقت من الإعدادات."
                            )
                            numberedSectionRow(
                                number: 4,
                                title: "الصلاحيات",
                                subtitle: "لا نطلب صلاحيات غير لازمة. في حال طلب صلاحية، سنوضح سبب الحاجة لها وكيفية استخدامها."
                            )
                        }
                        .padding(.horizontal, 26)

                        Spacer().frame(height: 28)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }

    private func numberedSectionRow(number: Int, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.textApp)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.textApp)
                    .lineSpacing(6)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Text(arabicNumerals(".\(number)"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textApp)
                .padding(.top, 4)
                .frame(minWidth: 28, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(WalletViewModel())
    }
}
