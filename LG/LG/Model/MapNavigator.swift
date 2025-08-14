import CoreLocation
import UIKit

class MapNavigator {
    
    // Open Apple Maps
    static func openAppleMaps(from: CLLocationCoordinate2D,
                               to: CLLocationCoordinate2D,
                               name: String? = nil,
                               completion: ((Bool) -> Void)? = nil) {
        let urlString = "http://maps.apple.com/?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)&dirflg=d"
        openURL(urlString, completion: completion)
    }

    // Open Google Maps
    static func openGoogleMaps(from: CLLocationCoordinate2D,
                                to: CLLocationCoordinate2D,
                                completion: ((Bool) -> Void)? = nil) {
        let urlString = "comgooglemaps://?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)&directionsmode=driving"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            openURL(urlString, completion: completion)
        } else {
            let browserURLStr = "https://www.google.com/maps/dir/?api=1&origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&travelmode=driving"
            openURL(browserURLStr, completion: completion)
        }
    }

    // Open Waze
    static func openWaze(from: CLLocationCoordinate2D,
                         to: CLLocationCoordinate2D,
                         completion: ((Bool) -> Void)? = nil) {
        // Waze does not support both start and end locations directly; it only supports navigation to a destination
        // So, we just navigate to "to"
        let urlString = "waze://?ll=\(to.latitude),\(to.longitude)&navigate=yes"
        openURL(urlString, completion: completion)
    }

    // Open URL
    private static func openURL(_ urlString: String,
                                completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            completion?(false)
            return
        }
        UIApplication.shared.open(url, options: [:]) { success in
            completion?(success)
        }
    }
}
