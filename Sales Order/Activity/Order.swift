//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI
import Alamofire

struct Prodata: Any {
    let ImgURL:String
    let ProName :String
    let ProID : String
    let ProMRP : String
    let sUoms : Int
    let sUomNms : String
    let Unit_Typ_Product: [String : Any]
}
var lstPrvOrder: [AnyObject] = []
var lblTotAmt:String = ""
struct Order: View {
    @State private var number = 0
    @State private var inputNumberString = ""
    @State private var Arry = [String]()
    @State private var nubers = [15,555,554,54]
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
    @State private var prettyPrintedJson: String = ""
    @State private var prodTypes2 = [String]()
    @State private var prodTypes3 = [Int]()
    @State private var prodofcat = [String]()
    @State private var prodCate: String = ""
    @State private var selectedIndices: Set<Int> = []
    @State private var selectedIndex: Int? = nil
    @State private var SelectId:Int = 0
    @State private var ProSelectID:Int = 0
    @State private var proDetsID = [Int]()
    @State private var  imgdataURL = [String]()
    @State private var uiImage: UIImage? = nil
    @State private var Allproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
    @State private var FilterProduct = [AnyObject]()

    @State private var Allprod:[Prodata]=[]
    @State private var numbers: [Int] = []
    @State private var SelPrvOrderNavigte:Bool = false
    init() {
          // Initialize the 'numbers' array with the same count as 'Allprod'
          self._numbers = State(initialValue: Array(repeating: 0, count: 5))
      }
    
    
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
                //.cornerRadius(5)
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                
                VStack(alignment: .leading, spacing: 6) {
                    
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
                        .frame(width: 80,height: 25)
                        .foregroundColor(Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(prodTypes2.indices, id: \.self) { index in
                                Button(action: {
                                    prodofcat.removeAll()
                                    proDetsID.removeAll()
                                    Allprod.removeAll()
                                    if selectedIndex == index {
                                        selectedIndex = nil
                                    } else {
                                        selectedIndex = index
                                    }
                                    print("Clicked button at index: \(index)")
                                    SelectId = prodTypes3[index]
                                    print(SelectId)
                                    Sales_Order.prodCate { json in
                                        print(json)
                                        if let jsonData = json.data(using: .utf8) {
                                            do {
                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                    print(jsonArray)
                                                    print(SelectId)
                                                    
                                                    
                                                    let itemsWithTypID3 = jsonArray.filter { ($0["TypID"] as? Int) == SelectId }
                                                    
                                                    if !itemsWithTypID3.isEmpty {
                                                        for item in itemsWithTypID3 {
                                                            print(itemsWithTypID3)
                                                            if let procat = item["name"] as? String, let proDetID = item["id"] as? Int {
                                                                print(procat)
                                                                
                                                                prodofcat.append(procat)
                                                                proDetsID.append(proDetID)
                                                                print(proDetsID)
                                                                
                                                            }
                                                        }
                                                    } else {
                                                        print("No data with TypID \(SelectId)")
                                                    }
                                                    
                                                }
                                            } catch {
                                                print("Error is \(error)")
                                            }
                                        }
                                    }
                                    
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
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(prodofcat.indices, id: \.self) { index in
                                Button(action:{
                                    imgdataURL.removeAll()
                                    Arry.removeAll()
                                    Allprod.removeAll()
                                    print("If Select data")
                                    ProSelectID = proDetsID[index]
                                    print(ProSelectID)
                                    print(Allproddata)
                                    if let jsonData = Allproddata.data(using: .utf8){
                                        do{
                                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                print(jsonArray)
                                                let itemsWithTypID3 = jsonArray.filter { ($0["Product_Cat_Code"] as? Int) == ProSelectID }
                                                
                                                if !itemsWithTypID3.isEmpty {
                                                    for item in itemsWithTypID3 {
                                                        print(itemsWithTypID3)
                                                       // FilterProduct = itemsWithTypID3.map { $0 as AnyObject }
                                                        FilterProduct = itemsWithTypID3  as [AnyObject]
                                                        if let procat = item["PImage"] as? String, let proname = item["name"] as? String ,  let MRP = item["Rate"] as? String, let Proid = item["ERP_Code"] as? String,let sUoms = item["Division_Code"] as? Int, let sUomNms = item["Default_UOMQty"] as? String{
                                                            print(procat)
                                                            print(proname)
                                                            print(sUoms)
                                                            print(sUomNms)
                                                            
                                                            Allprod.append(Prodata(ImgURL: procat, ProName: proname, ProID: Proid, ProMRP:MRP,sUoms:sUoms,sUomNms:sUomNms, Unit_Typ_Product: item ))
                                                            
                                                            
                                                            
                                                            let  inputText = procat.trimmingCharacters(in: .whitespacesAndNewlines)
                                                            imgdataURL.append(inputText)
                                                            Arry.append(proname)
                                                            print(imgdataURL)
                                                            
                                                            
                                                        }
                                                    }
                                                } else {
                                                    print("No data with TypID \(SelectId)")
                                                }
                                                print(imgdataURL)
                                                print(Arry)
                                                print(Allprod.count)
                                            }
                                        } catch{
                                            print("Data is error\(error)")
                                        }
                                    }
                                    
                                    
                                }) {
                                    Text(prodofcat[index])
                                        .font(.system(size: 15))
                                        .frame(width: 150,height: 25)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 7)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                    
                }
                .padding(.top,0)
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
                                    var Typofid = [Int]()
                                    for item in jsonArray {
                                        if let textName = item["name"] as? String , let typid = item["id"] as? Int {
                                            prodTypes1.append(textName)
                                            Typofid.append(typid)
                                        }
                                    }
                                    print(prodTypes1)
                                    print(Typofid)
                                    prodTypes2 = prodTypes1
                                    prodTypes3 = Typofid
                                    print(json)
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }
                    Sales_Order.prodDets{
                        json in
                        print(json)
                    }
                    
                    
                }
                
                //NavigationView {
                
                List(0 ..< Allprod.count, id: \.self) { index in
                    HStack {
                        if let uiImage = uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 70)
                                .cornerRadius(4)
                        } else {
                            Text("Image loading...")
                                .onAppear{ loadImage(at: index) }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            // Text(Arry[index])
                            Text(Allprod[index].ProName)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text(Allprod[index].ProID)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                //Text("MRP ₹\(nubers[index])")
                                Text("MRP 0")
                                Spacer()
                                Text("Price: \(Allprod[index].ProMRP)")
                            }
                            HStack {
                                //                                NavigationLink(destination: ExtractedView()) {
                                //
                                //
                                //                                    Button(action: {
                                //
                                //                                    }) {
                                Text("Pipette")
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                                //                                    }
                                //                                }
                                
                                Spacer()
                                HStack {
                                    Button(action: {
                                        self.decrementNumber(at: index)
                                        let proditem = Allprod[index]
                                        print(proditem)
                                        let FilterProduct = Allprod[index].Unit_Typ_Product
                                        print(FilterProduct)
                                        let id = proditem.ProID
                                        
                                        let selectproduct = $FilterProduct[index] as? AnyObject
                                        print(selectproduct as Any)
                                        let  sQty = String(numbers[index])
                                        print(sQty)
                                        minusQty(sQty: sQty, SelectProd: FilterProduct)
                                        
                                    }) {
                                        Text("-")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Text("\(numbers[index])")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                    
                                    Button(action: {
                                        self.incrementNumber(at: index)
                            
                                        let proditem = Allprod[index]
                                        print(proditem)
                                        let FilterProduct = Allprod[index].Unit_Typ_Product
                                        print(FilterProduct)
                                        
                                        let selectproduct = $FilterProduct[index] as? AnyObject
                                        print(selectproduct as Any)
                                        let  sQty = String(numbers[index])
                                        print(sQty)
                        addQty(sQty: sQty, SelectProd: FilterProduct)
                                        
                                    }) {
                                        Text("+")                                             .font(.headline)
                                            .fontWeight(.bold)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5),lineWidth: 1)
                            .shadow(color: Color.gray, radius:2 , x:0,y:0)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .frame(width: 350)
                    
                }
                .listStyle(PlainListStyle())
                .padding(.vertical, 5)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                
                //.frame(width: 365)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                
                .clipped()
                .shadow(color: Color.gray, radius:3 , x:0,y:0)
                
                .padding(.top,10)
                //                .onAppear{
                //                    UIScrollView.appearance().showsVerticalScrollIndicator = false
                //                }
               
                
                Button(action: {
                    SelPrvOrderNavigte = true
                    
                }) {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .foregroundColor(Color.blue)
                            .frame(height: 70)
                        
                        
                        HStack {
                            
                            Image(systemName: "cart.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                                .frame(width: 60,height: 40)
                            
                            Text("Item: \(VisitData.shared.ProductCart.count)")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Qty : 0")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            
                            
                        }
                        HStack{
                            
                            Text("\(Image(systemName: "indianrupeesign"))\(lblTotAmt)")
                                .font(.system(size: 15))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .offset(x:30)
                            
                            Spacer()
                            
                            Text("PROCEED")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                                .multilineTextAlignment(.center)
                                .offset(x:-40,y:-10)
                            
                            
                        }
                        .offset(y:40)
                        
                    }
                    //.cornerRadius(5)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, -(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 ))
                }
         
                NavigationLink(destination: SelPrvOrder(), isActive: $SelPrvOrderNavigte) {
                    EmptyView()
                }
                
            }
            .padding(.top, 10)
            
           
            
        }
        .navigationBarHidden(true)
       
    }
    private func incrementNumber(at index: Int) {
        numbers[index] += 1
        
    }
    
    private func decrementNumber(at index: Int) {
        if numbers[index] > 0 {
            numbers[index] -= 1
        }
    }
    
    private func loadImage(at index : Int) {
        if let imageUrl = URL(string: Allprod[index].ImgURL) {
               URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                   if let data = data, let uiImage = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self.uiImage = uiImage
                       }
                   }
               }.resume()
           }
       }
    

    
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
        SelPrvOrder()
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
                   let Allproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
                    if !Allproddata.isEmpty {
                       
                        UserDefaults.standard.set(prettyPrintedJson, forKey: "Allproddata")
                    }
                   // UserDefaults.standard.set(prettyPrintedJson, forKey: "Allproddata")
                    proddetsdata(prettyPrintedJson)
                    print("______________________prodDets_______________")
             
                }
            case .failure(let error):
                print(error)
            }
        }
    
}


