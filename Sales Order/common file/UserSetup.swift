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
    func pay_Nd() {
        if let jsonString = UserDefaults.standard.string(forKey: "isPaymentEnabled"),
           let jsonData = jsonString.data(using: .utf8) {
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                
                if let isPaymentEnabled = jsonDict?["isPaymentEnabled"] as? Int {
                    print(isPaymentEnabled)
                    paymentenb.shared.isPaymentenbl = isPaymentEnabled
                    print(paymentenb.shared.isPaymentenbl)
                } else {
                    print("Error: Unable to retrieve 'isPaymentEnabled' from JSON.")
                }
                
            } catch {
                print("Error deserializing JSON: \(error.localizedDescription)")
            }
            
        } else {
            print("Error: Unable to retrieve JSON string from UserDefaults.")
        }
    }
}
