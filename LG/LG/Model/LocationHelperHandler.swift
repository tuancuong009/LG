//
//  LocationHelper.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//

import SwiftUI
import PopupView
import CoreLocation
class LocationHelperHandler: ObservableObject {
    static let shared = LocationHelperHandler()

    var locationCurrent: LocationInfo?
    var locationTap: LocationInfo?
    var locationSave: LocationInfo?
    var heightLocation: Double = 0.0
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
    
    
}