struct PrvProddata: Any {
    let ImgURL:String
    let ProName :String
    let ProID : String
    let ProMRP : String
}

struct FilterItem: Identifiable {
    let id: Int
    var quantity: Int
}

var LstAllproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
var selectitemCount:Int = 0
struct SelPrvOrder: View {
    @State private var OrderNavigte:Bool = false
    @State private var Allproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
    @State private var FilterItem = [[String: Any]]()
    @State private var AllPrvprod:[PrvProddata]=[]
    @State var filterItems: [FilterItem] = []
    
    init() {
        var items: [FilterItem] = []
        print(selectitemCount)
        for index in 0..<selectitemCount {
            items.append(Sales_Order.FilterItem(id: index, quantity: 0))
        }
        self._filterItems = State(initialValue: items)
    }

   
    var body: some View {
        VStack{
            VStack(spacing:10){
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(height: 100)
                    
                    HStack {
                        
                        Text(" Selected Order Prv")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .offset(x: -20)
                    }
                }
                .frame(maxWidth: .infinity)
                
                
                HStack(spacing: 200){
                    Text("Items")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    Button(action:{
                        OrderNavigte = true
                    }){
                        Text("+ Add Product")
                            .foregroundColor(Color.orange)
                        
                    }
                }
                .onAppear{
                    print(lstPrvOrder)
                    var ProSelectID = [String]()
                    for itemID in lstPrvOrder{
                        let id =  itemID["id"] as! String
                        ProSelectID.append(id)
                    }
                    print(ProSelectID)
                    print(Allproddata)
                    if let jsonData = Allproddata.data(using: .utf8) {
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                print(jsonArray)
                                for RelID in ProSelectID {
                                    if let selectedPro = jsonArray.first(where: { ($0["ERP_Code"] as! String) == RelID }) {
                                        FilterItem.append(selectedPro)
                                    }
                                }
                                
                            }
                        } catch {
                            print("Error is \(error)")
                        }
                        print(FilterItem)
                        
                        print(FilterItem)
                                             for PrvProd in FilterItem{
                                                 
                                                 let url = PrvProd["PImage"] as? String
                                                 let name  = PrvProd["name"] as? String
                                                 let Proid = PrvProd["ERP_Code"] as? String
                                                 let rate = PrvProd["Rate"] as? String
                                                 AllPrvprod.append(PrvProddata(ImgURL: url!, ProName: name!, ProID: Proid!, ProMRP: rate!))
                                         }
                                             print(AllPrvprod)
                        
                        
                    }
                    
                }
                
