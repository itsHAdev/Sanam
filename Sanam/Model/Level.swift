//
//  Level.swift
//  Sanam
//

import SwiftUI

enum LevelState {
    case completed
    case active
    case locked
}

enum LevelID: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5

    var id: Int { rawValue }
}

struct Level {
    let id: LevelID
    let label: String
    let title: String
    let description: String
    let badge: String
}

extension Level {
    static let all: [Level] = [
        Level(id: .one, label: "المستوى الأول", title: "مستكشف الأسهم", description: "بنعلمك أساسيات الاستثمار في الأسهم", badge: "مستكشف"),
        Level(id: .two, label: "المستوى الثاني", title: "فاهم اللعبه", description: "بنعلمك كيف تحلل السوق و تتخذ قراراتك الاولى", badge: "جامد"),
        Level(id: .three, label: "المستوى الثالث", title: "أسطورة الأسهم", description: "استثمر بذكاء وتعلم شلون تختار السهم الصح", badge: "أسطوري"),
        Level(id: .four, label: "المستوى الرابع", title: "هامور الأسهم", description: "بنعلمك استراتيجيات متقدمة للمحترفين", badge: "هامور"),
        Level(id: .five, label: "المستوى الخامس", title: "مايسترو المحافظ", description: "وزع أموالك وتعلم فن إدارة المحافظ", badge: "مايسترو"),
    ]
}

enum LevelLayout {
    static let cardHeight: CGFloat = 118
    static let cardGap: CGFloat = 12
    static let dotSize: CGFloat = 26

    static func dotY(for index: Int) -> CGFloat {
        CGFloat(index) * (cardHeight + cardGap) + cardHeight / 2
    }
}
