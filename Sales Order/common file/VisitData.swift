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

//struct SelPrvOrder: View {
//    var body: some View {
//        List(0 ..< FilterItem.count, id: \.self) { index in
//            HStack {
//                Image("logo_new")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 70)
//                    .cornerRadius(4)
//
//                VStack {
//                    HStack(spacing: 120) {
//                        Text("Get data")
//                        Button(action: {
//                            deleteItem(at: index)
//                        }) {
//                            Image(systemName: "trash.fill")
//                                .foregroundColor(Color.red)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//
//                    HStack(spacing: 60) {
//                        Text("Rs: 000")
//
//                        HStack {
//                            Button(action: {
//                                if filterItems[index].quantity > 0 {
//                                    filterItems[index].quantity -= 1
//                                }
//                            }) {
//                                Text("-")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//
//                            Text("\(filterItems[index].quantity)")
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.black)
//
//                            Button(action: {
//                                filterItems[index].quantity += 1
//                            }) {
//                                Text("+")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 20)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 2)
//                        )
//                        .foregroundColor(Color.blue)
//                    }
//
//                    Divider()
//
//                    HStack(spacing: 100) {
//                        Text("Total")
//                        Text("₹00.00")
//                    }
//                }
//            }
//            .background(Color.white)
//            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .stroke(Color.gray.opacity(0.5),lineWidth: 1)
//                    .shadow(color: Color.gray, radius:2 , x:0,y:0)
//            )
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//            .frame(width: 350)
//        }
//    }
//}
//
//func deleteItem(at index: Int) {
//    print(lstPrvOrder)
//    print(VisitData.shared.ProductCart)
//    var ids = [String]()
//    var id = ""
//    for allid in lstPrvOrder{
//        ids.append(allid["id"] as! String)
//    }
//    id = ids[index]
//    print(ids)
//    print(id)
//    //let id=lstPrvOrder["id"] as! String
//
//
//
//    lstPrvOrder.remove(at: index)
//    VisitData.shared.ProductCart.removeAll(where: { (item) in
//        if item["id"] as! String == id {
//            return true
//        }
//        return false
//    })
//    print(lstPrvOrder)
//    print(VisitData.shared.ProductCart)
//    updateOrderValues()
//}