                Divider()
                List(0 ..< FilterItem.count, id: \.self) { index in
                    HStack {
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 70)
                            .cornerRadius(4)
                        
                        VStack {
                            HStack(spacing: 120) {
                                Text(AllPrvprod[index].ProName)
                                Button(action: {
                                    deleteItem(at: index)
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(Color.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack(spacing: 60) {
                                Text("Rs: \(AllPrvprod[index].ProMRP)")
                                
                                HStack {
                                    Button(action: {
                                        if filterItems[index].quantity > 0 {
                                               filterItems[index].quantity -= 1
                                           }
                                    }) {
                                        Text("-")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Text("\(filterItems[index].quantity)")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                    
                                    Button(action: {
                                        filterItems[index].quantity += 1
                                    }) {
                                        Text("+")
                                            .font(.headline)
                                            .fontWeight(.bold)
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
                            
                            Divider()
                            
                            HStack(spacing: 100) {
                                Text("Total")
                                Text("₹00.00")
                            }
                        }
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5),lineWidth: 1)
                            .shadow(color: Color.gray, radius:2 , x:0,y:0)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .frame(width: 350)
                }
                .listStyle(PlainListStyle())
                .padding(.vertical, 5)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                
                //.frame(width: 365)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                
                .clipped()
                .shadow(color: Color.gray, radius:3 , x:0,y:0)
                

                
                
            }
            .edgesIgnoringSafeArea(.top)
            
      
            
           Spacer()
            ZStack{
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(height: 100)
                
                Button(action: {
                    OrderSubmit()
                    
                    
                }) {
                  
                    VStack(spacing:-1){
                    HStack (){
                        
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .frame(width: 60,height: 40)
                        
                        Text("Item: \(VisitData.shared.ProductCart.count)")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Qty : 0")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                    }
                    HStack(spacing: 200){
                        
                        Text("\(Image(systemName: "indianrupeesign"))\(lblTotAmt)")
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .offset(x:30)
                        
                       
                        
                        Text("Submite")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                            .multilineTextAlignment(.center)
                            .offset(x:-40,y:-10)
                        
                        
                    }
                        Spacer()
                }
                              }
            }
            .frame(maxWidth: .infinity,maxHeight: 40 )
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, -(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 ))
            
            NavigationLink(destination: Order(), isActive: $OrderNavigte) {
                EmptyView()
            }
        }
      
       
    }
  
}


func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:[String:Any],refresh: Int){
    
    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({(item) in
        if item["id"] as! String == id {
            return true
        }
        return false
    })
    print(id)
    print(sUom)
    print(sUomNm)
    print(sUomConv)
    print(sNetUnt)
    print(sQty)
    print(refresh)
    print(ProdItem)
    let TotQty: Double = Double((sQty as NSString).intValue * (sUomConv as NSString).intValue)
    print(TotQty)
    let source: String = (ProdItem["Rate"] as? String)!
    let Rate: Double = Double(source)!
    print(Rate)
    let ItmValue: Double = (TotQty*Rate)
    print(ItmValue)
    
    
    let Scheme: Double = 0
    let FQ : Int32 = 0
    let OffQty: Int = 0
    let OffProd: String = ""
    let OffProdNm: String = ""
    let Schmval: String = ""
    let Disc: String = ""
    
   

    if items.count>0 {
        print(VisitData.shared.ProductCart)
        if let i = VisitData.shared.ProductCart.firstIndex(where: { (item) in
            if item["id"] as! String == id {
                return true
            }
            return false
        })
        {

            let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm,"Rate": Rate,"Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": ItmValue];
            let jitm: AnyObject = itm as AnyObject
            VisitData.shared.ProductCart[i] = jitm
            print("\(VisitData.shared.ProductCart[i]) starts with 'A'!")
        }
    }else{
        let itm: [String: Any]=["id": id,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Rate": Rate, "Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": ItmValue];
        let jitm: AnyObject = itm as AnyObject
        print(itm)
        VisitData.shared.ProductCart.append(jitm)
      
        
    }
    print(VisitData.shared.ProductCart)
    lstPrvOrder = VisitData.shared.ProductCart
    selectitemCount = lstPrvOrder.count
    updateOrderValues(refresh: 1)
}


func addQty(sQty:String,SelectProd:[String:Any]) {
    
    print(sQty)
    print(SelectProd)
  
    let Ids = SelectProd["ERP_Code"] as? String
    print(Ids as Any)

      let  selUOM=String(format: "%@", SelectProd["Division_Code"] as! CVarArg)
        print(selUOM)
     let   selUOMNm=String(format: "%@", SelectProd["Product_Sale_Unit"] as! CVarArg)
        print(selUOMNm)
      let  selUOMConv=String(format: "%@", SelectProd["OrdConvSec"] as! CVarArg)
        print(selUOMConv)
      // let selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
    let selNetWt = ""
        print(selNetWt)


    updateQty(id: Ids!, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: SelectProd,refresh: 1)

}

 func minusQty(sQty:String,SelectProd:[String:Any]) {
     print(sQty)
     print(SelectProd)
   
     let Ids = SelectProd["ERP_Code"] as? String
     print(Ids as Any)

       let  selUOM=String(format: "%@", SelectProd["Division_Code"] as! CVarArg)
         print(selUOM)
      let   selUOMNm=String(format: "%@", SelectProd["Product_Sale_Unit"] as! CVarArg)
         print(selUOMNm)
       let  selUOMConv=String(format: "%@", SelectProd["OrdConvSec"] as! CVarArg)
         print(selUOMConv)
       // let selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
     let selNetWt = ""
         print(selNetWt)


     updateQty(id: Ids!, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: SelectProd,refresh: 1)
}



func updateOrderValues(refresh:Int){
    var totAmt: Double = 0
    print(lstPrvOrder)
    
   lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
        print(lstPrvOrder)
        if (Cart["SalQty"] as! Double) > 0 {
            print(Cart["SalQty"] as! Double)
            return true
        }
        return false
    })
    if lstPrvOrder.count>0 {
        for i in 0...lstPrvOrder.count-1 {
            let item: AnyObject = lstPrvOrder[i]
            totAmt = totAmt + (item["NetVal"] as! Double)
            //(item["SalQty"] as! NSString).doubleValue

        }
    }
  //  lblTotAmt = String(format: "Rs. %.02f", totAmt)
    lblTotAmt = String(totAmt)
    print(totAmt)
    if(refresh == 1){
     
    }

}
func deleteItem(at index: Int) {
    print(lstPrvOrder)
    print(VisitData.shared.ProductCart)
    var ids = [String]()
    var id = ""
    for allid in lstPrvOrder{
        ids.append(allid["id"] as! String)
    }
    id = ids[index]
    print(ids)
    print(id)
    //let id=lstPrvOrder["id"] as! String
    
    
    
    lstPrvOrder.remove(at: index)
    VisitData.shared.ProductCart.removeAll(where: { (item) in
        if item["id"] as! String == id {
            return true
        }
        return false
    })
    print(lstPrvOrder)
    print(VisitData.shared.ProductCart)
    updateOrderValues(refresh: 1)
}

