//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI
import Alamofire


struct Order: View {
    @State private var number = 0
    @State private var inputNumberString = ""
    @State private var Arry = ["FIPOREL_ S DOG 0.67 ML","gjehfu","ndhbhbf","FIPOREL_ S DOG 0.67 ML"]
    @State private var nubers = [15,555,554,54]
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
    @State private var prettyPrintedJson: String = ""
    @State private var prodTypes2 = [String]()
    @State private var prodCate: String = ""
    @State private var prodDets: String = ""
    @State private var selectedIndices: Set<Int> = []
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(height: 100)
                    
                    HStack {
                        NavigationLink(destination: HomePage()) {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                        .offset(x: -120, y: 25)
                        
                        Text("Order")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .offset(x: -20)
                    }
                }
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("DR. INGOLE")
                        .font(.system(size: 15))
                    HStack {
                        Image("SubmittedCalls")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                        Text("9923125671")
                            .font(.system(size: 15))
                    }
                    Text("Shivaji Park, Dadar")
                        .font(.system(size: 15))
                    
                    Text(prettyPrintedJson)
                        .font(.system(size: 15))
                        .foregroundColor(Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                             ForEach(prodTypes2.indices, id: \.self) { index in
                                 Button(action: {
                                     if selectedIndex == index {
                                         selectedIndex = nil
                                     } else {
                                         selectedIndex = index
                                     }
                                     print("Clicked button at index: \(index)")
                                 }) {
                                     Text(prodTypes2[index])
                                         .foregroundColor(.white)
                                         .padding(.horizontal, 10)
                                         .padding(.vertical, 5)
                                         .background(selectedIndex == index ? Color.blue : Color.gray)
                                         .cornerRadius(10)
                                 }
                             }
                         }
                         .padding(.horizontal, 20)

                    }

                }
                .padding(.bottom, 20)
                .onAppear {
                    prodGroup { jsonString in
                        if let jsonData = jsonString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]],
                                   let firstItem = jsonArray.first {
                                    let textname = firstItem["name"] as? String ?? ""
                                    print("Name: \(textname)")
                                    prettyPrintedJson = textname
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }
                    Sales_Order.prodTypes { json in
                        if let jsonData = json.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    var prodTypes1 = [String]()
                                    for item in jsonArray {
                                        if let textName = item["name"] as? String {
                                            prodTypes1.append(textName)
                                        }
                                    }
                                    print(prodTypes1)
                                    prodTypes2 = prodTypes1
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }

                    Sales_Order.prodCate{
                        json in
                        prodCate = json
                        print(prodCate)
                    }
                    Sales_Order.prodDets{
                        json in
                        prodDets = json
                        print(prodDets)
                    }
                               }
                
                NavigationView {
                List(0 ..< Arry.count, id: \.self) { index in
                    HStack {
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 70)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(Arry[index])
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text("RLVT001")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("MRP ₹\(nubers[index])")
                                Spacer()
                                Text("Price ₹197.00")
                            }
                            HStack {
                                NavigationLink(destination: ExtractedView()) {
                                   
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Text("Pipette")
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 20)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray, lineWidth: 2)
                                            )
                                    }
                                }
                                
                                Spacer()
                                HStack {
                                    Button(action: {
                                        self.number -= 1
                                        
                                    }) {
                                        Text("-")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Text("\(number)")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                    Button(action: {
                                        self.number += 1
                                    }) {
                                        Text("+")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.trailing)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                                .foregroundColor(Color.blue)
                            }
                            
                            HStack {
                                Text("Free : 0")
                                Spacer()
                                Text("₹0.00")
                            }
                            Divider()
                            HStack {
                                Text("Total Qty: \(number)")
                                Spacer()
                                let totalvalue = nubers[0]
                                Text("₹\(totalvalue).00")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .background(Color.white)
                }
                .listStyle(PlainListStyle())
            }
                
            }
            .padding(.top, 10)
            .navigationBarHidden(true)
        }
       
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.trailing, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
    }
}


struct ExtractedView: View {
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
    var body: some View {
        
        ZStack{
            VStack{
                Text(selectedItem)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 15)
                    .background(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        isPopupVisible.toggle()
                    }
            }
            
            
            if isPopupVisible {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPopupVisible.toggle()
                    }
                VStack {
                    HStack {
                        Text("Select Item")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            isPopupVisible.toggle()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    SearchBar(text: $selectedItem) // Assuming you have a SearchBar view
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    VStack {
                        Button(action: {
                            selectedItem = "Pipette"
                            isPopupVisible.toggle()
                        }) {
                            VStack {
                                Text("Pipette")
                                Text("1x1=1")
                            }
                        }
                        Divider()
                        Button(action: {
                            selectedItem = "Box"
                            isPopupVisible.toggle()
                        }) {
                            VStack {
                                Text("Box")
                                Text("10x1=10")
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            }
        }
    
      
    }

}

struct YourDataStructure: Codable {
    let id: Int
    let name: String
    let ProdGrp_Sl_No: Int
}


func prodGroup(completion: @escaping (String) -> Void) {
    
    let axn = "get/prodGroup"
    //url = http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/prodGroup
  
    let apiKey = "\(axn)"
    
    let aFormData: [String: Any] = [
        "CusID":"9","Stk":"3"
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
                    completion(prettyPrintedJson)
                    
                    print("______________________prodGroup_______________")
                   
                    
             
                    

             
                }
            case .failure(let error):
                print(error)
            }
        }
}


func prodTypes(completi: @escaping (String) -> Void) {
    let axn = "get/prodTypes"
  
    let apiKey = "\(axn)"
    
    let aFormData: [String: Any] = [
        "CusID":"9","Stk":"3"
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
                    completi(prettyPrintedJson)
                    print("______________________prodTypes_______________")
                    
             
                    

             
                }
            case .failure(let error):
                print(error)
            }
        }
    
}


func prodCate(prodcatedata: @escaping (String) -> Void) {
    let axn = "get/prodCate"
    //url = http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/prodGroup
  
    let apiKey = "\(axn)"
    
    let aFormData: [String: Any] = [
        "CusID":"9","Stk":"3"
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
                    prodcatedata(prettyPrintedJson)
                   
                    print("______________________prodCate_______________")
             
                    

             
                }
            case .failure(let error):
                print(error)
            }
        }
    
}


func prodDets(proddetsdata: @escaping (String) -> Void) {
    let axn = "get/prodDets"
    //url = http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/prodGroup
  
    let apiKey = "\(axn)"
    
    let aFormData: [String: Any] = [
        "CusID":"9","Stk":"3"
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
                    proddetsdata(prettyPrintedJson)
                    print("______________________prodDets_______________")
             
                    
             
                    

             
                }
            case .failure(let error):
                print(error)
            }
        }
    
}


