//
//  WeatherMiniInfo.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//

import SwiftUI
struct WeatherMiniInfo: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            Image(icon)
            Text(value)
                .foregroundColor(.white)
                .font(.appFontRegular(13))
        }
    }
}
