//
//  TapScaleButton.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI
struct TapScaleButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content

    @GestureState private var isPressed = false

    var body: some View {
        let tapGesture = DragGesture(minimumDistance: 0)
            .updating($isPressed) { _, state, _ in state = true }
            .onEnded { _ in action() }

        return content()
            .scaleEffect(isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isPressed)
            .gesture(tapGesture)
    }
}
