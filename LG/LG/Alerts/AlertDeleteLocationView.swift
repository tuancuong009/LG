//
//  AlertDeleteLocationView.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//

import SwiftUI

struct AlertDeleteLocationView: View {
    @Binding var isPresented: Bool
    var onRemoveLocation: (() -> Void)? = nil
    var body: some View {
        
        
        VStack(spacing: 10) {
            HStack {
                
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Image("btnClose")
                }
            }
            Image("ic_fail")
            Text("Remove Location")
                .font(.appFontSemibold(20))
                .foregroundColor(.white)

            Text("Are you sure you want to remove this location?")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white50)
                .font(.appFontRegular(15))
            VStack{
                Button(action: {
                    isPresented = false
                    onRemoveLocation?()
                }) {
                    Text("Remove")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red)
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
