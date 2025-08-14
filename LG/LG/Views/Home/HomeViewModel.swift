//
//  HomeViewModel.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//


import Foundation
import MapKit
import CoreLocation
import CoreMotion

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    var onSuccessLocation: ((CLLocation) -> Void)? = nil
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    private var wasSentToBackground = false
    private var wasCenterMap = false
    private var currentLocation: LocationInfo?
    var onTapLocation: ((LocationInfo) -> Void)? = nil
    override init() {
        super.init()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    
    func checkPermissions() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        if CMMotionActivityManager.authorizationStatus() == .notDetermined {
            requestMotionPermission()
        }
    }

    func centerToUser() {
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }

    func toggleMapType() {
        mapView.mapType = mapView.mapType == .standard ? .satellite : .standard
    }

    func didEnterBackground() {
        wasSentToBackground = true
        locationManager.stopUpdatingLocation()
    }

    func didBecomeActive() {
        if wasSentToBackground {
            locationManager.startUpdatingLocation()
        }
    }

    private func requestMotionPermission() {
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, error in
            if let error = error {
                print("Motion error: \(error.localizedDescription)")
            } else {
                print("Motion permission granted")
            }
        }
    }

    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        print("Updated location: \(loc)")
        LocationHelperHandler.shared.heightLocation = loc.verticalAccuracy
        LocationHelperHandler.shared.getAddressFromLocation(location: loc) { location in
            LocationHelperHandler.shared.locationCurrent = location
        }
        if !self.wasCenterMap{
            self.wasCenterMap.toggle()
            centerToUser()
            onSuccessLocation?(loc)
        }
       
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Permission granted. Starting location updates...")
        case .denied, .restricted:
            OnboardingsManagerHandler.shared.isDisableLocation = true
            print("Permission denied or restricted.")
        case .notDetermined:
            print("Permission not determined yet.")
        @unknown default:
            break
        }
    }
    
    func pinAppToSearch(locationSearch: CLLocation){

        let region = MKCoordinateRegion(center: locationSearch.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationSearch.coordinate
        mapView.addAnnotation(annotation)
        LocationHelperHandler.shared.getAddressFromLocation(location: locationSearch) { location in
            LocationHelperHandler.shared.locationTap = location
            guard let location = location else{
                return
            }
            self.onTapLocation?(location)
        }
    }
}
