//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI
import Alamofire
import Combine
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
    var SelectUom:String
}
struct EdditeAddres : Any{
    let listedDrCode:String
    let address : String
    let id : Int
    let stateCode: Int
    
}
var GetingAddress:[EdditeAddres]=[]

var lstPrvOrder: [AnyObject] = []
var lblTotAmt:String = "0.0"
var TotamtlistShow:String = ""
var selUOM: String = ""
var selUOMNm: String = ""
var currentDateTime = ""
var ShpingAddress = ""
var BillingAddress = "Borivali"
var isChecked = false
var Lstproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
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
    @State private var ADDaddress = false
    @State private var showAlert = false
    @State private var showToast = false
    @State private var ShowTost = ""
    @State private var navigateToHomepage = false
    @State private var filterItems: [TotAmt] = []
    //@State private var isChecked = false
    @State private var SameAddrssmark = true
    @State private var TotalQty = [String]()
    @State private var TotalAmt = [String]()
    @State private var SelectUOMN = [String]()
    @State private var items: [TotAmt] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var SelMod = ""

    var body: some View {
        
        NavigationView {
            ZStack{
            VStack(spacing: 0) {
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(ColorData.shared.HeaderColor)
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
                                message: Text("Do you want cancel this order Draft"),
                                primaryButton: .default(Text("OK")) {
                                    self.presentationMode.wrappedValue.dismiss()
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
                        HStack{
                            Text("DR. INGOLE")
                                .font(.system(size: 15))
                            Spacer()
                        }
                        HStack {
                            //                            Image("SubmittedCalls")
                            //                                .resizable()
                            //                                .frame(width: 20, height: 20)
                            //                                .background(Color.blue)
                            //                                .cornerRadius(10)
                            Text("9923125671")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                Spacer()
                        }
                        HStack{
                            Text("Billing Address:")
                                .font(.system(size: 12))
                            Text(BillingAddress)
                                .font(.system(size: 12))
                            Spacer()
                          
                                Image(systemName: "pencil" )
                                    .foregroundColor(Color(.blue))
                                    .frame(width: 20)
                                    .onTapGesture {
                                        ADDaddress.toggle()
                                        SelMod = "BA"
                                      
                                      
                                    }
                                  
                            
                        }
                        
                        HStack {
                            
                            Image(systemName: isChecked ? "square" : "checkmark.square.fill")
                                .foregroundColor(isChecked ? .blue : .blue)
                                .onTapGesture {
                                    isChecked.toggle()
                                    if isChecked == true{
                                        SameAddrssmark = false
                                    }else{
                                        ShpingAddress = BillingAddress
                                        SameAddrssmark = true
                                    }
                                }
                            Text("Shipping Address same As Billing Address")
                                .font(.system(size: 12))
                            Spacer()
                        }
                        if !SameAddrssmark{
                        HStack{
                            Text("Shipping Address:")
                                .font(.system(size: 12))
                            Text(ShpingAddress)
                                .font(.system(size: 12))
                            Spacer()
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(.blue))
                                    .frame(width: 20)
                                    .onTapGesture {
                                        SelMod = "SA"
                                        ADDaddress.toggle()
                                        if isChecked == true{
                                        }else{
                                            ShpingAddress = BillingAddress
                                            
                                        }
                                    }
                            
                        }
                    }
                        
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
                                    TotalQty.removeAll()
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
                                        .background(selectedIndex == index ? ColorData.shared.HeaderColor : Color.gray)
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
                //.padding(.top,0)
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
                    TexQty()
                    ShpingAddress = BillingAddress
                    
                }
                
                //NavigationView {
                
                List(0 ..< Allprod.count, id: \.self) { index in
                    if #available(iOS 15.0, *) {
                        HStack {
                            if let uiImage = uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                                    .cornerRadius(4)
                            } else {
                                Text("Image loading...")
                                    .font(.system(size: 14))
                                   // .onAppear{ loadImage(at: index) }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                // Text(Arry[index])
                                Text(Allprod[index].ProName)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 14))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(Allprod[index].ProID)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                                HStack {
                                    //Text("MRP ₹\(nubers[index])")
                                    Text("MRP 0")
                                    .font(.system(size: 13))
                                    Spacer()
                                    Text("Price: \(Allprod[index].ProMRP)")
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                }
                                HStack {
                                        VStack{
                                            Text(filterItems[index].SelectUom)
                                                .padding(.vertical, 6)
                                                .font(.system(size: 14))
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
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        Text("\(filterItems[index].Amt)")
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                            .foregroundColor(Color.black)
                                        
                                        Button(action: {
                                            filterItems[index].Amt += 1
                                            print(lstPrvOrder)
                                            print(filterItems[index].Amt)
                                            
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
                                            Text("+")                          .font(.system(size: 15))
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
                                        .font(.system(size: 14))
                                    
                                        
                                    Spacer()
                                    Text("₹0.00")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                }
                                Divider()
                                HStack {
                                    Text("Total Qty: \(filterItems[index].Amt)")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    let totalvalue = nubers[0]
                                    Text(filterItems[index].TotAmt)
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                }
                              
                            }
                            .padding(.vertical, 5)
                           
                        }
                        
                        
                      
                        //.listRowSeparator(.hidden)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .listStyle(PlainListStyle())
                
                
                
                Button(action: {
                    if lblTotAmt=="0.0"{
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
                            .foregroundColor(ColorData.shared.HeaderColor)
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
                                .foregroundColor(ColorData.shared.HeaderColor)
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
                                print(filterItems)
                                TexQty()
                                print(items)
          
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
        .sheet(isPresented: $ADDaddress, content: {
            Address(ADDaddress: $ADDaddress, SelMod: $SelMod)
            
        })
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
        print(index)
        print(Allprod[index].ImgURL)
        for item in 0..<Allprod.count{
            let getdata = Allprod[item].ImgURL
            print(getdata)
      
        
        if let imageUrl = URL(string: getdata) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.uiImage = uiImage
                        print(uiImage)
                    }
                }
            }.resume()
        }
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
                    TexQty()
                    GetingListAddress()
                    loadImage(at: 0)
                }
            } catch{
                print("Data is error\(error)")
            }
        }
        
    }
    private func TexQty(){
        var Qty = "0"
        var Amount="0"
        TotalAmt.removeAll()
        SelectUOMN.removeAll()
        TotalQty.removeAll()
        for item in FilterProduct{
           print(item)
            let id=String(format: "%@", item["ERP_Code"] as! CVarArg)
            let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                
                if Cart["id"] as! String == id {
                    return true
                }
                return false
            })
            if items.count>0 {
                 Qty = (items[0]["Qty"] as? String)!
                print(items[0]["Qty"] as? String as Any)
                print(items)
                Amount = String((items[0]["Value"] as? Double)!)
                let Uom = items[0]["UOMNm"] as? String
                SelectUOMN.append(Uom!)
                print(items)
                print(Amount as Any)
                TotalAmt.append(Amount)
                
                TotalQty.append(Qty)
            }else{
                print(FilterProduct)
                let UomQty = FilterProduct[0]["Default_UOM_Name"] as? String
                SelectUOMN.append(UomQty!)
                let ZerQty = "0"
                TotalAmt.append(ZerQty)
                TotalQty.append(ZerQty)
            }
        }
