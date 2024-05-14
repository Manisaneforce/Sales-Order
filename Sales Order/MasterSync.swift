//
//  MasterSync.swift
//  Sales Order
//
//  Created by San eforce on 04/03/24.
//

import Foundation
import Alamofire


class SyncData{
    static let shared = SyncData()
    
    func SyncAllData(){
        setUserSetup()
        prodGroupdata()
        prodTypesdata()
        prodCatedata()
        prodDetsdata()
        Prod_Sch_Det()
        prod_Tax_Det()
        isPaymentEnabled()
    }

    func setUserSetup() {
        let axn = "appstups"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&ERPCode=\(CustDet.shared.ERP_Code)&CusID=\(CustDet.shared.CusId)"

        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        do {
                            let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyPrintedJson = try JSONSerialization.jsonObject(with: prettyJsonData) as? [String: Any] {
                                print(prettyPrintedJson)
                                if let res_Data = prettyPrintedJson["response"] as? [String: Any] {
                                    print(res_Data)
                                    if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: res_Data, requiringSecureCoding: false) {
                                        let LocalStoreage = UserDefaults.standard
                                        LocalStoreage.set(archivedData, forKey: "UserSetup")
                                    } else {
                                        print("Failed to archive data")
                                    }
                                }
                            }else {
                                print("Error: Could not convert Pretty JSON data to dictionary")
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func prodGroupdata() {
        let axn = "get/prodGroup"
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID":"\(CustDet.shared.CusId)","Stk":"\(CustDet.shared.StkID)"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodGroupdata")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    func prodTypesdata() {
        let axn = "get/prodTypes"
      
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID":"\(CustDet.shared.CusId)","Stk":"\(CustDet.shared.StkID)"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodTypesdata")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    func prodCatedata(){
        let axn = "get/prodCate"
        //url = http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/prodGroup
      
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID":"\(CustDet.shared.CusId)","Stk":"\(CustDet.shared.StkID)"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodCatedata")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        
    }

    func prodDetsdata(){
        let axn = "get/prodDets"
      
        let apiKey = "\(axn)"
        
        let aFormData: [String: Any] = [
            "CusID":"\(CustDet.shared.CusId)","Stk":"\(CustDet.shared.StkID)"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        
        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "prodDetsdata")
                 
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func Prod_Sch_Det(){
        let axn = "get/Scheme"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&rSF=\(CustDet.shared.CusId)&sfCode=\(CustDet.shared.CusId)&State_Code=15&desig=MGR"
       
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DB_native_Scheme + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "Schemes_Master")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    func prod_Tax_Det(){
        let axn = "get/producttaxdetails"
        let apiKey = "\(axn)"
        let aFormData: [String: Any] = [
            "distributorid" : "\(CustDet.shared.StkID)",
            "retailorId" : "\(CustDet.shared.CusId)",
            "divisionCode" : "\(CustDet.shared.Div)"
        ]
        print(aFormData)
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
        print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        print(prettyPrintedJson)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "Tax_Master")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    func isPaymentEnabled(){
        let axn = "enable_payments"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&id=\(CustDet.shared.CusId)"
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                        var lstisPaymentEnabled:[String:AnyObject] = [:]
                        if let list = GlobalFunc.convertToDictionary(text: prettyPrintedJson) as? [String:AnyObject] {
                            lstisPaymentEnabled = list;
                        }
                        print(lstisPaymentEnabled)
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "isPaymentEnabled")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
