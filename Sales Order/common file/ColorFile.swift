//
//  ColorFile.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import Foundation
import SwiftUI

class ColorData {
    static var shared = ColorData()
    var HeaderColor: Color = Color(red: 0.10, green: 0.59, blue: 0.81, opacity: 1.00)
}

class CustDet{
    static var shared = CustDet()
    var Det:[String:Any] = [:]
    var CusId:String = ""
    var Addr:String = ""
    var Div:Int = Int()
    var Mob:String = ""
    var CusName:String = ""
    var ERP_Code:String = ""
    var StkNm:String = ""
    var StkAddr:String = ""
    var StkID:String = ""
    var StkMob:String = ""
}

class DashboardBaner{
    static var shared = DashboardBaner()
    
    var ImgUrl = [String]()
}

class From_To_Date{
    static var shared = From_To_Date()
    var SetDate = 0
    var From = ""
    var To = ""
}