//        if filterItems.isEmpty{
//            print("No data")
//        }else{
//            print("Data In")
//            for items in filterItems{
//              print(items)
//                let Qty = String(items.Amt)
//                TotalQty.append(Qty)
//
//            }
//        }
        print(TotalQty)
        print(FilterProduct)
        print(SelectUOMN)
        print(TotalAmt)
        
        items.removeAll()
        for index in 0..<FilterProduct.count {
            print(index)
            print(filterItems)
            items.append(Sales_Order.TotAmt(id: index, Amt: Int(TotalQty[index])!, TotAmt:TotalAmt[index], SelectUom:SelectUOMN[index] ))
            print(items)
        }
        
        print(items)
        filterItems = items
        print(FilterProduct.count)
        print(filterItems)
    }
    
    
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
        SelPrvOrder()
        //Address()
    }
}
struct get_states: Any{
    let id:String
    let title:String
}

struct Address:View{
   @Binding var ADDaddress: Bool
    @State private var clickPlusButton = false
    @State private var ClickStateButton = false
    @State private var AddressTextInpute:String = ""
    @State private var EditeAddressHed:String = ""
    @State private var SelectState:String=""
    @State private var Getstates:[get_states]=[]
    @State private var selectedstate:String = "Select State"
    @State private var GetLoction = false
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0,0)
    @State var address = ""
    @State private var EditState = ""
    @State private var EditeAddres = ""
    @Binding var SelMod: String
    @State private var OpenMod = ""
    @State private var Editid:Int = 0
 
    var body: some View{
        ZStack{
        VStack{
            Text("")
                .font(.system(size: 20))
            Text("Select Address")
                .font(.system(size: 20))
                .font(.headline)
                .fontWeight(.bold)
            Divider()
            ZStack{
                Color(red: 0.93, green: 0.94, blue: 0.95, opacity: 1.00)
                Text("Borivali")
                    
                    //.frame(width: 50, height: 50)
            }
            .frame(width: 350,height: 50)
            .cornerRadius(10)
            .onAppear{
                
                print(GetingAddress)
            }
            List(0..<GetingAddress.count, id: \.self) { index in
                if #available(iOS 15.0, *) {
                    ZStack{
                        Color(red: 0.93, green: 0.94, blue: 0.95, opacity: 1.00)
                        HStack(){
                            Text(GetingAddress[index].address)
                                .frame(height: 50)
                                .offset(x:10)
                                .onTapGesture {
                                    if SelMod == "SA"{
                                        ShpingAddress = GetingAddress[index].address
                                        print(ShpingAddress)
                                        if isChecked == true{
                                            
                                        }else{
                                            ShpingAddress = BillingAddress
                                           
                                        }
                                    }
                                    if SelMod == "BA"{
                                        BillingAddress = GetingAddress[index].address
                                        
                                    }
                                    ADDaddress = false
                                    
                                }
                            Spacer()
                            Image(systemName: "pencil" )
                                .foregroundColor(Color(.blue))
                                .frame(width: 30)
                                .onTapGesture {
                                    Editid = GetingAddress[index].id
                                    clickPlusButton.toggle()
                                    OpenMod = "Edit"
                                    EditeAddressHed = "Edite Address"
                                    //EditState = GetingAddress[index].address
                                    EditeAddres = GetingAddress[index].address
                                    AddressTextInpute = EditeAddres
                                    
                                    
                                    
                                }
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.red)
                                .frame(width: 50, height: 30)
                                .onTapGesture {
                                    
                                    let getid = GetingAddress[index].id
                                    let listedDrCode = GetingAddress[index].listedDrCode
                                    print(getid)
                                    
                                    let axn = "delete_ret_address&id=\(getid)&listedDrCode=\(listedDrCode)"
                                  //http://rad.salesjump.in/server/Db_Retail_v100.php?axn=delete_ret_address&id=58&listedDrCode=96
                                    let apiKey = "\(axn)"
                                    
                                    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
                                        .validate(statusCode: 200 ..< 299)
                                        .responseJSON { response in
                                            switch response.result {
                                            case .success(let value):
                                                print(value)
                                     
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
                                        
                                                }
                                            case .failure(let error):
                                                print(error)
                                            }
                                        }
                                }
                        }
                        
                    }
                    .cornerRadius(10)
                    
                    
                    
                    .listRowSeparator(.hidden)
                } else {
                    
                }
            }
            .listStyle(PlainListStyle())
            .padding(.vertical, 5)
            //.background(Color.white)
            .background(Color.white)
            Spacer()
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(ColorData.shared.HeaderColor)
                .onTapGesture {
                    OpenMod = "Add"
                    clickPlusButton.toggle()
                    EditeAddressHed = "Add New Address"
                }
            
            
        }
            if clickPlusButton{
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        clickPlusButton.toggle()
                    }
                VStack{
                    HStack {
                        Text(EditeAddressHed)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            clickPlusButton.toggle()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    Divider()
                    VStack{
                        HStack{
                            Text("State")
                                .padding(.leading,25)
                            Spacer()
                        }
                        HStack(spacing: 180){
                            Text(selectedstate)
                                .font(.system(size: 15))
                                .frame(width: 100)
                                .padding(.leading,10)
                            
                            
                            
                            Image(systemName: "chevron.down")
                                .padding(.trailing,5)
                        }
                        .frame(height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue,lineWidth: 2)
                        )
                        .onTapGesture {
                            ClickStateButton.toggle()
                            print(ClickStateButton)
                            
                            
                            let axn = "get_states"
                            /// http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get_states
                            
                            let apiKey = "\(axn)"
                            
                            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
                                .validate(statusCode: 200 ..< 299)
                                .responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        print(value)
                                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                                            print("Error: Cannot convert JSON object to Pretty JSON data")
                                            return
                                        }
                                        guard let prettyPrintedJsons = String(data: prettyJsonData, encoding: .utf8) else {
                                            print("Error: Could print JSON in String")
                                            return
                                        }
                                        SelectState = prettyPrintedJsons
                                        print(prettyPrintedJsons)
                                        
                                        // Assuming prettyPrintedJsons is a JSON string
                                        if let jsonData = prettyPrintedJsons.data(using: .utf8),
                                           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                           let responseArray = json["response"] as? [[String: Any]] {
                                            for stateItem in responseArray {
                                                if let id = stateItem["id"] as? String, let title = stateItem["title"] as? String {
                                                    
                                                    Getstates.append(get_states(id: id, title: title))
                                                }
                                            }
                                        }
                                        print(Getstates)
                                        
                                        
                                        
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
                                            
                                            
                                            print("______________________prodGroup_______________")
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                        }
                        HStack{
                            Text("Full Address")
                                .padding(.leading,25)
                            Spacer()
                        }
                        HStack(spacing:180){
                            //TextField("Enter full address with pincode",text: $AddressTextInpute)
                            TextEditor(text: $AddressTextInpute)
                            
                                .frame(width: 310,height: 100)
                            // .padding()
                                .overlay(
                                    Text("Enter full address with pincode")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 4)
                                        .opacity(AddressTextInpute.isEmpty ? 1 : 0)
                                )
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue,lineWidth: 2)
                        )
                        
                        
                        HStack{
                            Spacer()
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(Color.blue)
                            Text("Use my current location")
                                .font(.system(size: 17))
                                .foregroundColor(Color.blue)
                            Spacer()
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            AddressTextInpute.removeAll()
                            GetCurrentLoction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                GetLoction.toggle()
                                print(AddressTextInpute)
                            }
                            GetLoction.toggle()
                            
                        }
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .frame(height: 50)
                            VStack{
                                
                                Text("Submit")
                                    .foregroundColor(Color.white)
                                
                            }
                        }
                        .onTapGesture {
                            if OpenMod == "Add"{
                            
                            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"insert_ret_address"+"&listedDrCode=96"+"&address=\(AddressTextInpute)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                                AFdata in
                                switch AFdata.result
                                {
                                    
                                case .success(let value):
                                    print(value)
                                    if let json = value as? [String: Any] {
                                        
                                        print(json)
                                        ClickStateButton.toggle()
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        
                                    }
                                    
                                case .failure(let error):
                                    
                                    let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                        return
                                    })
                                    
                                }
                            }
                        }
                            if OpenMod == "Edit"{
                            
                                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"update_ret_address"+"&id=\(Editid)"+"&listedDrCode=96"+"&address=\(AddressTextInpute)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                                    AFdata in
                                    switch AFdata.result
                                    {
                                        
                                    case .success(let value):
                                        print(value)
                                        if let json = value as? [String: Any] {
                                            
                                            print(json)
                                            ClickStateButton.toggle()
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                            
                                        }
                                        
                                    case .failure(let error):
                                        
                                        let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                            return
                                        })
                                        
                                    }
                                }
                            }
                    }
                        
                        
                    }
                    
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            }
            if ClickStateButton{
                Color.black.opacity(0.0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        ClickStateButton.toggle()
                    }
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 40)
                        Text("")
                        Text("Select State")
                            .foregroundColor(Color.white)
                    }
                    
                    Divider()
                    List(0..<Getstates.count,id: \.self){index in
                        Text(Getstates[index].title)
                            .onTapGesture {
                                selectedstate = Getstates[index].title
                                ClickStateButton.toggle()
                            }
                       
                    }
                    .listStyle(PlainListStyle())
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 60)
                      
                            Text("Close")
                                .foregroundColor(Color.white)
                                
                        
                    }
                    .onTapGesture {
                        ClickStateButton.toggle()
                        print(SelectState)
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            }
            if GetLoction{
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        GetLoction.toggle()
                    }
                VStack{
                    LottieUIView(filename: "Gettingloction").frame(width: 220,height: 150)
                    Text("Getting Current Loction...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("")
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
                
            }
    }
            
        
        
    }
    
    private func GetCurrentLoction(){
       
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            lazy var geocoder = CLGeocoder()
            var sAddress: String = ""
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if(placemarks != nil){
                    if(placemarks!.count>0){
                        let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                        for i in 0...jAddress.count-1 {
                            print(jAddress[i])
                            if i==0{
                                sAddress = String(format: "%@", jAddress[i])
                            }else{
                                sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                            }
                        }
                    }
                }
                AddressTextInpute = sAddress
                print(sAddress)
            }
        }, error:{ errMsg in
            print (errMsg)
        })
    }
    
}


