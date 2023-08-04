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
    var body: some Scene {
        WindowGroup {
            if #available(iOS 15.0, *) {
                ContentView(numberOffFields: 6)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
