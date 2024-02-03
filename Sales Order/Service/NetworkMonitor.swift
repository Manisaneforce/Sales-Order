//
//  NetworkMonitor.swift
//  Sales Order
//
//  Created by San eforce on 03/02/24.
//

import Foundation
import Network
import SwiftUI

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    @Published var isConnected: Bool = false
    @Published var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
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