func OrderSubmit() {
    print(lstPrvOrder)
//    var sPItems:String = ""
//    for i in 0..<lstPrvOrder.count {
//        guard let item = lstPrvOrder[i] as? [String: Any],
//              let id = item["id"] as? String else {
//            continue
//        }
//
//        var prodItems: [[String: Any]] = []
//
//        if let jsonData = LstAllproddata.data(using: .utf8) {
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
//                    prodItems = jsonArray.filter { product in
//                        if let prodId = product["ERP_Code"] as? String {
//                            return prodId == id
//                        }
//                        return false
//                    }
//                }
//            } catch {
//                print("Error is \(error)")
//            }
//        }
//        print(item)
//        let disc: String = item["Disc"] as? String ?? "0"
//        let disVal: String = item["DisVal"] as? String ?? "0"
//
//        let productQty = item["OffQty"] as? Int ?? 0
//        let productCode = prodItems.isEmpty ? "" : (prodItems[0]["id"] as? String ?? "")
//        print(prodItems)
//        let productName = prodItems.isEmpty ? "" : (prodItems[0]["name"] as? String ?? "")
//
//                   sPItems = sPItems + "{\"product_code\":\""+productCode+"\", \"product_Name\":\""+productName+"\","
//                   sPItems = sPItems + " \"Product_Rx_Qty\":" + (String(format: "%.0f", item["SalQty"] as? Double ?? 0.0)) + ","
//                   sPItems = sPItems + " \"Product_Total_Qty\": \"1\","
//                   sPItems = sPItems + " \"Product_Amount\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
//                   sPItems = sPItems + " \"Rate\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
//                   sPItems = sPItems + " \"free\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
//                   sPItems = sPItems + " \"dis\": " + (String(format: "%.2f", item["Rate"] as! Double)) + ","
//                   sPItems = sPItems + " \"dis_value\":\""+productQty+"\","
//                   sPItems = sPItems + " \"Off_Pro_code\":\"\","
//                   sPItems = sPItems + " \"Off_Pro_name\":\"\","
//                   sPItems = sPItems + " \"Off_Pro_Unit\":\"\","
//                   sPItems = sPItems + " \"discount_type\":\"\","
//                   sPItems = sPItems + " \"ConversionFactor\":" + (item["UOMConv"] as! String) + ","
//                   sPItems = sPItems + " \"UOM_Id\": \"2\","
//                   sPItems = sPItems + " \"UOM_Nm\": \"Pipette\","
//                   sPItems = sPItems + " \"TAX_details\": \"[{\","
//                   sPItems = sPItems + " \"Tax_Id\": \"1\","
//                   sPItems = sPItems + " \"Tax_Val\": 12,"
//                   sPItems = sPItems + " \"Tax_Type\": \"GST 12%\","
//                   sPItems = sPItems + " \"Tax_Amt\": 23.64,}],}”
//
//
//    }

let jsonString =  "[{\"Activity_Report_APP\":{\"Worktype_code\":\"0\",\"Town_code\":\"\",\"dcr_activity_date\":\"2023-08-26 10:58:12\",\"Daywise_Remarks\":\"\",\"UKey\":\"EKSf_Code654147271\",\"orderValue\":\"524.24\",\"billingAddress\":\"Borivali\",\"shippingAddress\":\"Borivali\",\"DataSF\":\"96\",\"AppVer\":\"1.2\"},\"Activity_Doctor_Report\":{\"Doc_Meet_Time\":\"2023-08-26 10:58:12\",\"modified_time\":\"2023-08-26 10:58:12\",\"stockist_code\":\"3\",\"stockist_name\":\"Relivet Animal Health\",\"orderValue\":\"524.24\",\"CashDiscount\":0,\"NetAmount\":\"524.24\",\"No_Of_items\":\"2\",\"Invoice_Flag\":\"\",\"TransSlNo\":\"\",\"doctor_code\":\"96\",\"doctor_name\":\"Kartik Test\",\"ordertype\":\"order\",\"deliveryDate\":\"\",\"category_type\":\"\",\"Lat\":\"13.029959\",\"Long\":\"80.2414085\",\"TOT_TAX_details\":[{\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"56.17\"}]},\"Order_Details\":[{\"product_Name\":\"FiproRel- S Dog 0.67 ml\",\"product_code\":\"D111\",\"Product_Qty\":1,\"Product_RegularQty\":0,\"Product_Total_Qty\":1,\"Product_Amount\":220.64,\"Rate\":\"197.00\",\"free\":\"0\",\"dis\":0,\"dis_value\":\"0.00\",\"Off_Pro_code\":\"\",\"Off_Pro_name\":\"\",\"Off_Pro_Unit\":\"\",\"discount_type\":\"\",\"ConversionFactor\":1,\"UOM_Id\":\"2\",\"UOM_Nm\":\"Pipette\",\"TAX_details\":[{\"Tax_Id\":\"1\",\"Tax_Val\":12,\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"23.64\"}]},{\"product_Name\":\"FiproRel - S Dog 1.34 ml\",\"product_code\":\"D112\",\"Product_Qty\":1,\"Product_RegularQty\":0,\"Product_Total_Qty\":1,\"Product_Amount\":303.6,\"Rate\":\"271.07\",\"free\":\"0\",\"dis\":0,\"dis_value\":\"0.00\",\"Off_Pro_code\":\"\",\"Off_Pro_name\":\"\",\"Off_Pro_Unit\":\"\",\"discount_type\":\"\",\"ConversionFactor\":1,\"UOM_Id\":\"2\",\"UOM_Nm\":\"Pipette\",\"TAX_details\":[{\"Tax_Id\":\"1\",\"Tax_Val\":12,\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"32.53\"}]}]}]"
    
    let params: Parameters = [
        "data": jsonString
    ]
    
    print(params)
    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"save/salescalls"+"&divisionCode=227"+"&Sf_code=96", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
    AFdata in
    switch AFdata.result
    {
        
    case .success(let value):
        print(value)
        if let json = value as? [String: Any] {
            
           print(json)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            VisitData.shared.clear()
        }
        
    case .failure(let error):
        
        let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
            return
        })
        //self.present(alert, animated: true)
    }
}
    
  
}

