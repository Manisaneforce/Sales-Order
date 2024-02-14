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
    
    func SetUserSetup(){
        let axn = "appstups"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&ERPCode=\(CustDet.shared.ERP_Code)&CusID=\(CustDet.shared.CusId)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any] else {
                            print("Error: Could not convert Pretty JSON data to dictionary")
                            return
                        }
                        print(prettyPrintedJson)
                        if let isAddAddressEnabled = prettyPrintedJson["isAdd_Address_Enabled"] as? Int {
                            self.Add_Address = isAddAddressEnabled
                            print(self.Add_Address)
                        } else {
                         print("Error: Unable to retrieve 'isAdd_Address_Enabled' from JSON")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
