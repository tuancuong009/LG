//
//  ScaleButtonStyle.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
    }
}
