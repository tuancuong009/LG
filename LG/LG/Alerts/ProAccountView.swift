//
//  ProAccountView.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI

struct ProAccountView: View {
    @Binding var isPresented: Bool
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        ZStack{
            VStack(spacing: 24) {
                // Header
                HStack {
                   
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image("btnClose").frame(width: 40, height: 40)
                    }
                }

                // Current Plan
                VStack(alignment: .center, spacing: 12) {
                    Image("account_pro")
                    Text("You’re Now Pro!")
                        .font(.appFontBold(22))
                        .foregroundColor(.white)
                    Text("Enjoy unlimited location saves. Save, edit and share locations and more features.")
                        .font(.appFontRegular(17)).multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }

              
                Button(action: {
                    // Trigger purchase
                    isPresented = false
                }) {
                    Text("Thank you")
                        .font(.appFontSemibold(20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            Capsule()
                                .strokeBorder(Color(hex: "7FECA1"), lineWidth: 3)
                                .background(Capsule().fill(Color(hex: "10D359")))
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, safeAreaInsets.bottom + 10)
            }
        }
        
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white10, lineWidth: 1)
                .backgroundImage("bgPopUp"))
        .cornerRadius(20)
        .padding(.bottom, -(safeAreaInsets.bottom + 10))
    }
}

