//
//  SafariView.swift
//  LG
//
//  Created by QTS Coder on 8/8/25.
//


import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Usually nothing here
    }
}
