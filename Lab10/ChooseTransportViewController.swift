//
//  ChooseTransportViewController.swift
//  Lab10
//
//  Created by Anton Sipaylo on 6/6/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ChooseTransportViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var transportSegmentedControl: UISegmentedControl!
    @IBOutlet weak var buildRouteButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let racesInfoSegueName = "RacesInfoSegue"
    let locationManager = CLLocationManager()
    let distance = CLLocationDistance(10000)
    
    var hotelLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
//        setUpMapViewGestureRecognizer()
        setHotelAnnotation()
        setUpGoToRaceChoosingBarButton()
    }
    
    @IBAction func buildRouteButtonPressed(_ sender: UIButton) {
        guard let request = getDirections() else { return }
        let directions = MKDirections(request: request)
        directions.calculate { reponse, error in
            guard let response = reponse else { return }
            print(response.routes.count)
            let route = response.routes[self.transportSegmentedControl.selectedSegmentIndex]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           animated: true)
        }
    }
    
    func getDirections() -> MKDirections.Request? {
        if let location = locationManager.location {
            let startLocation = MKPlacemark(coordinate: location.coordinate)
            let finishLocation = MKPlacemark(coordinate: hotelLocation.coordinate)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startLocation)
            request.destination = MKMapItem(placemark: finishLocation)
            request.transportType = .automobile
            request.requestsAlternateRoutes = true
            return request
        }
        return nil
    }
    
    
    
    func setUpGoToRaceChoosingBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(goToRaceChosing))
    }
    
    @objc private func goToRaceChosing() {
        performSegue(withIdentifier: racesInfoSegueName,
                     sender: self)
    }
    
    func setHotelAnnotation() {
        let coordinate = hotelLocation.coordinate
        setAnnotation(coordinate: coordinate)
    }
    
    // Didn't work on simulator!!!
    
//    func setUpMapViewGestureRecognizer() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(processTapOnMapView))
//        tapGestureRecognizer.delegate = self
//        mapView.addGestureRecognizer(tapGestureRecognizer)
//    }
//
//    @objc private func processTapOnMapView(_ gestureRecognizer: UITapGestureRecognizer) {
//        let location = gestureRecognizer.location(in: mapView)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//        setAnnotation(coordinate: coordinate)
//    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        let placeAnnotation = MKPointAnnotation()
        placeAnnotation.coordinate = coordinate
        let geoCoder = CLGeocoder()
        let locationOnMapView = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(locationOnMapView) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            guard let city = placemark.subAdministrativeArea,
                let country = placemark.country,
                let region = placemark.administrativeArea else {
                    return
            }
            placeAnnotation.title = country
            placeAnnotation.subtitle = city
            let title = "\(city), \(country)"
            self.setTitle(title: title)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(placeAnnotation)
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func centerUserViewOnLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: distance,
                                                 longitudinalMeters: distance)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerUserViewOnLocation()
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func setHotelLocation(longitude: Double, latitude: Double) {
        hotelLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func setTitle(title: String) {
        navigationItem.title = title
    }

}

extension ChooseTransportViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            return
//        }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                            longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center,
//                                             latitudinalMeters: distance, longitudinalMeters: distance)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension ChooseTransportViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let colors: [UIColor] = [.blue, .red, .gray, .orange]
//        guard let index = mapView.overlays.firstIndex(where: {$0 === overlay}) else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = colors[transportSegmentedControl.selectedSegmentIndex]
        renderer.lineWidth = 5
        return renderer
    }
}
