//
//  VisitData.swift
//  Sales Order
//
//  Created by San eforce on 23/08/23.
//

import Foundation
class VisitData{
    static var shared = VisitData()
    struct item: Any {
        var id: String=""
        var name: String=""
    }
    
    var WorkType: String = ""
    var TownCode: String = ""
    var ActivityDate: String = ""
    var Remarks: String = ""
    
    
    var CustID: String = ""
    var CustName: String = ""
    var cInTime: String = ""
    var cOutTime: String = ""
    var Dist: item = item()
    var OrderMode: item = item()
    var VstRemarks: item = item()
    var PayType: item = item()
    var DOP: item = item()
    var PayValue: String = ""
    
    var ProductCart: [AnyObject] = []
    var lstPrvOrder:[AnyObject] = []
    var LstItemCount:[AnyObject] = []
    
    func clear(){
        WorkType = ""
        TownCode = ""
        ActivityDate = ""
        Remarks = ""
        
        CustID = ""
        CustName = ""
        cInTime = ""
        cOutTime = ""
        Dist = item()
        OrderMode = item()
        VstRemarks = item()
        ProductCart = []
    }
}


class hostdata{
    static var shared = hostdata()
    var Host: String = ""
}

class paymentenb{
    static var shared = paymentenb()
    var isPaymentenbl = 0
}

class Invoiceid{
    static var shared = Invoiceid()
    var id = ""
    var Order_place_Mood = 1
}

class Paymentnav{
    static var shared = Paymentnav()
    var NavId = 1
}
