//
//  Loctionfile.swift
//  Sales Order
//
//  Created by MANI on 25/08/23.
//

import SwiftUI
import Combine
import CoreLocation

var addresdata:String = ""
struct Loctionfile: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            Text("Current Location:")
            if let latitude = locationManager.userLocation?.coordinate.latitude,
               let longitude = locationManager.userLocation?.coordinate.longitude {
                Text("\(latitude), \(longitude)")
            } else {
                Text("Location not available")
                
            }
            
            Text("Address:")
            Text(locationManager.userAddress)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Loctionfile()
        UpdateLocation()
    }
}


struct UpdateLocation: View {
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    @State var address = ""

    var body: some View {
        VStack {
            Text("Address: \(addresdata)")
                .font(.headline)
            Text("Latitude: \(coordinates.lat)")
                .font(.largeTitle)
            Text("Longitude: \(coordinates.lon)")
                .font(.largeTitle)
        }
        .onAppear {
            observeCoordinateUpdates()
            observeLocationAccessDenied()
            deviceLocationService.requestLocationUpdates()
        }
    }

    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                self.updateAddress()
            }
            .store(in: &tokens)
    }

    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
    
    func updateAddress() {
        let location = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        var sAddress: String = ""
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if(placemarks != nil){
                if(placemarks!.count>0){
                    let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                    for i in 0...jAddress.count-1 {
                        print(jAddress[i])
                        if i==0{
                            sAddress = String(format: "%@", jAddress[i])
                        }else{
                            sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                        }
                    }
                }
            }
            addresdata = sAddress
            print(sAddress)
        }
    }
}

extension CLPlacemark {
    var formattedAddress: String? {
        if let name = name, let locality = locality, let country = country {
            return "\(name), \(locality), \(country)"
        } else {
            return nil
        }
    }
}
