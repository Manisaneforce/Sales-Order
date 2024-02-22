//
//  NetworkMonitor.swift
//  Sales Order
//
//  Created by San eforce on 03/02/24.
//

import Foundation
import Network
import SwiftUI

struct Internet_Connection: View {
    var body: some View{
        ZStack {
            Rectangle()
                .foregroundColor(.red)
                .frame(height: 80)
            HStack {
                Text("Internet Not Connected")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .padding(.top,20)
            }
        }
    }
}


enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .connected
  
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if path.status == .satisfied {
                   //print("We're connected!")
                    self.status = .connected
                } else {
                   // print("No connection.")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
