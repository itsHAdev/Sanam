//
//  LevelsView.swift
//  Sanam
//

import SwiftUI

// MARK: - Main View

struct LevelsView: View {
    @StateObject private var vm = LevelsViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing, spacing: 0) {

                VStack(alignment: .trailing, spacing: 21) {
                    Text("مراحلك")
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("كمل كل المراحل وتقدم في رحلة تعلمك")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.levelTextMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 24)
                .padding(.top, 24)
                .padding(.bottom, 20)

                LevelsListView(vm: vm)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 40)
            }
        }
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("backFrame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
        )
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Levels List

struct LevelsListView: View {
    @ObservedObject var vm: LevelsViewModel

    var totalHeight: CGFloat {
        CGFloat(vm.levels.count) * LevelLayout.cardHeight + CGFloat(vm.levels.count - 1) * LevelLayout.cardGap
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            // ── الكروت ──
            VStack(spacing: LevelLayout.cardGap) {
                ForEach(vm.levels, id: \.id) { level in
                    let state = vm.state(for: level.id)
                    if state == .locked {
                        LevelCardView(level: level, state: state)
                    } else {
                        NavigationLink(destination: destinationView(for: level.id)) {
                            LevelCardView(level: level, state: state)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, LevelLayout.dotSize + 12)

            // ── اللاين والنقاط ──
            ZStack(alignment: .top) {
                ForEach(0..<vm.levels.count - 1, id: \.self) { index in
                    let topState = vm.state(for: vm.levels[index].id)
                    let segmentHeight = LevelLayout.dotY(for: index + 1) - LevelLayout.dotY(for: index) - LevelLayout.dotSize
                    let yOffset = LevelLayout.dotY(for: index) - LevelLayout.dotY(for: 0) + LevelLayout.dotSize / 2

                    if topState == .completed {
                        Rectangle()
                            .fill(Color.levelAccent)
                            .frame(width: 2, height: segmentHeight)
                            .offset(x: LevelLayout.dotSize / 2 - 12, y: yOffset)

                    } else if topState == .active {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color.levelAccent, location: 0.0),
                                        .init(color: Color.levelGradientMid, location: 0.7),
                                        .init(color: Color.levelLockedLine, location: 1.0),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 2, height: segmentHeight)
                            .offset(x: LevelLayout.dotSize / 2 - 12, y: yOffset)

                    } else {
                        Rectangle()
                            .fill(Color.levelLockedLine.opacity(0.4))
                            .frame(width: 2, height: segmentHeight)
                            .offset(x: LevelLayout.dotSize / 2 - 12, y: yOffset)
                    }
                }

                ForEach(Array(vm.levels.enumerated()), id: \.element.id) { index, level in
                    ProgressDotView(state: vm.state(for: level.id))
                        .offset(y: LevelLayout.dotY(for: index) - LevelLayout.dotSize / 2 - LevelLayout.dotY(for: 0))
                }
            }
            .offset(y: 130)
            .frame(width: LevelLayout.dotSize - 20, height: totalHeight, alignment: .top)
        }
    }

    @ViewBuilder
    func destinationView(for id: Int) -> some View {
        if id == 1 {
            ContentView(levelsVM: vm)
        } else {
            LevelComingSoonView(level: vm.levels.first(where: { $0.id == id }))
        }
    }
}

// MARK: - Placeholder destination
// النظام الأصلي بمشروع Snam- يربط كل مستوى بشاشة لعبة مستقلة
// (ContentView / InvestmentLevelView / RumorGameView / StockTypeLevelView / PortfolioRootView)
// ما كانت مطلوبة بهذا التعديل، فمؤقتًا كل مستوى يفتح شاشة بسيطة بدلها.

struct LevelComingSoonView: View {
    let level: Level?

    var body: some View {
        VStack(spacing: 12) {
            Text(level?.title ?? "")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)

            Text("هذا المستوى قيد التطوير")
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

// MARK: - Progress Dot

struct ProgressDotView: View {
    let state: LevelState

    var body: some View {
        ZStack {
            switch state {

            case .locked:
                Circle()
                    .fill(Color.levelDotBackground)
                    .frame(width: 26, height: 26)
                    .overlay(Circle().stroke(Color.levelLockedDotStroke, lineWidth: 1))
                Image(systemName: "lock.fill")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.levelLockIcon)

            case .active:
                Circle()
                    .fill(Color.levelDotBackground)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(Color.levelAccent, lineWidth: 2)
                    )

            case .completed:
                Circle()
                    .stroke(Color.levelAccent, lineWidth: 1)
                    .frame(width: 26, height: 26)
                Circle()
                    .fill(Color.levelAccent)
                    .frame(width: 21.27, height: 21.27)
                Image(systemName: "checkmark")
                    .font(.system(size: 10.76, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 26, height: 26)
    }
}

// MARK: - Level Card

struct LevelCardView: View {
    let level: Level
    let state: LevelState

    var body: some View {
        HStack(spacing: 8) {

            ShieldWithDiamond(badge: level.badge)

            Spacer()

            VStack(alignment: .leading, spacing: 6) {

                Text(level.label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.levelTextMuted)

                Text(level.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(state == .locked ? Color.levelLockedTitle.opacity(0.53) : Color.levelCardTitleActive)

                Text(level.description)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(Color.levelTextMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(width: 316, height: 118)
        .background(cardBackground)
        .cornerRadius(12)
        .opacity(state == .locked ? 0.5 : 1.0)
    }

    @ViewBuilder
    var cardBackground: some View {
        switch state {
        case .active, .completed:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.levelCardBackgroundActive)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color.levelCardBorderStart, Color.levelCardBorderEnd],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)

        case .locked:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.levelCardBackgroundLocked)
        }
    }
}

// MARK: - Shield + Diamond

struct ShieldWithDiamond: View {
    let badge: String

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundStyle(LinearGradient(
                        colors: [Color.levelShieldBase, Color.levelShieldBase],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .scaleEffect(1.04)

                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundColor(Color.levelShieldOverlay.opacity(0.78))

                DiamondView()
                    .offset(x: 0, y: -1)
            }
            .frame(width: 63, height: 74)

            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.levelShieldBase)
                    .frame(width: 35, height: 10)

                Text(badge)
                    .font(.custom("BalooBhai2-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 12)
            }
            .frame(width: 42, height: 12)
            .offset(y: -12)
        }
        .frame(width: 63)
    }
}

struct DiamondView: View {
    var body: some View {
        Image("Badgepdf")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45.83, height: 45.83)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LevelsView()
    }
}
