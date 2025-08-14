//
//  AppViewModel.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//


import SwiftUI

class AppViewModel: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
}
