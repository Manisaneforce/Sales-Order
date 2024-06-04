//
//  APIClient.swift
//  Sales Order
//
//  Created by San eforce on 17/08/23.
//

import Foundation
class APIClient{
    static let shared = APIClient()
    //BasURL
    //var BaseURL: String = "https://rad.salesjump.in"
    //Qa URL
    var BaseURL: String = "http://qa.salesjump.in"
    var DBURL="/server/Db_Retail_v100.php?axn="
    var TestDBURL="/server/Db_Retail_v100-Mani.php?axn="
    var DB_native_Scheme = "/server/native_Db_V13.php?axn="
    
}
