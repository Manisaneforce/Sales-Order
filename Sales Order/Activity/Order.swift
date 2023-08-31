//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI
import Alamofire
import CoreLocation

struct Prodata: Any {
    let ImgURL:String
    let ProName :String
    let ProID : String
    let ProMRP : String
    let sUoms : Int
    let sUomNms : String
    let Uomname : String
    let Unit_Typ_Product: [String : Any]
}
struct Uomtyp: Any{
    let UomName:String
    let UomConv:String
}

struct TotAmt: Identifiable {
    let id: Int
    var Amt: Int
    var TotAmt:String
}

var lstPrvOrder: [AnyObject] = []
var lblTotAmt:String = "00.0"
var TotamtlistShow:String = ""
var selUOM: String = ""
var selUOMNm: String = ""
var currentDateTime = ""
struct Order: View {
    @State private var clickeindex:Int = 0
    @State private var IndexToAmt:String = ""
    @State private var lblSelTitle = 0
    @State private var SelMode: String = ""
    @State private var SelectItem = ""
    @State private var number = 0
    @State private var inputNumberString = ""
    @State private var Arry = [String]()
    @State private var nubers = [15,555,554,54]
    @State private var isPopupVisible = false
    @State private var selectedItem: String = ""
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
    @State private var allUomlist:[Uomtyp]=[]
    @State private var numbers: [Int] = []
    @State private var SelPrvOrderNavigte:Bool = false
    @State private var isShowingPopUp = false
    @State private var showAlert = false
    @State private var showToast = false
    @State private var ShowTost = ""
    @State private var navigateToHomepage = false
    @State private var filterItems: [TotAmt] = []
    init() {
        
        var items: [TotAmt] = []
        print(FilterProduct.count)
        for index in 0..<5 {
            print(index)
            items.append(Sales_Order.TotAmt(id: index, Amt: 0, TotAmt: "0"))
        }
        self._filterItems = State(initialValue: items)
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
            VStack(spacing: 0) {
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(height: 80)
                    
                    HStack {
                        Button(action: {
                            showAlert = true
                        })
                        {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                        
                        .offset(x: -120, y: 25)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Do you want cancel this order dreaft"),
                                primaryButton: .default(Text("OK")) {
                                    navigateToHomepage = true
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        NavigationLink(destination: HomePage(), isActive: $navigateToHomepage) {
                                        EmptyView()
                                    }
                        
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
                    VStack(spacing:5){
                        Text("DR. INGOLE")
                            .font(.system(size: 15))
                            .offset(x:-25)
                        HStack {
                            //                            Image("SubmittedCalls")
                            //                                .resizable()
                            //                                .frame(width: 20, height: 20)
                            //                                .background(Color.blue)
                            //                                .cornerRadius(10)
                            Text("9923125671")
                                .font(.system(size: 15))
                                .offset(x:-25)
                        }
                        Text("Shivaji Park, Dadar")
                        //.font(.system(size: 15))
                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                        .frame(height: 10)
                    Text(prettyPrintedJson)
                        .font(.system(size: 15))
                        .frame(width: 80,height: 25)
                        .foregroundColor(Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal, 12)
                    
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
                                    self.OrderprodCate(at: index)
                                    
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
                        .padding(.horizontal, 10)
                        
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
                                    print("Clicked button at index: \(index)")
                                    self.OrderprodDets(at: index)
                                    
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
                    .padding(.horizontal, 10)
             
                    
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
                        self.OrderprodCate(at: 0)
                    }
                    
                    Sales_Order.prodDets{
                        json in
                        print(json)
                    }
                    
                    
                }
                
                //NavigationView {
                
                List(0 ..< Allprod.count, id: \.self) { index in
                    if #available(iOS 15.0, *) {
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
                                        VStack{
                                            Text(Allprod[index].Uomname)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 20)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .onTapGesture {
                                                    clickeindex=index
                                                    allUomlist.removeAll()
                                                    isShowingPopUp.toggle()
                                                  let FilterUnite =  FilterProduct[index]
                                                    print(FilterUnite)
                                        
                                                    if let uomLists = FilterUnite["UOMList"] as? [[String: Any]] {
                                                        print(uomLists)
                                                        self.lstOfUnitList(at: index, filterUnite: uomLists)
                                                      } else {
                                                          print("UOMList not found or not in the expected format.")
                                                      }
                                                
                                                }
                                        }
                                    
                                    
                                    
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            if filterItems[index].Amt > 0 {
                                                filterItems[index].Amt -= 1
                                            }
                                            let proditem = Allprod[index]
                                            print(proditem)
                                            let FilterProduct = Allprod[index].Unit_Typ_Product
                                            print(FilterProduct)
                                            let id = proditem.ProID
                                            
                                            let selectproduct = $FilterProduct[index] as? AnyObject
                                            print(selectproduct as Any)
                                            let  sQty = String(filterItems[index].Amt)
                                            print(sQty)
                                            print(Allprod[index].ProID)

                                            let Ids = Allprod[index].ProID
                                            print(Ids as Any)

                                            let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in

                                                if (Cart["id"] as! String) == Ids {
                                                    return true
                                                }
                                                return false
                                            })
                                            var selUOMConv: String = "1"

                                            if(items.count>0){
                                                selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                                               let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                let TotalAmount = Double(Allprod[index].ProMRP)! * Double(uom)
                                                filterItems[index].TotAmt=String(TotalAmount)
                                            } else{

                                              selUOMConv=String(filterItems[index].Amt)
                                              print(selUOMConv)
                                                let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                 let TotalAmount = Double(Allprod[index].ProMRP)! * Double(uom)
                                                filterItems[index].TotAmt=String(TotalAmount)
                                          }
                                            minusQty(sQty: sQty, SelectProd: FilterProduct)
                                            
                                        }) {
                                            Text("-")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        Text("\(filterItems[index].Amt)")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.black)
                                        