func GetingListAddress(){
    let axn = "get_ret_addresses&listedDrCode=96"
    let apiKey = "\(axn)"

   
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
                    GetingAddress.removeAll()
                    if let jsonData = prettyPrintedJson.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let responseArray = json["response"] as? [[String: Any]] {
                        print(responseArray)
                        for AddressItem in responseArray {
                            if let ListedDrCode = AddressItem["ListedDrCode"] as? String, let Address = AddressItem["Address"] as? String, let ID = AddressItem["id"] as? Int, let stateCode = AddressItem["State_Code"] as? Int {
                                 GetingAddress.append(EdditeAddres(listedDrCode: ListedDrCode, address: Address, id: ID, stateCode: stateCode))
                               
                            }
                        }
                    }
                    print(GetingAddress)
                    
                   
        
                }
            case .failure(let error):
                print(error)
            }
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
    @State private var showAlert = false
    @State private var sLocationlat = ""
    @State private var sLocationlong = ""
    @State private var GetLoction = false
    @State private var OrderSubStatus = ""
    @State private var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
        NavigationView{
            ZStack{
                //            Color.gray.opacity(0.2)
                //                .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack(spacing:10){
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
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
                        ScrollView{
                            ForEach(AllPrvprod.indices, id: \.self) { index in
                                VStack{
                                    HStack{
                                        Image("sanlogo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 75,height: 75)
                                            .padding(.leading,10)
                                        Spacer()
                                        VStack{
                                            HStack{
                                                Text(AllPrvprod[index].ProName)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.semibold)
                                                    .padding(.leading,10)
                                                Spacer()
                                            }
                                            HStack{
                                                Text(AllPrvprod[index].Uomnm)
                                                Spacer()
                                                Text("Rs: \(AllPrvprod[index].ProMRP)")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.leading,10)
                                            .padding(.trailing,12)
                                            HStack{
                                                Button(action: {
                                                    deleteItem(at: index)
                                                    AllPrvprod.remove(at: index)
                                                    print(AllPrvprod)
                                                }) {
                                                    Image(systemName: "trash.fill")
                                                        .foregroundColor(Color.red)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                Spacer()
                                                HStack{
                                                    Button(action:{
                                                        if filterItems[index].quantity > 0 {
                                                            filterItems[index].quantity -= 1
                                                        }
                                                        let ProId = AllPrvprod[index].ProID
                                                        if let jsonData = Allproddata.data(using: .utf8){
                                                            do{
                                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                                    print(jsonArray)
                                                                    let itemsWithTypID3 = jsonArray.filter { ($0["ERP_Code"] as? String) == ProId }
                                                                    
                                                                    if !itemsWithTypID3.isEmpty {
                                                                        for item in itemsWithTypID3 {
                                                                            let Qty = String(filterItems[index].quantity)
                                                                            minusQty(sQty: Qty, SelectProd: item)
                                                                            
                                                                        }
                                                                    } else {
                                                                        print("No data with TypID")
                                                                    }
                                                                    
                                                                }
                                                            } catch{
                                                                print("Data is error\(error)")
                                                            }
                                                        }
                                                    }){
                                                        Text("-")
                                                            .font(.headline)
                                                            .fontWeight(.bold)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    Text("\(filterItems[index].quantity)")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.black)
                                                    Button(action:{
                                                        filterItems[index].quantity += 1
                                                        print(AllPrvprod[index].ProID)
                                                        let ProId = AllPrvprod[index].ProID
                                                        if let jsonData = Allproddata.data(using: .utf8){
                                                            do{
                                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                                    print(jsonArray)
                                                                    let itemsWithTypID3 = jsonArray.filter { ($0["ERP_Code"] as? String) == ProId }
                                                                    
                                                                    if !itemsWithTypID3.isEmpty {
                                                                        for item in itemsWithTypID3 {
                                                                            let Qty = String(filterItems[index].quantity)
                                                                            addQty(sQty: Qty, SelectProd: item)
                                                                            
                                                                        }
                                                                    } else {
                                                                        print("No data with TypID")
                                                                    }
                                                                    
                                                                }
                                                            } catch{
                                                                print("Data is error\(error)")
                                                            }
                                                        }
                                                    }){
                                                        Text("+")
                                                            .font(.headline)
                                                            .fontWeight(.bold)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                }
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 15)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .foregroundColor(Color.blue)
                                            }
                                            .padding(.leading,10)
                                            .padding(.trailing,10)
                                            .padding(.top,-5)
                                            Divider()
                                                .padding(5)
                                            
                                            HStack{
                                                Text("Total")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.semibold)
                                                Spacer()
                                                Text("₹\(Double(AllPrvprod[index].ProMRP)! * Double(filterItems[index].quantity), specifier: "%.2f")")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.leading,10)
                                            .padding(.trailing,10)
                                        }
                                        
                                    }
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray)
                                    
                                    
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                    
                    
                    
                    Spacer()
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 100)
                        
                        Button(action:{
                            
                            //getLocation()
                            showAlert = true
                            
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
                                HStack{
                                    
                                    Text("\(Image(systemName: "indianrupeesign"))\(lblTotAmt)")
                                        .font(.system(size: 15))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .padding(.leading,10)
                                    Spacer()
                                    
                                    
                                    Text("Submit")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.system(size: 17))
                                        .multilineTextAlignment(.center)
                                        .padding(.trailing,20)
                                        //.padding(.bottom,20)
                                        
                                    
                                    
                                }
                                .padding(.leading,10)
                                .padding(.trailing,10)
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
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Do you want submit order?"),
                            primaryButton: .default(Text("OK")) {
                                GetCurrentLoction()
                                GetLoction.toggle()
                                OrderSubStatus = "Getting Current Loction..."
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    OrderSubStatus = "Data Summitting Wait..."
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        OrderSubmit(lat: sLocationlat, log: sLocationlong)
                                        GetLoction.toggle()
                                        isActive = true
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                NavigationLink(destination: HomePage(), isActive: $isActive) {
                                    EmptyView()
                                }
                if GetLoction{
                    ZStack{
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            GetLoction.toggle()
                        }
                    VStack{
                        LottieUIView(filename: "loader").frame(width: 100,height: 100)
                        Text(OrderSubStatus)
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                    
                }
            }
        }
    }
        .navigationBarHidden(true)
      
       
    }
    func GetCurrentLoction(){
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            print(sLocation)
            sLocationlat = location.coordinate.latitude.description
            sLocationlong = location.coordinate.longitude.description
        

        }, error:{ errMsg in
            print (errMsg)
            //self.LoadingDismiss()
        })
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

