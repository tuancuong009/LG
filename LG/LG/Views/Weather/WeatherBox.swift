//
//  WeatherBox.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//
import SwiftUI

struct WeatherBox: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.appFontRegular(15))
                        .foregroundColor(.white50)
                Spacer()
                Image(icon)
            }

            Text(value)
                .foregroundColor(.white)
                .font(.appFontSemibold(20))

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.appFontRegular(13))
                        .foregroundColor(.white50)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
