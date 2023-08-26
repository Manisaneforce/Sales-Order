//
//  DeviceLocationService.swift
//  Sales Order
//
//  Created by Mani on 26/08/23.
//

import Foundation
import Combine
import CoreLocation

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()

    private override init() {
        super.init()
    }
    static let shared = DeviceLocationService()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()

    private lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()

    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            deniedLocationAccessPublisher.send()
        }
    }

    func convertAddressToCoordinates(address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let error = error {
                self?.coordinatesPublisher.send(completion: .failure(error))
                return
            }

            if let location = placemarks?.first?.location {
                self?.coordinatesPublisher.send(location.coordinate)
            } else {
                let geocodingError = NSError(domain: "GeocodingErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to geocode address"])
                self?.coordinatesPublisher.send(completion: .failure(geocodingError))
            }
        }
    }

    // CLLocationManagerDelegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.startUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}



