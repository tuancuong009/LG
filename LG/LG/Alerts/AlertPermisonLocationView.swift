//
//  AlertPermisonLocationView.swift
//  LG
//
//  Created by QTS Coder on 14/8/25.
//


import SwiftUI

struct AlertPermisonLocationView: View {
    
    var onNo: (() -> Void)? = nil
    var onYes: (() -> Void)? = nil
    var body: some View {
        VStack(spacing: 10) {
            Image("ic_fail")
            Text("Permission denied")
                .font(.appFontSemibold(20))
                .foregroundColor(.white)

            Text("Please enable Location Services in Settings > Privacy > Location Services.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white50)
                .font(.appFontRegular(15))
            VStack{
                Button(action: {
                    onYes?()
                }) {
                    Text("Settings")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    onNo?()
                }) {
                    Text("Cancel")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.init(hex: "161b23"))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 20)
           .padding(.top, 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .background(Color(hex: "161b23").opacity(0.3)) // Overlay màu tối nhẹ nếu muốn
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .cornerRadius(24)
        .padding(40)
        .shadow(radius: 20)
        
    }
}
