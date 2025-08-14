//
//  AlertPopupView.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//


import SwiftUI

struct AlertPopupView: View {
    let data: AlertPopupData
    let onDismiss: () -> Void

    var body: some View {
        
        VStack(spacing: 10) {
            Image(data.iconName)
            Text(data.title)
                .font(.appFontSemibold(20))
                .foregroundColor(.white)

            Text(data.message)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white50)
                .font(.appFontRegular(15))
            
            Button(action: {
                onDismiss()
            }) {
                Text("Ok")
                    .font(.appFontSemibold(16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white100)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
            }.padding(.top, 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white15)
                .background(Color.init(hex: "161b23").cornerRadius(20))
        )
        .cornerRadius(24)
        .padding(40)
        .shadow(radius: 20)
        
    }
}
