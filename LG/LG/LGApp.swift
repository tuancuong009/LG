//
//  LGApp.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//

import SwiftUI

@main
struct LGApp: App {
    @StateObject var appVM = AppViewModel()
    @StateObject var tabBarManager = TabBarManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appVM).environmentObject(tabBarManager)
        }
    }
}
