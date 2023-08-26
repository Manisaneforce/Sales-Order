//
//  LocationService.swift
//  Sales Order
//
//  Created by San eforce on 25/08/23.
//

import Foundation
import CoreLocation
import Combine

public class LocationService: NSObject, CLLocationManagerDelegate{
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var requestNewLocation: ((_ newLocation: CLLocation) -> Void)?
    var ErrorLocation: ((_ errmsg: String) -> Void)?
    var Tmr: Timer = Timer()
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.activityType = .fitness
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
        self.Tmr=Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ExitLocation), userInfo: nil, repeats: false)
        
    }
    @objc func ExitLocation(){
        self.ErrorLocation?("Timed Out. Location Can't Capture")
        Tmr.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    public func getNewLocation(location: ((CLLocation) -> Void)?,error: ((String) -> Void)?) {
        self.requestNewLocation = location
        self.ErrorLocation = error
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // for(int i=0;i<locations.count;i++)
        for i in 0...locations.count-1 {
            let newLocation: CLLocation = locations[i]
            let theLocation: CLLocationCoordinate2D  = newLocation.coordinate
            let theAccuracy: CLLocationAccuracy  = newLocation.horizontalAccuracy
            
            let locationAge: TimeInterval  = -newLocation.timestamp.timeIntervalSinceNow
            NSLog("New Location: %f , %f", theLocation.latitude, theLocation.longitude);
            
            if (locationAge > 30.0)
            {
                continue;
            }
            
            if(newLocation != nil && theAccuracy > 0 && theAccuracy < 2000 && (!(theLocation.latitude==0.0 && theLocation.longitude==0.0))){
                
                //self.myLastLocation = theLocation;
                //self.myLastLocationAccuracy= theAccuracy;
                
                if(self.requestNewLocation != nil ){
                    Tmr.invalidate()
                    self.requestNewLocation?(newLocation)
                    locationManager.stopUpdatingLocation()
                }
                
                let dict = NSMutableDictionary()
                dict.setObject(theLocation.latitude , forKey: "latitude" as NSCopying)
                dict.setObject(theLocation.longitude , forKey: "longitude" as NSCopying)
                dict.setObject(theAccuracy , forKey: "theAccuracy" as NSCopying)
                
            }
        }
    }
}






class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var userAddress: String = "Address not available"
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                // Handle case when user denied or restricted location access
                break
            @unknown default:
                fatalError("Unhandled case of authorization status")
            }
        } else {
            // Handle case when location services are disabled
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Check location accuracy if needed
            if location.horizontalAccuracy < 100 {
                userLocation = location
                getAddress(for: location)
            }
        }
    }
    
    private func getAddress(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                print("Placemark: \(placemark)")
                self.userAddress = placemark.formattedAddresss ?? "Address not available"
            }
        }
    }
}

extension CLPlacemark {
    var formattedAddresss: String? {
        if let name = name, let locality = locality, let country = country {
            return "\(name), \(locality), \(country)"
        } else {
            return nil
        }
    }
}
