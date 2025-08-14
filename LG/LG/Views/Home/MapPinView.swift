//
//  MapPinView.swift
//  LG
//
//  Created by QTS Coder on 7/8/25.
//


import SwiftUI
import MapKit

struct MapPinView: View {
    let latitude: Double
    let longitude: Double

    @State private var region: MKCoordinateRegion
    @State private var annotationItems: [Place]

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude

        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
        _annotationItems = State(initialValue: [Place(coordinate: center)])
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotationItems) { place in
            MapMarker(coordinate: place.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
