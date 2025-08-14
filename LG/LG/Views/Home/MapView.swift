import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var mapView: MKMapView
    var onTapLocation: ((CLLocationCoordinate2D) -> Void)? = nil
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let point = gestureRecognizer.location(in: parent.mapView)
            let coordinate = parent.mapView.convert(point, toCoordinateFrom: parent.mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
          
            
            let currentRegion = parent.mapView.region
            let newRegion = MKCoordinateRegion(center: coordinate, span: currentRegion.span)
            parent.mapView.setRegion(newRegion, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            LocationHelperHandler.shared.getAddressFromLocation(location: location) { location in
                LocationHelperHandler.shared.locationTap = location
                self.parent.onTapLocation?(coordinate)
            }
           
           
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "icMark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.image = UIImage(named: "icMark")
                annotationView?.centerOffset = CGPoint(x: 0, y: -annotationView!.image!.size.height / 2)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
