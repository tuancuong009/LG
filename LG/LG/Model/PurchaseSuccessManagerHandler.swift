//
//  PopupManager.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//


import SwiftUI
import PopupView

class PurchaseSuccessManagerHandler: ObservableObject {
    static let shared = PurchaseSuccessManagerHandler()

    @Published var isShowing = false
}

class OnboardingsManagerHandler: ObservableObject {
    static let shared = OnboardingsManagerHandler()

    @Published var isShowing = false
    @Published var isSaveLocationSuccess = false
    @Published var isDisableLocation = false
}
