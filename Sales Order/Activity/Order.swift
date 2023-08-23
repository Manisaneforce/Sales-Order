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
}
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
    @State private var FilterProduct:[AnyObject]=[]

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
                                                        FilterProduct = itemsWithTypID3.map { $0 as AnyObject }
                                                        if let procat = item["PImage"] as? String, let proname = item["name"] as? String ,  let MRP = item["Rate"] as? String, let Proid = item["ERP_Code"] as? String,let sUoms = item["Division_Code"] as? Int, let sUomNms = item["Default_UOMQty"] as? String{
                                                            print(procat)
                                                            print(proname)
                                                            print(sUoms)
                                                            print(sUomNms)
                                                            
                                                            Allprod.append(Prodata(ImgURL: procat, ProName: proname, ProID: Proid, ProMRP:MRP,sUoms:sUoms,sUomNms:sUomNms ))
                                                            
                                                            
                                                            
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
                                        //                    SEF11426
                                        //                    241
                                        //                    PIECE
                                        //                    1
                                        //
                                        //                    1
                                        //                    1
                                        //                    ["OrdConv": 1, "product_netwt": , "Product_Type_Code": R, "id": SEF11426, "cateid": 1658, "OrdConvSec": 1, "Product_Description": w, "Default_UOM": <null>, "Product_Sale_Unit": PIECE, "Code": 13135, "Product_Image": 5e74c374c485400e59249483.webp, "name": Oreo, "product_unit": PIECE, "Default_UOMQty": <null>, "Base_Unit_code": 241, "pSlNo": 11426, "HSN": , "Unit_code": 441, "Division_Code": 29, "conversionQty": 10]
                                        
                                        
                                        let proditem = Allprod[index]
                                        print(proditem)
                                        let id = proditem.ProID
                                        
                                        let selectproduct = $FilterProduct[index] as? AnyObject
                                        print(selectproduct as Any)
                                        let  sUom = String(proditem.sUoms)
                                        let sUomNm = ""
                                        let sUomConv = proditem.sUomNms
                                        let sNetUnt = ""
                                        let  sQty = String(numbers[index])
                                        print(sQty)
                                        
                                        
                                        updateQty(id: id, sUom: sUom, sUomNm: sUomNm, sUomConv: "gfg", sNetUnt: "reg", sQty: sQty, ProdItem: selectproduct as Any, refresh: 1)
                                        
                                        
                                        
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
                            Text("Qty : 10")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            
                            
                        }
                        HStack{
                            
                            Text("\(Image(systemName: "indianrupeesign"))10000")
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
    
    func updateQty(id: String,sUom: String,sUomNm: String,sUomConv: String,sNetUnt: String,sQty: String,ProdItem:Any,refresh: Int){
        
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
        
//        let Schemes: [AnyObject] = lstSchemList.filter ({ (item) in
//            if item["PCode"] as! String == id && (item["Scheme"] as! NSString).doubleValue <= TotQty {
//                return true
//            }
//            return false
//        })
        let Scheme: Double = 0
        let FQ : Int32 = 0
        let OffQty: Int = 0
        let OffProd: String = ""
        let OffProdNm: String = ""
        let Rate: Double = 0
        let Schmval: String = ""
        let Disc: String = ""
        
//        let RateItems: [AnyObject] = lstRateList.filter ({ (Rate) in
//
//            if Rate["Product_Detail_Code"] as! String == id {
//                return true
//            }
//            return false
//        })
//        if(RateItems.count>0){
//            Rate = (RateItems[0]["Retailor_Price"] as! NSString).doubleValue
//        }
       var ItmValue: Double = (TotQty*Rate)
//        if(Schemes.count>0){
//            Scheme = (Schemes[0]["Scheme"] as! NSString).doubleValue
//            FQ = (Schemes[0]["FQ"] as! NSString).intValue
//            let SchmQty: Double
//            if(Schemes[0]["pkg"] as! String == "Y"){
//                SchmQty=Double(Int(TotQty / Scheme))
//            } else {
//                SchmQty = (TotQty / Scheme)
//            }
//            OffQty = Int(SchmQty * Double(FQ))
//            OffProd = Schemes[0]["OffProd"] as! String
//            OffProdNm = Schemes[0]["OffProdNm"] as! String
//
//            var dis: Double = 0;
//            Disc = Schemes[0]["Disc"] as! String
//            if (Disc != "") {
//                dis = ItmValue * (Double(Disc)! / 100);
//            }
//            Schmval = String(format: "%.02f", dis);
//            ItmValue = ItmValue - dis;
//        }
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
       // updateOrderValues(refresh: refresh)
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



struct SelPrvOrder: View {
    @State private var OrderNavigte:Bool = false
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
            }
            .edgesIgnoringSafeArea(.top)
            
//            HStack{
//                Image("logo_new")
//                    .resizable()
//            }
            
            
           Spacer()
            ZStack{
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(height: 100)
                
                Button(action: {
                                
                }) {
                    //                                  Text("Submit")
                    //                                      .foregroundColor(Color.white)
                    //                                      .frame(maxWidth: .infinity)
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
                        
                        Text("\(Image(systemName: "indianrupeesign"))000")
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


//Button(action: {
//    SelPrvOrderNavigte = true
//
//}) {
//    ZStack(alignment: .top) {
//        Rectangle()
//            .foregroundColor(Color.blue)
//            .frame(height: 70)
//
//
//        HStack {
//
//            Image(systemName: "cart.fill")
//                .foregroundColor(.white)
//                .font(.system(size: 30))
//                .frame(width: 60,height: 40)
//
//            Text("Item: \(VisitData.shared.ProductCart.count)")
//                .font(.system(size: 14))
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//            Text("Qty : 10")
//                .font(.system(size: 14))
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//            Spacer()
//
//
//        }
//        HStack{
//
//            Text("\(Image(systemName: "indianrupeesign"))10000")
//                .font(.system(size: 15))
//                .fontWeight(.heavy)
//                .foregroundColor(.white)
//                .offset(x:30)
//
//            Spacer()
//
//            Text("PROCEED")
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .font(.system(size: 17))
//                .multilineTextAlignment(.center)
//                .offset(x:-40,y:-10)
//
//
//        }
//        .offset(y:40)
//
//    }
//    //.cornerRadius(5)
//    .edgesIgnoringSafeArea(.bottom)
//    .frame(maxWidth: .infinity)
//    .padding(.bottom, -(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 ))
//}
