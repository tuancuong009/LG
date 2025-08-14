//
//  LocationManager.swift
//  Loc Changer
//
//  Created by Trung Ng on 6/5/25.
//


import Foundation
import CoreLocation
struct LocationInfo {
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String
    var city: String
}
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var savedLocation: LocationInfo?
    
   
    func getFullAddressFromPlacemark(placemark: CLPlacemark) -> (String, String) {
        var addressParts: [String] = []
        var city = ""
        if let number = placemark.subThoroughfare, let street = placemark.thoroughfare {
            addressParts.append("\(number) \(street)")
        } else if let street = placemark.thoroughfare {
            addressParts.append(street)
        }
        if let subLocality = placemark.subLocality {
            addressParts.append(subLocality)
           
        }

        if let locality = placemark.locality {
            addressParts.append(locality)
        }

        if let administrativeArea = placemark.administrativeArea {
            addressParts.append(administrativeArea)
            city = administrativeArea
        }

        if let country = placemark.country {
            addressParts.append(country)
        }

        return (addressParts.joined(separator: ", "), city)
    }
    
    func getAddressFromLocation(location: CLLocation, completion: @escaping (LocationInfo?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                completion(nil)
                return
            }
            print(placemark)
            let (address, city) = self.getFullAddressFromPlacemark(placemark: placemark)
            
            let locationInfo = LocationInfo(
                name: placemark.name ?? "-",
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                address: address,
                city: city
            )
            
            completion(locationInfo)
        }
    }
    
    func saveLocation(location: CLLocation, completion: @escaping (Bool) -> Void) {
        getAddressFromLocation(location: location) { [weak self] locationInfo in
            guard let locationInfo = locationInfo else {
                completion(false)
                return
            }
            self?.savedLocation = locationInfo
            print("Location saved: \(locationInfo)")
            completion(true)
        }
    }
    
    func getSavedLocation() -> LocationInfo? {
        return savedLocation
    }
    
    func deleteSavedLocation() {
        savedLocation = nil
        print("Location deleted")
    }
}
