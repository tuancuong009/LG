//
//  LocationManagerHandler.swift
//  Loc Changer
//
//  Created by Trung Ng on 29/4/25.
//


import UIKit
import CoreLocation

class LocationManagerHandler: NSObject {
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocation) -> Void)?
    private var didStartUpdating = false
    
    init(updateHandler: ((CLLocation) -> Void)? = nil) {
        super.init()
        self.locationUpdateHandler = updateHandler
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("Location services are disabled.")
        }
    }
    
    func startUpdatingLocationIfAuthorized() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if !didStartUpdating {
                locationManager.startUpdatingLocation()
                didStartUpdating = true
            }
        } else {
            print("Location permission not granted.")
        }
    }
    
    func stopUpdatingLocation() {
        if didStartUpdating {
            locationManager.stopUpdatingLocation()
            didStartUpdating = false
        }
    }
    
    func onLocationUpdate(_ handler: @escaping (CLLocation) -> Void) {
        self.locationUpdateHandler = handler
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManagerHandler: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Permission granted. Starting location updates...")
            startUpdatingLocationIfAuthorized()
        case .denied, .restricted:
            print("Permission denied or restricted.")
        case .notDetermined:
            print("Permission not determined yet.")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        locationUpdateHandler?(latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
