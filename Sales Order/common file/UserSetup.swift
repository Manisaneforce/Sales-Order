//
//  UserSetup.swift
//  Sales Order
//
//  Created by San eforce on 14/02/24.
//

import Foundation
import Alamofire

class UserSetup{
    static let shared = UserSetup()
    var Add_Address: Int = 0
    
    func int() {
        if let storedData = UserDefaults.standard.object(forKey: "UserSetup") as? [String: Any] {
               print("Stored Data: \(storedData)")
            Add_Address = storedData["isAdd_Address_Enabled"] as? Int ?? 0
           } else {
               print("No data found in UserDefaults for key 'UserSetup'")
           }
    }
}
