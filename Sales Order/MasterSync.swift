//
//  MasterSync.swift
//  Sales Order
//
//  Created by San eforce on 04/03/24.
//

import Foundation
import Alamofire

class SyncData {
    static let shared = SyncData()
    
    func SyncAllData(completion: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        setUserSetup {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        prodGroupdata {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        prodTypesdata {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        prodCatedata {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        prodDetsdata {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Prod_Sch_Det {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        prod_Tax_Det {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        isPaymentEnabled {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All data synchronized")
            completion(true)
        }
    }

    private func setUserSetup(completion: @escaping () -> Void) {
        let axn = "appstups"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&ERPCode=\(CustDet.shared.ERP_Code)&CusID=\(CustDet.shared.CusId)"

        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [String: AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = try JSONSerialization.jsonObject(with: prettyJsonData) as? [String: Any],
                               let res_Data = prettyPrintedJson["response"] as? [String: Any],
                               let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: res_Data, requiringSecureCoding: false) {
                                UserDefaults.standard.set(archivedData, forKey: "UserSetup")
                                print(archivedData)
                            } else {
                                print("Error: Could not convert Pretty JSON data to dictionary")
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                completion()
            }
    }

    private func prodGroupdata(completion: @escaping () -> Void) {
        let axn = "get/prodGroup"
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID": CustDet.shared.CusId,
            "Stk": CustDet.shared.StkID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodGroupdata")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func prodTypesdata(completion: @escaping () -> Void) {
        let axn = "get/prodTypes"
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID": CustDet.shared.CusId,
            "Stk": CustDet.shared.StkID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodTypesdata")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func prodCatedata(completion: @escaping () -> Void) {
        let axn = "get/prodCate"
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID": CustDet.shared.CusId,
            "Stk": CustDet.shared.StkID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodCatedata")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func prodDetsdata(completion: @escaping () -> Void) {
        let axn = "get/prodDets"
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID": CustDet.shared.CusId,
            "Stk": CustDet.shared.StkID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodDetsdata")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func Prod_Sch_Det(completion: @escaping () -> Void) {
        let axn = "get/Scheme"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&rSF=\(CustDet.shared.CusId)&sfCode=\(CustDet.shared.CusId)&State_Code=15&desig=MGR"
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DB_native_Scheme + apiKey, method: .post)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "Schemes_Master")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func prod_Tax_Det(completion: @escaping () -> Void) {
        let axn = "get/producttaxdetails"
        let apiKey = "\(axn)"
        let aFormData: [String: Any] = [
            "distributorid": CustDet.shared.StkID,
            "retailorId": CustDet.shared.CusId,
            "divisionCode": CustDet.shared.Div
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post, parameters: params)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "Tax_Master")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }

    private func isPaymentEnabled(completion: @escaping () -> Void) {
        let axn = "enable_payments"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&id=\(CustDet.shared.CusId)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                              let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            return
                        }
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "isPaymentEnabled")
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }
}


