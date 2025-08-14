//
//  BottomPopupView.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//

import SwiftUI
import SwiftUI

struct BottomPopupView: View {
    @State private var location: LocationInfo? = nil
    
    var onEdit: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil
    var onSave: (() -> Void)? = nil
    var onRoute: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            locationInfoView
            actionButtons
        }
        .padding(.top)
        .background(Color.black.opacity(0))
        .onAppear {
            self.location = LocationHelperHandler.shared.locationSave
        }
    }

    private var locationInfoView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                headerView
                coordinateView
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.purple, lineWidth: 1)
                    .background(Color.black.opacity(0.8).cornerRadius(20))
            )
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.clear, lineWidth: 1)
                .background(Color(hex: "E1621").cornerRadius(20))
        )
        .padding(.horizontal, 10)
    }

    private var headerView: some View {
        HStack {
            Image("ic_detailgps")
            VStack(alignment: .leading) {
                Text(location?.name ?? "-")
                    .font(.appFontSemibold(17))
                    .foregroundColor(.white)
                Text(location?.address ?? "-")
                    .font(.appFontRegular(13))
                    .foregroundColor(.white50)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }

    private var coordinateView: some View {
        let latitude = location?.latitude ?? 0.0
        let formattedLatitude = String(format: "%.4f", latitude)

        let longitude = location?.longitude ?? 0.0
        let formattedLongitude = String(format: "%.4f", longitude)

        let height = LocationHelperHandler.shared.heightLocation
        let formattedHeight = String(format: "%.2f", height)

        return HStack(spacing: 20) {
            infoBox(icon: "ic_lat", title: "Latitude", value: formattedLatitude)
            Image("icLine")
            infoBox(icon: "ic_long", title: "Longitude", value: formattedLongitude)
            Image("icLine")
            infoBox(icon: "ic_height", title: "Height", value: formattedHeight)
        }
        .padding()
    }

    private var actionButtons: some View {
        HStack(spacing: 30) {
            Button { onEdit?() } label: {
                actionButton(icon: "icEdit", label: "Edit")
            }.frame(maxWidth: .infinity)
            Button { onShare?() } label: {
                actionButton(icon: "icShared", label: "Share", color: .purple)
            }.frame(maxWidth: .infinity)
            Button { onSave?() } label: {
                actionButton(icon: "icSave", label: "Save", color: .red)
            }.frame(maxWidth: .infinity)
            Button { onRoute?() } label: {
                actionButton(icon: "icRedirect", label: "Route", color: .green)
            }.frame(maxWidth: .infinity)
        }
        .padding(.bottom, 20)
        .padding(.horizontal)
    }
    
    func infoBox(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 5) {
            Image(icon)
            Text(title)
                .font(.appFontRegular(12))
                .foregroundColor(.white40)
            Text(value)
                .font(.appFontMedium(13))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
    
    func actionButton(icon: String, label: String, color: Color = .white.opacity(0.7)) -> some View {
        VStack(spacing: 6) {
            Image(icon)
            Text(label)
                .font(.appFontMedium(13))
                .foregroundColor(.white)
        }
    }
}
