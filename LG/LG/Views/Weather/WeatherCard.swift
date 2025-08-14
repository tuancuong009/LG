//
//  WeatherCard.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//

import SwiftUI
struct WeatherCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let imageLine: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(icon)
                    .foregroundColor(.white.opacity(0.6))
                Text(title)
                    .foregroundColor(.white50)
                    .font(.appFontRegular(13))
                Spacer()
            }
          

            Text(value)
                .foregroundColor(.white)
                .font(.appFontMedium(17))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay {
            HStack{
                Image(imageLine)
                Spacer()
            }
           
        }
    }
}
