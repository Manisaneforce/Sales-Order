//
//  GlobalFunc.swift
//  Sales Order
//
//  Created by San eforce on 12/10/23.
//

import Foundation
class GlobalFunc{
    static func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
