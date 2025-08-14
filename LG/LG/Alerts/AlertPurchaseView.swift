//
//  AlertPurchaseView.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI
enum typePurchase: Int{
    case fail
    case success
}
struct AlertPurchaseView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let type: typePurchase
    let message: String
    var body: some View {
        VStack{
            HStack{
                Image(type == .fail ? "icon_fail" : "icon_success")
                Text(message).font(.appFontSemibold(16)) .foregroundColor(type == .fail ? .red : .green)
                Spacer()
            }
            .padding()
            
            .background(type == .fail ? Color.init(hex: "FFE9E8") : Color.init(hex: "F5FFEC"))
        }
        .cornerRadius(.infinity)
        .padding(.horizontal)
        .padding(.top, safeAreaInsets.top)
    }
}