func OrderSubmit(lat:String,log:String) {
    
    print(lstPrvOrder)
  print(lat)
    print(log)
    
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
    
    let jsonString = "[{\"Activity_Report_Head\":{\"SF\":\"96\",\"Worktype_code\":\"0\",\"Town_code\":\"\",\"dcr_activity_date\":\"\(currentDateTime)\",\"Daywise_Remarks\":\"\",\"UKey\":\"EKSf_Code654147271\",\"orderValue\":\"\(lblTotAmt)\",\"billingAddress\":\"\(BillingAddress)\",\"shippingAddress\":\"\(ShpingAddress)\",\"DataSF\":\"96\",\"AppVer\":\"1.2\"},\"Activity_Doctor_Report\":{\"Doc_Meet_Time\":\"\(currentDateTime)\",\"modified_time\":\"\(currentDateTime)\",\"stockist_code\":\"3\",\"stockist_name\":\"Relivet Animal Health\",\"orderValue\":\"\(lblTotAmt)\",\"CashDiscount\":0,\"NetAmount\":\"\(lblTotAmt)\",\"No_Of_items\":\"\(VisitData.shared.ProductCart.count)\",\"Invoice_Flag\":\"\",\"TransSlNo\":\"\",\"doctor_code\":\"96\",\"doctor_name\":\"Kartik Test\",\"ordertype\":\"order\",\"deliveryDate\":\"\",\"category_type\":\"\",\"Lat\":\"\(lat)\",\"Long\":\"\(log)\",\"TOT_TAX_details\":[{\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"56.17\"}]},\"Order_Details\":[" + sPItems +  "]}]"

    
    
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

            NavigationLink(destination: HomePage()) {
                              EmptyView()
                          }
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
    }
}



