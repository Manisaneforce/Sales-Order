//
//  Sales_OrderApp.swift
//  Sales Order
//
//  Created by San eforce on 02/08/23.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct Sales_OrderApp: App {
    @StateObject private var monitor = Monitor()
    var body: some Scene {
        WindowGroup {
               // ContentView()
            NewMobileNoScrean()
                .environmentObject(monitor)
        }
    }
}