                                        Button(action: {
                                            filterItems[index].Amt += 1
                                            print(lstPrvOrder)
                                            
                                            
                                            let proditem = Allprod[index]
                                            print(proditem)
                                            let FilterProduct = Allprod[index].Unit_Typ_Product
                                            print(FilterProduct)
                                            
                                            let selectproduct = $FilterProduct[index] as? AnyObject
                                            print(selectproduct as Any)
                                            let  sQty = String(filterItems[index].Amt)
                                            print(sQty)
                                            
                                            print(Allprod[index].ProID)

                                            let Ids = Allprod[index].ProID
                                            print(Ids as Any)

                                            let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in

                                                if (Cart["id"] as! String) == Ids {
                                                    return true
                                                }
                                                return false
                                            })
                                            var selUOMConv: String = "1"

                                            if(items.count>0){
                                                selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                                               let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                let TotalAmount = Double(Allprod[index].ProMRP)! * Double(uom)
                                                filterItems[index].TotAmt=String(TotalAmount)
                                            } else{

                                              selUOMConv=String(filterItems[index].Amt)
                                              print(selUOMConv)
                                                let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                 let TotalAmount = Double(Allprod[index].ProMRP)! * Double(uom)
                                                filterItems[index].TotAmt=String(TotalAmount)
                                          }
                                            
                                            
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
                                    Text("Total Qty: \(filterItems[index].Amt)")
                                    Spacer()
                                    let totalvalue = nubers[0]
                                    Text(filterItems[index].TotAmt)
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
                        .listRowSeparator(.hidden)
                    } else {
                        // Fallback on earlier versions
                    }
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
                    if lblTotAmt=="00.0"{
                        ShowTost="Cart is Empty"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }else{
                        
                        SelPrvOrderNavigte = true
                    }
                    
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
                
                
                if isShowingPopUp {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isShowingPopUp.toggle()
                        }
                    
                    VStack {
                        HStack {
                            Text("Select Item")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingPopUp.toggle()
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
                        
                        List(0 ..< allUomlist.count, id: \.self) { index in
                            VStack {
                            Button(action: {
                                isShowingPopUp.toggle()
                                 SelectItem = allUomlist[index].UomName
                                let UOMNAME = allUomlist[index].UomName
                                print(SelectItem)
                                let FilterUnite =  FilterProduct[index]
                                  print(FilterUnite)
                                  let uomList = FilterUnite["UOMList"] as? [[String: Any]]
                                  
                                  
                                if let uomLists = FilterUnite["UOMList"] as? [[String: Any]] {
                                    if index < uomLists.count, let uomLists2 = uomLists[index] as? [String: Any] {
                                        print(uomLists2)
                                        self.didselectRow(at: clickeindex, UOMNAME: uomLists2)
                                    } else {
                                        print("Invalid index or data")
                                    }
                                } else {
                                    print("UOMList not found or not in the expected format.")
                                }

                               
                                
                                
                                
                                
                                
                            }) {
                                
                                    Text(allUomlist[index].UomName)
                                    Text("1x\(allUomlist[index].UomConv)")
                                }
                            }
                            
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        //.padding(20)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                    
        }
            .toast(isPresented: $showToast, message: "\(ShowTost)")
            
           
            
        }
        .navigationBarHidden(true)
       
    }
    
    private func lstOfUnitList(at index: Int,filterUnite:[[String:Any]]){
       print(filterUnite)
        autoreleasepool {
            let item: [[String: Any]] = filterUnite
            print(item)
            for items in item {
                if let uomName = items["UOM_Nm"] as? String, let CnvQty = items["CnvQty"] as? Int {
                    print(uomName)
                    print(CnvQty)
                    allUomlist.append(Uomtyp(UomName: uomName, UomConv: String(CnvQty)))
                }
            }
            print(allUomlist)
//            let lblUOM = ""
//            print(item["ConQty"] as! CVarArg)
//            if SelMode=="UOM" {
//                lblUOM = String(format: "1 x  %@", item["ConQty"] as! CVarArg)
//                print(item["ConQty"] as! CVarArg)
//            }
        }
        
    }
    
    private func didselectRow(at index: Int,UOMNAME:[String:Any]){
        print(index)
        print(UOMNAME)
        let UOM_Name = UOMNAME["UOM_Nm"] as? String
        let id=String(format: "%@", UOMNAME["UOM_Id"] as! CVarArg)
    
            let selectProd: String

            let lProdItem:[String: Any]
            var selNetWt: String = ""
            print(lstPrvOrder)

               lProdItem = Allprod[index].Unit_Typ_Product
            print(lProdItem)
                selectProd = String(format: "%@",lProdItem["ERP_Code"] as! CVarArg)
        print(selectProd)
                selNetWt = String(format: "%@", lProdItem["product_netwt"] as! CVarArg)
          // }
            let ConvQty=String(format: "%@", UOMNAME["CnvQty"] as! CVarArg)
            print(ConvQty)
           let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (item) in
                if item["id"] as! String == selectProd {
                    return true
                }
                return false
            })
            var sQty: Int = 0
            if (items.count>0)
            {
                sQty = Int((items[0]["Qty"] as! NSString).intValue)
            }


            print(selectProd)
            print(id)
            print(UOM_Name as Any)
            print(ConvQty)
            print(selNetWt)
            print(sQty)
            print(lProdItem)

            updateQty(id: selectProd, sUom: id, sUomNm: UOM_Name!, sUomConv: ConvQty,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: lProdItem,refresh: 1)
         
        
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
    private func OrderprodCate(at index: Int){
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
                self.OrderprodDets(at: 0)
            }
        }
    }
    
    private func OrderprodDets(at index: Int){
        ProSelectID = proDetsID[index]
        print(ProSelectID)
        print(Allproddata)
        if let jsonData = Allproddata.data(using: .utf8){
            do{
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    print(jsonArray)
                    let itemsWithTypID3 = jsonArray.filter { ($0["cateid"] as? Int) == ProSelectID }
                    
                    if !itemsWithTypID3.isEmpty {
                        for item in itemsWithTypID3 {
                            print(itemsWithTypID3)
                           // FilterProduct = itemsWithTypID3.map { $0 as AnyObject }
                            FilterProduct = itemsWithTypID3  as [AnyObject]
                            print(FilterProduct.count)
                            if let procat = item["PImage"] as? String, let proname = item["name"] as? String ,  let MRP = item["Rate"] as? String, let Proid = item["ERP_Code"] as? String,let sUoms = item["Division_Code"] as? Int, let sUomNms = item["Default_UOMQty"] as? String, let Uomname = item["Default_UOM_Name"] as? String{
                                print(procat)
                                print(proname)
                                print(sUoms)
                                print(sUomNms)
                                print(Uomname)
                                
                                
                                
                                Allprod.append(Prodata(ImgURL: procat, ProName: proname, ProID: Proid, ProMRP:MRP,sUoms:sUoms,sUomNms:sUomNms, Uomname: Uomname, Unit_Typ_Product: item ))
                                
                                
                                
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
                    print(Allprod)
                }
            } catch{
                print("Data is error\(error)")
            }
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
                    } else {
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
    let Uomnm : String
    let Qty: String
    let totAmt:Double
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
        var qty=[String]()
        
        for items in VisitData.shared.ProductCart {
          let  qtys = (items["Qty"] as? String)!
            qty.append(qtys)
        }
        print(lstPrvOrder.count)
        print(VisitData.shared.ProductCart.count)
        print(qty)
        
        for index in 0..<VisitData.shared.ProductCart.count {
            print(index)
            items.append(Sales_Order.FilterItem(id: index, quantity: Int(qty[index])!))
        }
        self._filterItems = State(initialValue: items)
    }

   
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
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
                        
                        
                        for PrvOrderData in lstPrvOrder{
                            print(PrvOrderData)
                            let RelID = PrvOrderData["id"] as? String
                            let Uomnm = PrvOrderData["UOMNm"] as? String
                            let Qty = PrvOrderData["Qty"] as? String
                            let totAmt = PrvOrderData["NetVal"] as? Double
                            print(totAmt as Any)
                            
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    print(jsonArray)
                                    if let selectedPro = jsonArray.first(where: { ($0["ERP_Code"] as! String) == RelID }) {
                                        print(selectedPro)
                                        
                                        
                                        let url = selectedPro["PImage"] as? String
                                        let name  = selectedPro["name"] as? String
                                        let Proid = selectedPro["ERP_Code"] as? String
                                        let rate = selectedPro["Rate"] as? String
                                        let Uom = PrvOrderData["UOMConv"] as? String
                                        var result:Double = 0.0
                                        if let rateValue = Double(rate ?? "0"), let uomValue = Double(Uom ?? "0") {
                                            result = rateValue * uomValue
                                            print(result) // This will be a Double value
                                        } else {
                                            print("Invalid input values")
                                        }
                                        
                                        
                                        
                                        AllPrvprod.append(PrvProddata(ImgURL: url!, ProName: name!, ProID: Proid!, ProMRP: String(result),Uomnm:Uomnm!,Qty:Qty!,totAmt:totAmt!))
                                    }
                                    
                                    
                                }
                            } catch {
                                print("Error is \(error)")
                            }
                        }
                        
                        
                        
                        
                        print(AllPrvprod)
                    }
                    
                }
                
                Divider()
                List(0 ..< FilterItem.count, id: \.self) { index in
                    if #available(iOS 15.0, *) {
                        HStack {
                            Image("logo_new")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 70)
                                .cornerRadius(4)
                            
                            VStack(spacing: 10) {
                                VStack() {
                                    Text(AllPrvprod[index].ProName)
                                    
                                }
                                HStack(spacing: 60){
                                    Text(AllPrvprod[index].Uomnm)
                                    Text("Rs: \(AllPrvprod[index].ProMRP)")
                                }
                                
                                HStack(spacing: 60) {
                                    
                                    Button(action: {
                                        deleteItem(at: index)
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(Color.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
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
                                    Text("₹\(Double(AllPrvprod[index].ProMRP)! * Double(filterItems[index].quantity), specifier: "%.2f")")
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
                        .listRowSeparator(.hidden)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                .listStyle(PlainListStyle())
                .padding(.vertical, 5)
                .background(Color.white)
                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                )
                
                //.frame(width: 365)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 10)
                
//                .clipped()
//                .shadow(color: Color.gray, radius:3 , x:0,y:0)
                
                
                
                
            }
            .edgesIgnoringSafeArea(.top)
            
            
            
            Spacer()
            ZStack{
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(height: 100)
                
                Button(action:{
                    OrderSubmit()
                    //getLocation()
                    
                    
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
    
    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
        
        if (Cart["id"] as! String) == Ids {
            return true
        }
        return false
    })
    var selUOMConv: String = "1"
    var selNetWt: String = ""

    if(items.count>0){
        selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
        print(selUOM)
        selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
        print(selUOMNm)
        selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
        print(selUOMConv)
        selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
        print(selNetWt)
    } else{
          selUOM=String(format: "%@", SelectProd["Division_Code"] as! CVarArg)
        print(selUOM)
           selUOMNm=String(format: "%@", SelectProd["Product_Sale_Unit"] as! CVarArg)
        print(selUOMNm)
        selUOMConv=String(format: "%@", SelectProd["OrdConvSec"] as! CVarArg)
        print(selUOMConv)
         selNetWt=String(format: "%@", SelectProd["product_netwt"] as! CVarArg)
        //selNetWt = ""
        print(selNetWt)
        
    }

    updateQty(id: Ids!, sUom: selUOM, sUomNm: selUOMNm, sUomConv: selUOMConv,sNetUnt: selNetWt, sQty: String(sQty),ProdItem: SelectProd,refresh: 1)

}

 func minusQty(sQty:String,SelectProd:[String:Any]) {
     print(sQty)
     print(SelectProd)
   
     let Ids = SelectProd["ERP_Code"] as? String
     print(Ids as Any)
     
     let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
         
         if Cart["id"] as! String == Ids {
             return true
         }
         return false
     })
     var selUOMConv: String = "1"
     var selNetWt: String = ""
     if (items.count>0){
         selUOM=String(format: "%@", items[0]["UOM"] as! CVarArg)
         selUOMNm=String(format: "%@", items[0]["UOMNm"] as! CVarArg)
         selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
         selNetWt=String(format: "%@", items[0]["NetWt"] as! CVarArg)
     }
     else{
          selUOM=String(format: "%@", SelectProd["Division_Code"] as! CVarArg)
         print(selUOM)
           selUOMNm=String(format: "%@", SelectProd["Product_Sale_Unit"] as! CVarArg)
         print(selUOMNm)
          selUOMConv=String(format: "%@", SelectProd["OrdConvSec"] as! CVarArg)
         print(selUOMConv)
         // let selNetWt=String(format: "%@", lstProducts[indxPath.row]["product_netwt"] as! CVarArg)
          selNetWt = ""
         print(selNetWt)
     }


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
            print(totAmt)
            print(item["NetVal"] as! Double)
            TotamtlistShow = String(totAmt)
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
    
    var sPItems:String = ""
    for i in 0..<lstPrvOrder.count {
        guard let item = lstPrvOrder[i] as? [String: Any],
              let id = item["id"] as? String else {
            continue
        }
        
        var prodItems: [[String: Any]] = []
        
        if let jsonData = LstAllproddata.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    prodItems = jsonArray.filter { product in
                        if let prodId = product["ERP_Code"] as? String {
                            return prodId == id
                        }
                        return false
                    }
                }
            } catch {
                print("Error is \(error)")
            }
        }
        print(item)
        let disc: String = item["Disc"] as? String ?? "0"
        let disVal: String = item["DisVal"] as? String ?? "0"
        let Product_Total_Qty = Int(item["Qty"] as! String)!
        
        let productQty = String(item["OffQty"] as? Int ?? 0)
        let productCode = prodItems.isEmpty ? "" : (prodItems[0]["id"] as? String ?? "")
        print(prodItems)
        let productName = prodItems.isEmpty ? "" : (prodItems[0]["name"] as? String ?? "")
        
        sPItems = sPItems + "{\"product_code\":\"" + productCode + "\", \"product_Name\":\"" + productName + "\","
               sPItems = sPItems + " \"Product_Qty\":" + (String(format: "%.0f", item["SalQty"] as? Double ?? 0.0)) + ","
               sPItems = sPItems + " \"Product_Total_Qty\": \(Product_Total_Qty),"
               sPItems = sPItems + " \"Product_RegularQty\": 0,"
               sPItems = sPItems + " \"Product_Amount\":" + (String(format: "%.2f", item["Rate"] as! Double)) + ","
               sPItems = sPItems + " \"Rate\": \"\(item["Rate"] as! Double)\","
               sPItems = sPItems + " \"free\": 0,"
               sPItems = sPItems + " \"dis\": \"" + productQty + "\","
               sPItems = sPItems + " \"dis_value\":\"" + productQty + "\","
               sPItems = sPItems + " \"Off_Pro_code\":\"\","
               sPItems = sPItems + " \"Off_Pro_name\":\"\","
               sPItems = sPItems + " \"Off_Pro_Unit\":\"\","
               sPItems = sPItems + " \"discount_type\":\"\","
               sPItems = sPItems + " \"ConversionFactor\":" + (item["UOMConv"] as! String) + ","
               sPItems = sPItems + " \"UOM_Id\": \"2\","
               sPItems = sPItems + " \"UOM_Nm\": \"" + ((item["UOMNm"] as? String)!) + "\","
               sPItems = sPItems + " \"TAX_details\": [{\"Tax_Id\": \"1\","
               sPItems = sPItems + " \"Tax_Val\": 12,"
               sPItems = sPItems + " \"Tax_Type\": \"GST 12%,\","
               sPItems = sPItems + " \"Tax_Amt\": 23.64}]},"
        
        
    }
    
    var sPItems4: String = ""
    if sPItems.hasSuffix(",") {
        while sPItems.hasSuffix(",") {
            sPItems.removeLast()
        }
        sPItems4 = sPItems
    }
    updateDateAndTime()
    
    let jsonString = "[{\"Activity_Report_Head\":{\"SF\":\"96\",\"Worktype_code\":\"0\",\"Town_code\":\"\",\"dcr_activity_date\":\"\(currentDateTime)\",\"Daywise_Remarks\":\"\",\"UKey\":\"EKSf_Code654147271\",\"orderValue\":\"\(lblTotAmt)\",\"billingAddress\":\"Borivali\",\"shippingAddress\":\"Borivali\",\"DataSF\":\"96\",\"AppVer\":\"1.2\"},\"Activity_Doctor_Report\":{\"Doc_Meet_Time\":\"\(currentDateTime)\",\"modified_time\":\"\(currentDateTime)\",\"stockist_code\":\"3\",\"stockist_name\":\"Relivet Animal Health\",\"orderValue\":\"\(lblTotAmt)\",\"CashDiscount\":0,\"NetAmount\":\"\(lblTotAmt)\",\"No_Of_items\":\"\(VisitData.shared.ProductCart.count)\",\"Invoice_Flag\":\"\",\"TransSlNo\":\"\",\"doctor_code\":\"96\",\"doctor_name\":\"Kartik Test\",\"ordertype\":\"order\",\"deliveryDate\":\"\",\"category_type\":\"\",\"Lat\":\"13.029959\",\"Long\":\"80.2414085\",\"TOT_TAX_details\":[{\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"56.17\"}]},\"Order_Details\":[" + sPItems +  "]}]"

    
    
