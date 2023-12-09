//
//  LocationManager.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.distanceFilter = 50
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
    }
}
