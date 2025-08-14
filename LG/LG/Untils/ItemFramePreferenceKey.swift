//
//  ItemFramePreferenceKey.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//
import SwiftUI

struct ItemFramePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}
struct ItemPositionView: View {
    let index: Int

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ItemFramePreferenceKey.self, value: [index: geo.frame(in: .global).midX])
        }
    }
}