//    let jsonString =  "[{\"Activity_Report_Head\":{\"SF\":\"96\",\"Worktype_code\":\"0\",\"Town_code\":\"\",\"dcr_activity_date\":\"\(currentDateTime)\",\"Daywise_Remarks\":\"\",\"UKey\":\"EKSf_Code654147271\",\"orderValue\":\"524.24\",\"billingAddress\":\"Borivali\",\"shippingAddress\":\"Borivali\",\"DataSF\":\"96\",\"AppVer\":\"1.2\"},\"Activity_Doctor_Report\":{\"Doc_Meet_Time\":\"\(currentDateTime)\",\"modified_time\":\"\(currentDateTime)\",\"stockist_code\":\"3\",\"stockist_name\":\"Relivet Animal Health\",\"orderValue\":\"524.24\",\"CashDiscount\":0,\"NetAmount\":\"524.24\",\"No_Of_items\":\"2\",\"Invoice_Flag\":\"\",\"TransSlNo\":\"\",\"doctor_code\":\"96\",\"doctor_name\":\"Kartik Test\",\"ordertype\":\"order\",\"deliveryDate\":\"\",\"category_type\":\"\",\"Lat\":\"13.029959\",\"Long\":\"80.2414085\",\"TOT_TAX_details\":[{\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"56.17\"}]},\"Order_Details\":[{\"product_Name\":\"FiproRel- S Dog 0.67 ml\",\"product_code\":\"D111\",\"Product_Qty\":1,\"Product_RegularQty\":0,\"Product_Total_Qty\":1,\"Product_Amount\":220.64,\"Rate\":\"197.00\",\"free\":\"0\",\"dis\":0,\"dis_value\":\"0.00\",\"Off_Pro_code\":\"\",\"Off_Pro_name\":\"\",\"Off_Pro_Unit\":\"\",\"discount_type\":\"\",\"ConversionFactor\":1,\"UOM_Id\":\"2\",\"UOM_Nm\":\"Pipette\",\"TAX_details\":[{\"Tax_Id\":\"1\",\"Tax_Val\":12,\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"23.64\"}]}]}]"
    
    
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
       
    }
}
    
  
}
func updateDateAndTime() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    currentDateTime = formatter.string(from: Date())
    
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        currentDateTime = formatter.string(from: Date())
        print(currentDateTime)
    }
}


func getLocation() {
//    let locationService = LocationService.sharedInstance
//    locationService.getNewLocation(location: { location in
//        let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
//        let geocoder = CLGeocoder()
//        var sAddress: String = ""
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let placemark = placemarks?.first {
//                if let formattedAddresssLines = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
//                    sAddress = formattedAddressLines.joined(separator: ", ")
//                }
//            }
//            print(sLocation)
//            print(sAddress)
//            // Call your function here like: self.orderSubmit(sLocation: sLocation, sAddress: sAddress)
//        }
//    }, error: { errMsg in
//        print(errMsg)
//        // Handle error or dismiss loading here
//    })
}

