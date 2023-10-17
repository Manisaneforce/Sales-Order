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
    var ConvRate:String
    var NetValu:String
    var Free : String
    var Freeprdname : String
    var Dis : String
    var DisVal : String
}
struct EdditeAddres : Any{
    let listedDrCode:String
    let address : String
    let id : Int
    let stateCode: Int
    
}
struct editUom:Any{
    let Uon:String
    let UomConv:String
    let NetValu:String
    let Disc : String
    let Disvalue: String
    let freeQty: String
    let OffProdNm: String
}
struct GroupId:Any{
    let name:String
    let id:String
    let ProdGrp_Sl_No:String
}

var lblTotAmt:String = "0.0"
var lblTotAmt2:String = String()
var TotamtlistShow:String = ""
var selUOM: String = ""
var selUOMNm: String = ""
var currentDateTime = ""
var ShpingAddress = ""
var BillingAddress = CustDet.shared.Addr
var TotalQtyData: Int = 0
var Lstproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
var lstSchemList:String = UserDefaults.standard.string(forKey: "Schemes_Master") ?? ""

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
    @State private var prettyPrintedJson:[GroupId] = []
    @State private var prodTypes2 = [String]()
    @State private var prodTypes3 = [Int]()
    @State private var prodofcat = [String]()
    @State private var prodCate: String = ""
    @State private var selectedIndices: Set<Int> = []
    @State private var selectedGorup:Int? = 0
    @State private var selectedIndex: Int? = 0
    @State private var SubselectedIndex:Int? = 0
    @State private var SelectId:Int = 0
    @State private var ProSelectID:Int = 0
    @State private var proDetsID = [Int]()
    @State private var  imgdataURL = [String]()
    @State private var uiImages: [UIImage] = []
    @State private var Allproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
    @State private var FilterProduct = [AnyObject]()
    @State private var Allprods:[Prodata]=[]
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
    @State private var SelectUOMN:[editUom] = []
    @State private var items: [TotAmt] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var SelMod = ""
    @State private var isChecked:Bool = false
    @State private var lstPrvOrder: [AnyObject] = []
    @State private var OredSc:Bool = true
    @State private var SelPrvSc:Bool = false
    @State private var Disc:Bool = true
   

    var body: some View {
        if OredSc{
        NavigationView {
            ZStack{
                Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05)
                    .edgesIgnoringSafeArea(.all)
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
                                    .padding(.top,50)
                                    .frame(width: 50)
                            }
                            
                            
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Confirmation"),
                                    message: Text("Do you want cancel this order Draft"),
                                    primaryButton: .default(Text("OK")) {
                                        VisitData.shared.ProductCart = []
                                        VisitData.shared.lstPrvOrder = []
                                        TotalQtyData = 0
                                        lblTotAmt = "0.0"
                                        self.presentationMode.wrappedValue.dismiss()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            Text("Order")
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                            Spacer()
                        }
                        
                    }
                    //.cornerRadius(5)
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        VStack(spacing:5){
                            HStack{
                                Text(CustDet.shared.CusName)
                                    .font(.system(size: 15))
                                Spacer()
                            }
                            HStack {
                                //                            Image("SubmittedCalls")
                                //                                .resizable()
                                //                                .frame(width: 20, height: 20)
                                //                                .background(Color.blue)
                                //                                .cornerRadius(10)
                                Text(CustDet.shared.Mob)
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(prettyPrintedJson.indices, id: \.self) { index in
                                    Button(action:{
                                        print(prettyPrintedJson[index].id)
                                        
                                        
                                        if selectedGorup == index {
                                            selectedGorup = index
                                            
                                        } else {
                                            selectedGorup = index
                                        }
                                     OrderProdTyp()
                                    })
                                    {
                                        Text(prettyPrintedJson[index].name)
                                            .fontWeight(.semibold)
                                            .foregroundColor(selectedGorup == index ? ColorData.shared.HeaderColor : Color.gray)
                                            .font(.system(size: 12))
                                            .padding(.horizontal,10)
                                            .padding(.vertical,5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedGorup == index ? ColorData.shared.HeaderColor : Color.gray, lineWidth: 2)
                                            )
                                    }
                                    .cornerRadius(10)
                            }
                        }
                            
                            .padding(.horizontal, 10)
                    }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(prodTypes2.indices, id: \.self) { index in
                                    Button(action: {
                                        prodofcat.removeAll()
                                        proDetsID.removeAll()
                                        Allprods.removeAll()
                                        TotalQty.removeAll()
                                        if selectedIndex == index {
                                            selectedIndex = index
                                            SubselectedIndex = 0
                                            
                                        } else {
                                            selectedIndex = index
                                            SubselectedIndex = 0
                                        }
                                        print("Clicked button at index: \(index)")
                                        self.OrderprodCate(at: index)
                                        
                                    }) {
                                        
                                        Text(prodTypes2[index])
                                            .fontWeight(.bold)
                                            .foregroundColor(selectedIndex == index ? ColorData.shared.HeaderColor : Color.gray)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .font(.system(size: 12))
                                        //.background(selectedIndex == index ? ColorData.shared.HeaderColor : Color.white)
                                        //.cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedIndex == index ? ColorData.shared.HeaderColor : Color.gray, lineWidth: 2)
                                            )
                                    }
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 10)
                            
                        }
                        Divider()
                        VStack{
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(prodofcat.indices, id: \.self) { index in
                                    Button(action:{
                                        imgdataURL.removeAll()
                                        Arry.removeAll()
                                        Allprods.removeAll()
                                        print("If Select data")
                                        print("Clicked button at index: \(index)")
                                        self.OrderprodDets(at: index)
                                        if SubselectedIndex == index {
                                            SubselectedIndex = index
                                        } else {
                                            SubselectedIndex = index
                                        }
                                        
                                    }) {
                                        Text(prodofcat[index])
                                            .fontWeight(.semibold)
                                            .foregroundColor(SubselectedIndex == index ? ColorData.shared.HeaderColor : Color.gray)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .font(.system(size: 12))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(SubselectedIndex == index ? ColorData.shared.HeaderColor : Color.gray, lineWidth: 2)
                                            )
                                    }
                                    .cornerRadius(10)
                                }
                                
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        
                    }
                    //.padding(.top,0)
                    .onAppear {
                        
                        prodGroup { jsonString in
                            if let jsonData = jsonString.data(using: .utf8) {
                                prettyPrintedJson.removeAll()
                                do {
                                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]{
                                       for firstItem in jsonArray {
                                        print(jsonArray)
                                        let textname = firstItem["name"] as? String ?? ""
                                        let ProGroID = String((firstItem["id"] as? Int)!)
                                        let ProdGrp_Sl_No = String((firstItem["ProdGrp_Sl_No"] as? Int)!)
                                        
                                        print("Name: \(textname)")
                                        prettyPrintedJson.append(GroupId(name: textname, id: ProGroID, ProdGrp_Sl_No: ProdGrp_Sl_No))
                                    }
                                }
                                } catch {
                                    print("Error parsing JSON: \(error)")
                                }
                                print(prettyPrintedJson)
                            }
                        }
                        OrderProdTyp()
                        
                        Sales_Order.prodDets{
                            json in
                            print(json)
                        }
                        
                        
                        TexQty()
                        ShpingAddress = BillingAddress
                        SchemeDet()
                        
                        
                    }
                    
                    //NavigationView {
                    ScrollView(showsIndicators: false){
                        ForEach(0 ..< Allprods.count, id: \.self) { index in
                            ZStack{
//                                Rectangle()
//                                    .foregroundColor(.white)
                                    
                                HStack {
                                    VStack{
                                        if let uiImage = uiImages[safe: index] {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 75)
                                                .cornerRadius(4)
                                        } else {
                                            //Text("Image loading...")
                                            Image("logo_new")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 75)
                                                //.font(.system(size: 14))
                                        }

                                    }
                                    .padding(.horizontal,5)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        // Text(Arry[index])
                                        Text(Allprods[index].ProName)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 14))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                        Text(Allprods[index].ProID)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                        HStack {
                                            //Text("MRP ₹\(nubers[index])")
                                            Text("MRP 0")
                                                .font(.system(size: 13))
                                            Spacer()
                                            HStack{
                                                if filterItems[index].Dis != "" {
                                                Text("OFF:\(filterItems[index].Dis)%")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.green)
                                                
                                                ZStack{
                                                    Text("₹\(filterItems[index].DisVal)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    Rectangle()
                                                        .frame(width: 50,height: 1)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                                Text("Price: \(filterItems[index].ConvRate)")
                                                    .font(.system(size: 13))
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                        .padding(.trailing,10)
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
                                                    let proditem = Allprods[index]
                                                    print(proditem)
                                                    let FilterProduct = Allprods[index].Unit_Typ_Product
                                                    print(FilterProduct)
                                                    let id = proditem.ProID
                                                    
                                                    let selectproduct = $FilterProduct[index] as? AnyObject
                                                    print(selectproduct as Any)
                                                    let  sQty = String(filterItems[index].Amt)
                                                    print(sQty)
                                                    print(Allprods[index].ProID)
                                                    
                                                    let Ids = Allprods[index].ProID
                                                    print(Ids as Any)
                                                    
                                                    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                                                        print(Cart)
                                                        if (Cart["Pcode"] as! String) == Ids {
                                                            return true
                                                        }
                                                        return false
                                                    })
                                                    var selUOMConv: String = "1"
                                                    
                                                    if(items.count>0){
                                                        selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                                                        let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                        let TotalAmount = Double(Allprods[index].ProMRP)! * Double(uom)
                                                        filterItems[index].TotAmt=String(TotalAmount)
                                                    } else{
                                                        
                                                        selUOMConv=String(filterItems[index].Amt)
                                                        print(selUOMConv)
                                                        let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                        let TotalAmount = Double(Allprods[index].ProMRP)! * Double(uom)
                                                        filterItems[index].TotAmt=String(TotalAmount)
                                                    }
                                                    
                                                    minusQty(sQty: sQty, SelectProd: FilterProduct)
                                                    Qtycount()
                                                    TexQty()
                                                    //OfferDet()
                                                    
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
                                                    
                                                    let proditem = Allprods[index]
                                                    print(proditem)
                                                    let FilterProduct = Allprods[index].Unit_Typ_Product
                                                    print(FilterProduct)
                                                    
                                                    let selectproduct = $FilterProduct[index] as? AnyObject
                                                    print(selectproduct as Any)
                                                    let  sQty = String(filterItems[index].Amt)
                                                    print(sQty)
                                                    
                                                    print(Allprods[index].ProID)
                                                    
                                                    let Ids = Allprods[index].ProID
                                                    print(Ids as Any)
                                                    
                                                    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                                                        
                                                        if (Cart["Pcode"] as! String) == Ids {
                                                            return true
                                                        }
                                                        return false
                                                    })
                                                    var selUOMConv: String = "1"
                                                    
                                                    if(items.count>0){
                                                        selUOMConv=String(format: "%@", items[0]["UOMConv"] as! CVarArg)
                                                        let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                        let TotalAmount = Double(Allprods[index].ProMRP)! * Double(uom)
                                                        filterItems[index].TotAmt=String(TotalAmount)
                                                    } else{
                                                        
                                                        selUOMConv=String(filterItems[index].Amt)
                                                        print(selUOMConv)
                                                        let uom = Int(selUOMConv)! * (filterItems[index].Amt)
                                                        let TotalAmount = Double(Allprods[index].ProMRP)! * Double(uom)
                                                        filterItems[index].TotAmt=String(TotalAmount)
                                                    }
                                                    
                                                    
                                                    addQty(sQty: sQty, SelectProd: FilterProduct)
                                                    Qtycount()
                                                    TexQty()
                                                    
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
                                        .padding(.trailing,10)
                                        if filterItems[index].Free != "0" {
                                        HStack {
                                            Text("Free : \(filterItems[index].Free)")
                                                .font(.system(size: 14))
                                            
                                            if filterItems[index].Freeprdname != ""{
                                                
                                                Text("(\(filterItems[index].Freeprdname))")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.semibold)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.trailing,10)
                                    }
                                        
