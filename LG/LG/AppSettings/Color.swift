//
//  Untitled.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//

import SwiftUI

extension Color {
    static let white5 = Color.white.opacity(0.05)
    static let white10 = Color.white.opacity(0.1)
    static let white15 = Color.white.opacity(0.15)
    static let white20 = Color.white.opacity(0.2)
    static let white40 = Color.white.opacity(0.4)
    static let white50 = Color.white.opacity(0.5)
    static let white60 = Color.white.opacity(0.6)
    static let white80 = Color.white.opacity(0.8)
    static let white90 = Color.white.opacity(0.9)
    static let white100 = Color.white
    static let colorMain = Color(hex: "A33CFF")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit) e.g. #f0f
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit) e.g. #FF00FF
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit) e.g. #FF00FF80
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default = black
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
