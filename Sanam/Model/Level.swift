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

struct Level {
    let id: Int
    let label: String
    let title: String
    let description: String
    let badge: String
}

extension Level {
    static let all: [Level] = [
        Level(id: 1, label: "المستوى الأول", title: "مستكشف الأسهم", description: "بنعلمك أساسيات الاستثمار في الأسهم", badge: "مستكشف"),
        Level(id: 2, label: "المستوى الثاني", title: "فاهم اللعبه", description: "بنعلمك كيف تحلل السوق و تتخذ قراراتك الاولى", badge: "جامد"),
        Level(id: 3, label: "المستوى الثالث", title: "أسطورة الأسهم", description: "استثمر بذكاء وتعلم شلون تختار السهم الصح", badge: "أسطوري"),
        Level(id: 4, label: "المستوى الرابع", title: "هامور الأسهم", description: "بنعلمك استراتيجيات متقدمة للمحترفين", badge: "هامور"),
        Level(id: 5, label: "المستوى الخامس", title: "مايسترو المحافظ", description: "وزع أموالك وتعلم فن إدارة المحافظ", badge: "مايسترو"),
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
