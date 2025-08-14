//
//  ViewExtension.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI
import PopupView
extension View {
    func alertPurchasePopup(isPresented: Binding<Bool>, type: typePurchase, message: String) -> some View {
        self.popup(isPresented: isPresented) {
            AlertPurchaseView(type: type, message: message)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .autohideIn(2)
                .closeOnTapOutside(true)
                .dragToDismiss(true)
                .backgroundColor(.clear)
        }
    }

}
