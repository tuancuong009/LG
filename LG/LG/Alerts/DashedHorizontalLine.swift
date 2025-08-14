//
//  DashedHorizontalLine.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//
import SwiftUI

struct DashedHorizontalLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundColor(.gray)
        }
        .frame(height: 1)
    }
}
