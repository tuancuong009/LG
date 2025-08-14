//
//  UIViewExtension.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//

import SwiftUI

extension View {
    func backgroundImage(_ imageName: String) -> some View {
        self.background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}
