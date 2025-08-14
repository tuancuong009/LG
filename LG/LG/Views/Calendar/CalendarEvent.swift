//
//  CalendarEvent.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//


import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let iconName: String = "ic_detailgps"
}

