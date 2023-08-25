//
//  NetworkMonitor.swift
//  Sales Order
//
//  Created by San eforce on 25/08/23.
//

import Foundation
import Network

final class NetworkMonitor{
    static let Shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    private init ()
    {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
            if self?.isConnected == false {
               // Toast.showToast(message: "Internet Not Connect")
            }else{
               // Toast.removeNotification()
            }
        }
    }
    public func stopMonitoring(){
        monitor.cancel()
    }
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unknown
        }
    }
}