//                                        if filterItems[index].Dis != "" {
//                                            HStack {
//                                                Text("Disc : \(filterItems[index].Dis)")
//                                                    .font(.system(size: 14))
//
//
//                                                Spacer()
//                                                Text("₹\(filterItems[index].DisVal)")
//                                                    .font(.system(size: 14))
//                                                    .fontWeight(.semibold)
//                                            }
//                                            .padding(.trailing,10)
//                                        }
                                            
                                            HStack {
                                                Text("TAX : 0")
                                                    .font(.system(size: 14))
                                                
                                                
                                                Spacer()
                                                Text("₹0.00")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.trailing,10)
                                        
                                        Divider()
                                        HStack {
                                            Text("Total Qty: \(filterItems[index].Amt)")
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            let totalvalue = nubers[0]
                                            Text(filterItems[index].NetValu)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.trailing,10)
                                        
                                    }
                                    .padding(.vertical, 5)
                                     
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            
                        }
                        .cornerRadius(10)
                        .padding(.horizontal,10)
                    }
                        
                }
                    Button(action: {
                        if VisitData.shared.lstPrvOrder.count == 0{
                            ShowTost="Cart is Empty"
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }else{
                            OredSc.toggle()
                            SelPrvSc.toggle()
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
                                
                                Text("Item: \(VisitData.shared.lstPrvOrder.count)")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Qty : \(TotalQtyData)")
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
                    
                    NavigationLink(destination: SelPrvOrder(OredSc: $OredSc, SelPrvSc: $SelPrvSc), isActive: $SelPrvOrderNavigte) {
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
            Address(ADDaddress: $ADDaddress, SelMod: $SelMod, isChecked: $isChecked)
            
        })
    }
        if SelPrvSc{
            SelPrvOrder(OredSc: $OredSc, SelPrvSc: $SelPrvSc)
        }
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

               lProdItem = Allprods[index].Unit_Typ_Product
            print(lProdItem)
        print(VisitData.shared.ProductCart)
                selectProd = String(format: "%@",lProdItem["id"] as! CVarArg)
        print(selectProd)
                selNetWt = String(format: "%@", lProdItem["product_netwt"] as! CVarArg)
          // }
            let ConvQty=String(format: "%@", UOMNAME["CnvQty"] as! CVarArg)
            print(ConvQty)
           let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (item) in
                if item["Pcode"] as! String == selectProd {
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
        print(uiImages.count)
        uiImages.removeAll()
        
        for item in 0..<Allprods.count {
            let getdata = Allprods[item].ImgURL
            print(getdata)

            if let imageUrl = URL(string: getdata) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error fetching image: \(error)")
                        return
                    }

                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.uiImages.append(uiImage)
                            print(uiImage)
                        }
                    }
                }.resume()
            } else {
                print("Invalid URL: \(getdata)")
            }
        }


        print(uiImages.count)
        print(uiImages)
       }
    private func OrderProdTyp(){
        
        Sales_Order.prodTypes { json in
            if let jsonData = json.data(using: .utf8) {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        var prodTypes1 = [String]()
                        var Typofid = [Int]()
                        print(jsonArray)
                        let jsonArrays = jsonArray.filter { ($0["GroupId"] as? Int) == Int(selectedGorup!) }
                        print(jsonArrays)
                        for item in jsonArrays {
                          
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
    }
    private func OrderprodCate(at index: Int){
        SelectId = prodTypes3[index]
        print(SelectId)
        prodofcat.removeAll()
        Sales_Order.prodCate { json in
            print(json)
            if let jsonData = json.data(using: .utf8) {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        print(jsonArray)
                        print(SelectId)
                        
                        
                        let itemsWithTypID3 = jsonArray.filter { ($0["TypID"] as? Int) == SelectId }
                        print(itemsWithTypID3)
                        if !itemsWithTypID3.isEmpty {
                            for item in itemsWithTypID3 {
                                print(itemsWithTypID3)
                                
                                if let procat = item["name"] as? String, let proDetID = item["id"] as? Int {
                                    print(procat)
                                    print(proDetID)
                                    
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
                  print(itemsWithTypID3)
                    if !itemsWithTypID3.isEmpty {
                        Allprods.removeAll()
                        print(itemsWithTypID3.count)
                        for item in itemsWithTypID3 {
                            
                           // FilterProduct = itemsWithTypID3.map { $0 as AnyObject }
                            FilterProduct = itemsWithTypID3  as [AnyObject]
                            print(FilterProduct.count)
                            
                            if let procat = item["PImage"] as? String, let proname = item["name"] as? String ,  let MRP = item["Rate"] as? String, let Proid = item["id"] as? String,let sUoms = item["Division_Code"] as? Int, let sUomNms = item["Default_UOMQty"] as? String, let Uomname = item["Default_UOM_Name"] as? String{
                                print(procat)
                                print(proname)
                                print(Proid)
                                print(MRP)
                                print(sUoms)
                                print(sUomNms)
                                print(Uomname)
                                print(item)
                                
                                
                                
                                Allprods.append(Prodata(ImgURL: procat, ProName: proname, ProID: Proid, ProMRP:MRP,sUoms:sUoms,sUomNms:sUomNms, Uomname: Uomname, Unit_Typ_Product: item ))
                                
                                
                                
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
                    print(Allprods)
                    TexQty()
                    //GetingListAddress()
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
        var loopCounter = 0
        for item in FilterProduct{
            loopCounter += 1
           print(item)
            print(VisitData.shared.ProductCart)
            let id=String(format: "%@", item["id"] as! CVarArg)
            let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
                
                if Cart["Pcode"] as! String == id {
                    return true
                }
                return false
            })
            var FreeQty = ""
            var FreePrd = ""
            var Dis = ""
            var DisVal = ""
            if items.count>0 {
                 Qty = (items[0]["Qty"] as? String)!
                print(items[0]["Qty"] as? String as Any)
                print(items)
                Amount = String((items[0]["Value"] as? Double)!)
                let Uom = items[0]["UOMNm"] as? String
                let NetValue = String((items[0]["NetVal"] as? Double)!)
                let NetValue2 = String(format: "Rs. %.02f", (items[0]["NetVal"] as? Double)!)
                let UonConvRate = Double((items[0]["UOMConv"] as?String)!)! * (items[0]["Rate"] as? Double)!
                print(UonConvRate)
                let rate = String(format: "₹ %.02f", UonConvRate)
                let RateNewConv = (items[0]["Rate"] as? Double)!
                print(RateNewConv)
                Dis = (items[0]["Disc"] as? String)!
                DisVal = (items[0]["DisVal"] as? String)!
                FreeQty = String((items[0]["FQ"] as? Int)!)
                FreePrd = (items[0]["OffProdNm"] as? String)!
                SelectUOMN.append(editUom(Uon: Uom!, UomConv: String(rate), NetValu: NetValue2, Disc: Dis , Disvalue: DisVal , freeQty: FreeQty, OffProdNm: FreePrd))
                print(items)
                print(Amount as Any)
                TotalAmt.append(Amount)
                print(TotalAmt)
                
                TotalQty.append(Qty)
            }else{
                print(loopCounter - 1)
                let Cout:Int = loopCounter - 1
                print(FilterProduct)
                let UomQty = FilterProduct[0]["Default_UOM_Name"] as? String
                let Rate = FilterProduct[Cout]["Rate"] as? String
                SelectUOMN.append(editUom(Uon: UomQty!, UomConv: Rate!, NetValu: "0.0", Disc: "", Disvalue: "", freeQty: "0", OffProdNm: ""))
                let ZeroAmt = "0.0"
                let ZerQty = "0"
                TotalAmt.append(ZeroAmt)
                TotalQty.append(ZerQty)
            }
        }

        print(TotalQty)
        print(FilterProduct)
        print(SelectUOMN)
        print(TotalAmt)
        
        items.removeAll()
        for index in 0..<FilterProduct.count {
            print(index)
            print(filterItems)
            items.append(Sales_Order.TotAmt(id: index, Amt: Int(TotalQty[index])!, TotAmt:TotalAmt[index], SelectUom:SelectUOMN[index].Uon,ConvRate: SelectUOMN[index].UomConv,NetValu: SelectUOMN[index].NetValu, Free: SelectUOMN[index].freeQty , Freeprdname: SelectUOMN[index].OffProdNm , Dis: SelectUOMN[index].Disc, DisVal: SelectUOMN[index].Disvalue ))
            print(items)
        }
        
        print(items)
        print(Allprods)
        
        filterItems = items
        print(FilterProduct.count)
        print(filterItems)
    }
    
    func SchemeDet(){
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

}
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
       // SelPrvOrder()
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
    @State private var GetingAddress:[EdditeAddres]=[]
    @State private var ToastMessage:String = ""
    @State private var ShowToastMes:String = String()
    @State private var showToast:Bool = false
    @Binding var isChecked:Bool
 
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
                    Text(CustDet.shared.Addr)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                    
                    //.frame(width: 50, height: 50)
                }
                .frame(width: 350,height: 60)
                .cornerRadius(10)
                .onAppear{
                    
                    print(GetingAddress)
                }
                .onAppear{GetingListAddress()}
                ScrollView{
                ForEach(0..<GetingAddress.count, id: \.self) { index in
                    if #available(iOS 15.0, *) {
                        ZStack{
                            Color(red: 0.93, green: 0.94, blue: 0.95, opacity: 1.00)
                            HStack(){
                                HStack{
                                    Text(GetingAddress[index].address)
                                        .padding(.horizontal,10)
                                        .padding(.vertical,5)
                                    Spacer()
                                    //Text("")
                                }
                                .background(Color(red: 0.93, green: 0.94, blue: 0.95, opacity: 1.00))
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
                                                        GetingAddress.remove(at: index)
                                                        print(prettyPrintedJson)
                                                        
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                }
                                            }
                                    }
                            }
                            
                        }
                        .padding(.vertical,1)
                        .cornerRadius(10)
                        
                        
                        
                        .listRowSeparator(.hidden)
                    } else {
                        
                    }
                }
                .padding(.horizontal,10)
                .listStyle(PlainListStyle())
                .padding(.vertical, 5)
                //.background(Color.white)
                .background(Color.white)
            }
            Spacer()
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(ColorData.shared.HeaderColor)
                .onTapGesture {
                    AddressTextInpute = ""
                    selectedstate = "Select State"
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
                                if validateForm() == false {
                                    showToast.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showToast.toggle()
                                    }
                                    return
                                }
                                if let encodedAddress = AddressTextInpute.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"insert_ret_address"+"&listedDrCode=\(CustDet.shared.CusId)"+"&address=\(encodedAddress)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                                    AFdata in
                                    switch AFdata.result
                                    {
                                        
                                    case .success(let value):
                                        print(value)
                                        if let json = value as? [String: Any] {
                                            
                                            print(json)
                                            GetingListAddress()
                                            clickPlusButton.toggle()
                                            
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
                            if OpenMod == "Edit"{
                                if validateForm() == false {
                                    showToast.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showToast.toggle()
                                    }
                                    return
                                }
                                if let encodedAddress = AddressTextInpute.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"update_ret_address"+"&id=\(Editid)"+"&listedDrCode=\(CustDet.shared.CusId)"+"&address=\(encodedAddress)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                                    AFdata in
                                    switch AFdata.result
                                    {
                                        
                                    case .success(let value):
                                        print(value)
                                        if let json = value as? [String: Any] {
                                            
                                            print(json)
                                            GetingListAddress()
                                            clickPlusButton.toggle()
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
                        Button(action:{
                            selectedstate = Getstates[index].title
                            ClickStateButton.toggle()
                        })
                        {
     
                            
                            Text(Getstates[index].title)
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
        .toast(isPresented: $showToast, message: "\(ShowToastMes)")
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
    func GetingListAddress(){
        let axn = "get_ret_addresses&listedDrCode=\(CustDet.shared.CusId)"
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
    func validateForm() -> Bool{
        if selectedstate == "Select State"{
            ShowToastMes = "Select State"
            return false
        } else if AddressTextInpute == ""{
            ShowToastMes = "Enter Address"
            return false
        }
        return true
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
    @State private var ShowTost = ""
    @State private var showToast = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var OredSc:Bool
    @Binding var SelPrvSc:Bool
    @State private var items: [FilterItem] = []
    
    init(OredSc: Binding<Bool>,SelPrvSc: Binding<Bool>) {
        self._OredSc = OredSc
        self._SelPrvSc = SelPrvSc
       
        print(selectitemCount)
    
    }

   
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                    .edgesIgnoringSafeArea(.all)
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
                        
                        
                     
                        
                        Divider()
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 5)
                            
                            VStack{
                            HStack(){
                                Text("Items")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                Spacer()
                                Button(action:{
                                    //OrderNavigte = true
                                    OredSc.toggle()
                                    SelPrvSc.toggle()
                                    
                                }){
                                    Text("+ Add Product")
                                        .foregroundColor(Color.orange)
                                    
                                }
                            }
                            .padding(10)
                            .onAppear{
                                prvDet()
                            }
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 1)
                                    .padding(.horizontal,10)
                                
                                HStack{
                                    VStack{
                                        Text("SKC")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                        Text("Rate")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    
                                    Text("UOM")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                    Spacer(minLength: 5)
                                    Text("Qty")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                    Spacer(minLength: -5)
                                    Text("TAX")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                    Spacer(minLength: 5)
                                    Text("Total")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                    //Spacer(minLength: 5)
                                    
                                }
                                .padding(.horizontal,10)
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 1)
                                    .padding(.horizontal,10)
                                
                            ScrollView{
                                ForEach(AllPrvprod.indices, id: \.self) { index in
                                    VStack{
                                        HStack{
                                            Text(AllPrvprod[index].ProName)
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .padding(.leading,10)
                                            Spacer()
                                        }
                                        HStack{
                                            Text("₹\(String(format: "%.2f", Double(AllPrvprod[index].ProMRP)!))")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            
                                            Text(AllPrvprod[index].Uomnm)
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer(minLength: 5)
                                            
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
                                                                let itemsWithTypID3 = jsonArray.filter { ($0["id"] as? String) == ProId }
                                                                
                                                                if !itemsWithTypID3.isEmpty {
                                                                    for item in itemsWithTypID3 {
                                                                        let Qty = String(filterItems[index].quantity)
                                                                        minusQty(sQty: Qty, SelectProd: item)
                                                                        Qtycount()
                                                                        prvDet()
                                                                        
                                                                        
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
                                                    .font(.system(size: 14))
                                                Button(action:{
                                                    filterItems[index].quantity += 1
                                                    print(AllPrvprod[index].ProID)
                                                    let ProId = AllPrvprod[index].ProID
                                                    if let jsonData = Allproddata.data(using: .utf8){
                                                        do{
                                                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                                print(jsonArray)
                                                                let itemsWithTypID3 = jsonArray.filter { ($0["id"] as? String) == ProId }
                                                                
                                                                if !itemsWithTypID3.isEmpty {
                                                                    for item in itemsWithTypID3 {
                                                                        let Qty = String(filterItems[index].quantity)
                                                                        addQty(sQty: Qty, SelectProd: item)
                                                                        Qtycount()
                                                                        prvDet()
                                                                        
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
                                            .frame(width: 60)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 15)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray, lineWidth: 2)
                                            )
                                            .foregroundColor(Color.blue)
                                            Spacer(minLength: 3)
                                            //Remove Button
                                            Button(action: {
                                                deleteItem(at: index)
                                                AllPrvprod.remove(at: index)
                                                prvDet()
                                                print(AllPrvprod)
                                            }) {
                                                Image(systemName: "trash.fill")
                                                    .foregroundColor(Color.red)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Spacer(minLength: 5)
                                            
                                            Text("00.0")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            
                                            
                                            Text("₹\(Double(AllPrvprod[index].ProMRP)! * Double(filterItems[index].quantity), specifier: "%.2f")")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            
                                        }
                                        .padding(.horizontal,10)
                                    }
                                }
                                VStack{
                                    HStack{
                                        Text("PRICE DETAILS")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                        Spacer()
                                    }
                                    .padding(.horizontal,10)
                                    Divider()
                                        .padding(.horizontal,10)
                                    VStack{
                                        HStack{
                                         Text("Price(\(VisitData.shared.lstPrvOrder.count)items)")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                        Text("\(lblTotAmt)")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal,10)
                                        HStack{
                                            Text("Total Qty")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("\(TotalQtyData)")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                        }.padding(.horizontal,10)
                                        HStack{
                                            Text("GST 10%")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("000.00")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal,10)
                                        HStack{
                                            Text("GST 18%")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("000.00")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal,10)
                                        
                                        Rectangle()
                                            .frame(height: 1)
                                            .padding(.horizontal,10)
                                        
                                        HStack{
                                            Text("TO PAY")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("\(lblTotAmt)")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal,10)
                                        Rectangle()
                                            .frame(height: 1)
                                            .padding(.horizontal,10)
                                    }
                                }
                                .padding(.top,30)
                            }
                        }
                    }
                        .padding(.horizontal,6)
                        .padding(.bottom,30)
                    }
                    .edgesIgnoringSafeArea(.top)
                   
                    Spacer()
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 100)
                        
                        Button(action:{
                            
                            //getLocation()
                            if VisitData.shared.lstPrvOrder.count == 0{
                                ShowTost="Cart is Empty"
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }else{
                                showAlert = true
                            }
                            
                        }) {
                            
                            VStack(spacing:-1){
                                HStack (){
                                    
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                        .frame(width: 60,height: 40)
                                    
                                    Text("Item: \(VisitData.shared.lstPrvOrder.count)")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Qty : \(TotalQtyData)")
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
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
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
            .toast(isPresented: $showToast, message: "\(ShowTost)")
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
    func prvDet(){
        
        print(VisitData.shared.lstPrvOrder)
        var ProSelectID = [String]()
        print(VisitData.shared.lstPrvOrder.count)
        for itemID in VisitData.shared.lstPrvOrder{
            let id =  itemID["id"] as! String
            ProSelectID.append(id)
        }
        print(ProSelectID)
        print(Allproddata)
        AllPrvprod.removeAll()
        items.removeAll()
        if let jsonData = Allproddata.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    print(jsonArray)
                    for RelID in ProSelectID {
                        print(RelID)
                        //Changes
                        if let selectedPro = jsonArray.first(where: { ($0["id"] as! String) == RelID }) {
                            FilterItem.append(selectedPro)
                        }
                    }
                    
                }
            } catch {
                print("Error is \(error)")
            }
            
            
            for PrvOrderData in VisitData.shared.lstPrvOrder{
                print(PrvOrderData)
                let RelID = PrvOrderData["Pcode"] as? String
                let Uomnm = PrvOrderData["UOMNm"] as? String
                let Qty = PrvOrderData["Qty"] as? String
                let totAmt = PrvOrderData["NetVal"] as? Double
                print(totAmt as Any)
                
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        print(jsonArray)
                        if let selectedPro = jsonArray.first(where: { ($0["id"] as! String) == RelID }) {
                            print(selectedPro)
                            
                            
                            let url = selectedPro["PImage"] as? String
                            let name  = selectedPro["name"] as? String
                            let Proid = selectedPro["id"] as? String
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
            
            
            var qty=[String]()
            
            for items in VisitData.shared.lstPrvOrder {
              let  qtys = (items["Qty"] as? String)!
                qty.append(qtys)
            }
            print(VisitData.shared.lstPrvOrder.count)
            print(VisitData.shared.ProductCart.count)
            print(qty)
            
            for index in 0..<VisitData.shared.lstPrvOrder.count {
                print(index)
                items.append(Sales_Order.FilterItem(id: index, quantity: Int(qty[index])!))
            }
            print(items)
            filterItems = items
            
            print(AllPrvprod.count)
            print(VisitData.shared.lstPrvOrder.count)
            print(filterItems.count)
            print(filterItems)
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
    let TotQty2: Double = Double((sQty as NSString).intValue * (sUomConv as NSString).intValue)
    let TotQty: Double = Double((sQty as NSString).intValue)
    var source: Double = Double()
    var OrgRate: Double = 0.0 // Assuming a default valu
    if let ConvRate = ProdItem["Rate"] as? String,
       let UomQty = Double(sUomConv) {
        OrgRate = Double(ConvRate) ?? 0.00
        source = OrgRate * UomQty
        print(OrgRate)
        print(UomQty)
    }
    let Source1 = String(format: "%.02f", source)
    let Rate: Double = Double(Source1)!
    print(ProdItem)
   
    print(OrgRate)
    var ItmValue: Double = (TotQty*Rate)
    print(ItmValue)
    
    
    var Scheme: Double = 0
    var FQ : Int32 = 0
    var OffQty: Int = 0
    var OffProd: String = ""
    var OffProdNm: String = ""
    var Schmval: String = ""
    var Disc: String = ""
    var PCODE: String = ""
    
    if let Code = ProdItem["id"] as? String{
        PCODE = Code
    }
    var lstSchemListdata:[AnyObject] = []
    if let list = GlobalFunc.convertToDictionary(text: lstSchemList) as? [AnyObject] {
        lstSchemListdata = list;
        print(lstSchemListdata)
    }
    
    var Schemes: [AnyObject] = lstSchemListdata.filter ({ (item) in
        print(item)
        print(PCODE)
        print(TotQty2)
        
        if item["PCode"] as! String == PCODE && (item["Scheme"] as! NSString).doubleValue <= TotQty2 {
            return true
        }
        return false
    })
    if(Schemes.count>1){Schemes.remove(at: 0)}
    print(Schemes)
    if(Schemes.count>0){
        Scheme = (Schemes[0]["Scheme"] as! NSString).doubleValue
        FQ = (Schemes[0]["FQ"] as! NSString).intValue
        let SchmQty: Double
        if(Schemes[0]["pkg"] as! String == "Y"){
            SchmQty=Double(Int(TotQty / Scheme))
        } else {
            SchmQty = (TotQty / Scheme)
        }
        OffQty = Int(SchmQty * Double(FQ))
        OffProd = Schemes[0]["OffProd"] as! String
        OffProdNm = Schemes[0]["OffProdNm"] as! String
        
        var dis: Double = 0;
        Disc = Schemes[0]["Disc"] as! String
        if (Disc != "") {
            print(ItmValue)
            dis = ItmValue * (Double(Disc)! / 100);
            print(dis)
        }
        Schmval = String(format: "%.02f", dis);
        ItmValue = ItmValue - dis;
        print(ItmValue)
    }
    
    print(Scheme)
    print(FQ)
    print(OffQty)
    print(OffProd)
    print(OffProdNm)
    print(Schmval)
    print(Disc)
    if items.count>0 {
        print(VisitData.shared.ProductCart)
        if let i = VisitData.shared.ProductCart.firstIndex(where: { (item) in
            if item["Pcode"] as! String == PCODE {
                return true
            }
            return false
        })
        {
            let itm: [String: Any]=["id": id,"Pcode": PCODE,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm,"Rate": OrgRate,"Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": (TotQty*Rate)];
            print(itm)
            let jitm: AnyObject = itm as AnyObject
            VisitData.shared.ProductCart[i] = jitm
            print("\(VisitData.shared.ProductCart[i]) starts with 'A'!")
        }
    }else{
        let itm: [String: Any]=["id": id,"Pcode": PCODE,"Qty": sQty,"UOM": sUom, "UOMNm": sUomNm, "UOMConv": sUomConv, "SalQty": TotQty,"NetWt": sNetUnt,"Scheme": Scheme,"FQ": FQ,"OffQty": OffQty,"OffProd":OffProd,"OffProdNm":OffProdNm, "Rate": OrgRate, "Value": (TotQty*Rate), "Disc": Disc, "DisVal": Schmval, "NetVal": (TotQty*Rate)];
        let jitm: AnyObject = itm as AnyObject
        print(itm)
        VisitData.shared.ProductCart.append(jitm)
    }
    print(VisitData.shared.ProductCart)
    var lstPrv:[AnyObject] = []
    lstPrv = VisitData.shared.ProductCart.filter ({ (Cart) in
        if (Cart["SalQty"] as! Double) > 0 {
            return true
        }
        return false
    })
    print(lstPrv.count)
    print(lstPrv)
    VisitData.shared.lstPrvOrder = lstPrv
    print(VisitData.shared.lstPrvOrder.count)
    selectitemCount = VisitData.shared.lstPrvOrder.count
    updateOrderValues(refresh: 1)
}


func addQty(sQty:String,SelectProd:[String:Any]) {
    
    print(sQty)
    print(SelectProd)
  
    let Ids = SelectProd["id"] as? String
    print(Ids as Any)
    print(VisitData.shared.ProductCart)
    let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
        
        if (Cart["Pcode"] as! String) == Ids {
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
   
     let Ids = SelectProd["id"] as? String
     print(Ids as Any)
     
     let items: [AnyObject] = VisitData.shared.ProductCart.filter ({ (Cart) in
         
         if Cart["Pcode"] as! String == Ids {
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
    print(VisitData.shared.lstPrvOrder.count)
    
    VisitData.shared.lstPrvOrder = VisitData.shared.ProductCart.filter ({ (Cart) in
        print(VisitData.shared.lstPrvOrder)
        if (Cart["SalQty"] as! Double) > 0 {
            return true
        }
        return false
    })
    print(VisitData.shared.lstPrvOrder)
    if VisitData.shared.lstPrvOrder.count>0 {
        for i in 0...VisitData.shared.lstPrvOrder.count-1 {
            let item: AnyObject = VisitData.shared.lstPrvOrder[i]
            print(item["NetVal"] as! Double)
            totAmt = totAmt + (item["NetVal"] as! Double)
            print(totAmt)
            print(item["NetVal"] as! Double)
            TotamtlistShow = String(totAmt)
            //(item["SalQty"] as! NSString).doubleValue

        }
    }
    print(VisitData.shared.lstPrvOrder.count)
    lblTotAmt = String(format: "Rs. %.02f", totAmt)
    lblTotAmt2 = String(totAmt)
    print(totAmt)
    if(refresh == 1){
     
    }

}
func deleteItem(at index: Int) {
    print(VisitData.shared.lstPrvOrder)
    print(VisitData.shared.ProductCart)
    var ids = [String]()
    var id = ""
    for allid in VisitData.shared.lstPrvOrder{
        ids.append(allid["id"] as! String)
    }
    id = ids[index]
    print(ids)
    print(id)
    VisitData.shared.lstPrvOrder.remove(at: index)
    VisitData.shared.ProductCart.removeAll(where: { (item) in
        if item["id"] as! String == id {
            return true
        }
        return false
    })
    print(VisitData.shared.lstPrvOrder)
    print(VisitData.shared.ProductCart)
    updateOrderValues(refresh: 1)
}
//9167497578
func OrderSubmit(lat:String,log:String) {
    
    print(VisitData.shared.lstPrvOrder.count)
  print(lat)
    print(log)
    
    var sPItems:String = ""
    for i in 0..<VisitData.shared.lstPrvOrder.count {
        guard let item = VisitData.shared.lstPrvOrder[i] as? [String: Any],
              let id = item["id"] as? String else {
            continue
        }
        
        var prodItems: [[String: Any]] = []
        
        if let jsonData = LstAllproddata.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    prodItems = jsonArray.filter { product in
                        if let prodId = product["id"] as? String {
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
               sPItems = sPItems + " \"Product_Amount\":" + (String(format: "%.2f", item["NetVal"] as! Double)) + ","
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
    
    let jsonString = "[{\"Activity_Report_Head\":{\"SF\":\"\(CustDet.shared.CusId)\",\"Worktype_code\":\"0\",\"Town_code\":\"\",\"dcr_activity_date\":\"\(currentDateTime)\",\"Daywise_Remarks\":\"\",\"UKey\":\"EKSf_Code654147271\",\"orderValue\":\"\(lblTotAmt2)\",\"billingAddress\":\"\(BillingAddress)\",\"shippingAddress\":\"\(ShpingAddress)\",\"DataSF\":\"\(CustDet.shared.CusId)\",\"AppVer\":\"1.2\"},\"Activity_Doctor_Report\":{\"Doc_Meet_Time\":\"\(currentDateTime)\",\"modified_time\":\"\(currentDateTime)\",\"stockist_code\":\"\(CustDet.shared.StkID)\",\"stockist_name\":\"Relivet Animal Health\",\"orderValue\":\"\(lblTotAmt2)\",\"CashDiscount\":0,\"NetAmount\":\"\(lblTotAmt2)\",\"No_Of_items\":\"\(VisitData.shared.lstPrvOrder.count)\",\"Invoice_Flag\":\"\",\"TransSlNo\":\"\",\"doctor_code\":\"\(CustDet.shared.CusId)\",\"doctor_name\":\"Kartik Test\",\"ordertype\":\"order\",\"deliveryDate\":\"\",\"category_type\":\"\",\"Lat\":\"\(lat)\",\"Long\":\"\(log)\",\"TOT_TAX_details\":[{\"Tax_Type\":\"GST 12%\",\"Tax_Amt\":\"56.17\"}]},\"Order_Details\":[" + sPItems +  "]}]"

    
    
    let params: Parameters = [
        "data": jsonString
    ]
    
    print(params)
    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"save/salescalls"+"&divisionCode=\(CustDet.shared.Div)"+"&Sf_code=\(CustDet.shared.CusId)", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
    AFdata in
    switch AFdata.result
    {
        
    case .success(let value):
        print(value)
        if let json = value as? [String: Any] {
            
            
           print(json)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: HomePage())
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

func Qtycount() {
    var qtysdata = [Int]()
    qtysdata.removeAll()
    for items in VisitData.shared.lstPrvOrder {
        if let qtyString = items["Qty"] as? String, let qty = Int(qtyString) {
            print(qty)
            qtysdata.append(qty)
            //TotalQtyData += qty
        }
        
    }
    print(qtysdata)
    let sum = qtysdata.reduce(0, +)
    print(sum) // Output: 3
    TotalQtyData = sum
    print(TotalQtyData)
}

