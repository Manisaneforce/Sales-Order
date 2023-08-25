//
//  Loctionfile.swift
//  Sales Order
//
//  Created by San eforce on 25/08/23.
//

import SwiftUI
import SwiftUI

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
    }
}
