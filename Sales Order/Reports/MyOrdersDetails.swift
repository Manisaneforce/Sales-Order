//
//  MyOrdersDetails.swift
//  Sales Order
//
//  Created by San eforce on 05/09/23.
//

import SwiftUI
import Alamofire
import WebKit
struct getInvoice: Any{
    let Status:String
    let OrderID:String
    let Date:String
    let Order_Value:String
    let Product_Name:String
    let Quantity:String
    let Saledoc_No:String
}
//var invoice:[getInvoice]=[]
var value:String = ""
var Orderdate:String = ""
struct MyOrdersDetails: View {
    @State private var selectedDate = Date()
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = ""
    @State private var ToDate = ""
    @State private var CalenderTit = ""
    @State private var Filterdate = false
    @State private var invoice:[getInvoice]=[]
    @State private var navigateToHomepage = false
    @State private var currentTab: Int = 0
    @State private var HistoryInf:Bool = true
    @State private var OrderDetialsView:Bool = false
    @State private var Loader:Bool = true
    @State var OrderId = ""
    @State var Totalval = value
    @State private var SelectFromDate = Date()
    @State private var isHiden:Bool = false
    @State private var Pdf_String:String = ""
    @State private var Navi_pdf_View:Bool = false
    @State private var Main_View:Bool = true
    @ObservedObject var monitor = Monitor()
    @State private var showToast = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let currentDate = Date()
    let calendar = Calendar.current
    var body: some View {
        NavigationView{
           if Main_View{
                ZStack{
                    Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .frame(height: 80)
                            if monitor.status == .connected {
                                HStack {
                                    
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    })
                                    {
                                        Image("backsmall")
                                        
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .padding(.top,50)
                                            .frame(width: 50)
                                    }
                                    Text("History Info")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top,50)
                                    Spacer()
                                }
                            }else{
                                Internet_Connection()
                            }
                            NavigationLink(destination: HomePage(), isActive: $navigateToHomepage) {
                                EmptyView()
                            }
                        } .onReceive(monitor.$status) { newStatus in
                            if newStatus == .connected {
                            }
                        }
                        .edgesIgnoringSafeArea(.top)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                        
                        .onAppear{
                            let fromDate = String(dateFormatter.string(from:selectedDate))
                            print(fromDate)
                            FromDate = fromDate
                            ToDate = fromDate
                            orderandinvoice()
                            Loader.toggle()
                        }
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                                
                                HStack {
                                    Text(FromDate)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.blue)
                                }.padding(.horizontal,5)
                            }
                            .onTapGesture {
                                SelMode = "DOF"
                                CalenderTit = "Select Date"
                                isPopoverVisible.toggle()
                                
                            }
                            .padding(10)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                                HStack {
                                    Text(ToDate)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.blue)
                                }.padding(.horizontal,5)
                            }
                            .onTapGesture {
                                SelMode = "DOT"
                                CalenderTit = "Select From Date"
                                isPopoverVisible.toggle()
                                
                            }
                            .padding(10)
                            VStack{
                                Image(systemName: "chevron.down.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.blue)
                            }
                            .onTapGesture {
                                Filterdate.toggle()
                            }
                            
                            .padding(10)
                        }
                        .frame(height: 60)
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                            TabBarView(currentTab: $currentTab)
                        }
                        .frame(height:40)
                        .padding(.leading,2)
                        .padding(.trailing,2)
                        TapBar(HistoryInf: $HistoryInf, OrderDetialsView: $OrderDetialsView, currentTab: $currentTab, invoice: $invoice, OrderId: $OrderId, isHiden: $isHiden, Loader: $Loader,Pdf_String: $Pdf_String,Navi_pdf_View: $Navi_pdf_View,Main_View:$Main_View, showToast: $showToast)
                        Spacer()
                    }
                    .popover(isPresented: $isPopoverVisible) {
                        VStack{
                            ZStack{
                                Rectangle()
                                    .foregroundColor(ColorData.shared.HeaderColor)
                                    .frame(height: 60)
                                //.padding(20)
                                Text("Select Date")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top,10)
                            }
                            .edgesIgnoringSafeArea(.top)
                            .padding(.top,-18)
                            //.padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
                            Spacer()
                            VStack {
                                
                                CalendarView(selectedDate:$selectedDate, SelMode: $SelMode, SelectFromDate: $SelectFromDate)
                                    .frame(height: 500)
                                    .padding()
                                
                                Spacer()
                                Button(action:{
                                    Selectdate()
                                    Loader.toggle()
                                    isPopoverVisible.toggle()
                                }){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(ColorData.shared.HeaderColor)
                                            .frame(height: 60)
                                        Text("Submit Date")
                                            .foregroundColor(.white)
                                    }
                                }
                                .edgesIgnoringSafeArea(.bottom)
                                .padding(.bottom,-37)
                                
                            }
                        }
                        
                    }
                    
                    if Filterdate{
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                // Filterdate.toggle()
                            }
                        VStack{
                            ZStack{
                                Rectangle()
                                    .foregroundColor(ColorData.shared.HeaderColor)
                                    .frame(height: 30)
                                VStack{
                                    Text("Select Quick Dates")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            VStack{
                                VStack{
                                    
                                    Text("Last 7 days")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                    
                                }
                                .background(Color.white)
                                .onTapGesture{
                                    var CurentDate = Date()
                                    Loader.toggle()
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                                    SelectFromDate = (formattedDates(date: calculateStartDate(for: 7))!)
                                    let ToDates = String(dateFormatter.string(from:CurentDate))
                                    ToDate = ToDates
                                    orderandinvoice()
                                    
                                    
                                }
                                
                                Divider()
                                VStack{
                                    Text("Last 30 days")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .padding(5)
                                }
                                .background(Color.white)
                                .onTapGesture{
                                    var CurentDate = Date()
                                    Loader.toggle()
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 30)))
                                    SelectFromDate = (formattedDates(date: calculateStartDate(for: 30))!)
                                    let ToDates = String(dateFormatter.string(from:CurentDate))
                                    ToDate = ToDates
                                    orderandinvoice()
                                }
                            }
                            ZStack{
                                Rectangle()
                                    .foregroundColor(ColorData.shared.HeaderColor)
                                    .frame(height: 30)
                                    .padding(.top,30)
                                    .padding(.bottom,10)
                                    .padding(.horizontal,15)
                                    .cornerRadius(10)
                                VStack{
                                    Text("Close")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .padding(.top,15)
                                }
                            }.cornerRadius(10)
                                .onTapGesture {
                                    Filterdate.toggle()
                                }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(20)
                    }
                    //                if Loader{
                    //                    ZStack{
                    //                    Color.black.opacity(0.5)
                    //                        .edgesIgnoringSafeArea(.all)
                    //                        .onTapGesture {
                    //                               // GetLoction.toggle()
                    //                        }
                    //                    HStack{
                    //                        LottieUIView(filename: "loader").frame(width: 50,height: 50)
                    //                            .padding(.horizontal,20)
                    //                        Text("Verifying...")
                    //                            .font(.headline)
                    //                            .fontWeight(.bold)
                    //                            .multilineTextAlignment(.center)
                    //                            .padding(.vertical,20)
                    //                            .padding(.trailing,20)
                    //                    }
                    //                    .background(Color.white)
                    //                    .cornerRadius(10)
                    //                    .padding(20)
                    //
                    //                }
                    //            }
                }
                .toast(isPresented: $showToast, message: "Not inviced")
            }
            if Navi_pdf_View {
                PDFWebView(pdfData: Data(base64Encoded: Pdf_String) ?? Data(),Navi_pdf_View: $Navi_pdf_View,Main_View: $Main_View)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
           
            NavigationLink(destination: OrderDetView(OrderId:$OrderId, Orderdate: .constant(Orderdate), TotalVal: .constant(value)), isActive: $OrderDetialsView) {
                    }
    }
    private var dateFormatter: DateFormatter {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          return formatter
      }
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func formattedDates(date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: formattedDateString)
    }
    private  func Selectdate(){
          if SelMode == "DOF"{
             // FromDate = selectedDate
              SelectFromDate = selectedDate
              FromDate=dateFormatter.string(from: selectedDate)
              orderandinvoice()
          }
          if SelMode == "DOT"{
              //ToDate = selectedDate
              ToDate = dateFormatter.string(from: selectedDate)
              orderandinvoice()
          }
      }
    private func orderandinvoice(){
        if (From_To_Date.shared.SetDate == 1){
            FromDate = From_To_Date.shared.From
            ToDate = From_To_Date.shared.To
            From_To_Date.shared.SetDate = 0
        }
        
        let axn = "get/orderandinvoice"
        let apiKey: String = "\(axn)"
        From_To_Date.shared.From = FromDate
        From_To_Date.shared.To = ToDate
        let aFormData: [String: Any] = [
            "RetailId": "\(CustDet.shared.CusId)",
              "fdt": "\(FromDate)",
              "tdt": "\(ToDate)"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = [
            "data": jsonString
        ]
       print(params)
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { response in
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
                    
                    invoice.removeAll()
                    if let jsonData = prettyPrintedJson.data(using: .utf8){
                        do{
                            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                if let orders = jsonObject["Orders"] as? [[String: Any]] {
                                  print(orders)
                                    for itemsdata in orders{
                                        print(itemsdata)
                                        let Status = itemsdata["invoiceStatus"] as? String
                                        let OrderID = itemsdata["OrderID"] as? String
                                        let Order_Value = String(format: "%.2f", (itemsdata["Order_Value"] as? Double)!)
                                        let Date = itemsdata["Date"] as? String
                                        let Saledoc = itemsdata["Saledoc_No"] as? String
                                        var OrderDetails = [String]()
                                        var ProQty = [String]()
                                        if let Details = itemsdata["Details"] as? [[String: Any]]{
                                            for Proname in Details{
                                                let Product_Name = Proname["Product_Name"] as? String
                                                let Quantity = String((Proname["Quantity"] as? Int)!)
                                                OrderDetails.append(Product_Name!)
                                                ProQty.append(Quantity)
                                                
                                            }
                                        }else{
                                            print("No data")
                                        }
                                        print(OrderDetails)
                                        print(ProQty)
                                        let productNames = OrderDetails.joined(separator: ", ")
                                        let qty =  ProQty.joined(separator: ",")
                                        print(qty)
                                        invoice.append(getInvoice(Status: Status!, OrderID: OrderID!, Date: Date!, Order_Value: String(Order_Value), Product_Name: productNames, Quantity: qty, Saledoc_No : Saledoc!))
                                    }
                                    print(invoice)

                                } else {
                                    print("Error: Couldn't extract HTML")
                                }
                            }
                        } catch{
                            print("Error Data")
                        }
                    }
                 }
            case .failure(let error):
                print(error)
            }
        }
    }
   private func calculateStartDate(for days: Int) -> Date {
        let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
        return startDate ?? currentDate
    }
}

struct MyOrdersDetails_Previews: PreviewProvider {
    static var previews: some View {
        MyOrdersDetails()
    }
}
 
struct TapBar: View {
    @Binding var HistoryInf:Bool
    @Binding var OrderDetialsView:Bool
    @Binding var currentTab: Int
    @Binding var invoice: [getInvoice]
    @Binding var OrderId: String
    @Binding var isHiden:Bool
    @Binding var Loader:Bool
    @Binding var Pdf_String:String
    @Binding var Navi_pdf_View:Bool
    @Binding var Main_View:Bool
    @Binding var showToast:Bool
    var body: some View {
        ZStack(alignment:.top){
        TabView(selection: $currentTab) {
            ORDER(invoice: $invoice,HistoryInf: $HistoryInf,OrderDetialsView: $OrderDetialsView, OrderId: $OrderId, isHiden: $isHiden, Loader: $Loader)
                .tag(0)
//            INVOICE()
//                .tag(1)
            ORDERVSINVOICE(invoice: $invoice, Loader: $Loader,Pdf_String: $Pdf_String,Navi_pdf_View: $Navi_pdf_View,Main_View: $Main_View, showToast: $showToast)
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never)).edgesIgnoringSafeArea(.all)
    }
    }
}
struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    //var tabBarOptions: [String] = ["ORDER", "INVOICE", "ORDER VS INVOICE"]
    var tabBarOptions: [String] = ["ORDER","ORDER VS INVOICE"]
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(zip(tabBarOptions.indices, tabBarOptions)), id: \.0) { index, name in
                TabBarItem(currentTab: self.$currentTab, namespace: namespace.self, TabBarItemName: name, tab: index)
            }
            
        }
        .padding(.trailing,20)
//        .background(Color.gray)
        //.frame(height: 80)
        //.edgesIgnoringSafeArea(.all)
    }
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace:Namespace.ID
    var TabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button(action: {
            currentTab = tab
        }) {
            VStack {
                Spacer()
                Text(TabBarItemName)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                if currentTab == tab{
                    Color.white
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underLine", in: namespace,
                                               properties: .frame   )
                }else{
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(),value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct ViOredr:Any{
   
    let ProName:String
    let Qty:String
}
struct ORDER:View{
    @Binding var invoice: [getInvoice]
    @Binding var HistoryInf:Bool
    @Binding var OrderDetialsView:Bool
    @State private var OrderDetialsView2 = false
    @State private var ProName = [String]()
    @State private var Qty = [String]()
    @Binding var OrderId:String
    @State private var Totalval:String = ""
    @Binding var isHiden:Bool
    @State private var values = 0
    @Binding var Loader : Bool
    var body: some View{
        VStack{
            if Loader{
                ScrollView(showsIndicators: false){
                    ForEach(0 ..< invoice.count, id: \.self) { index in
                        ShimmeringSkeletonRow_For_Order()
                            .transition(.opacity)
                            .onAppear{
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        withAnimation {
                            Loader = false
                        }
                    }}
                     
                    }
                }
            }
            else{
            if (invoice.count != 0){
                ScrollView{
                    ForEach(0..<invoice.count, id: \.self) { index in
                        GeometryReader { reader -> AnyView in
                            let yAxis = reader.frame(in: .global).minY
                            
                            if yAxis < 0 && !isHiden {
                                DispatchQueue.main.async {
                                    withAnimation { isHiden = true }
                                    values += 1
                                }
                            }
                            
                            if yAxis > 0 && isHiden {
                                DispatchQueue.main.async {
                                    withAnimation { isHiden = false }
                                    values -= 1
                                }
                            }
                            
                            return AnyView(
                                Text("")
                                    .frame(width: 0, height: 0)
                            )
                        }
                        .frame(width: 0, height: 0)
                        VStack{
                            HStack{
                                Text(CustDet.shared.StkNm)
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                Spacer()
                                Text("Pending")
                                    .font(.system(size: 14))
                                Image(systemName:"ellipsis.circle.fill")
                                    .resizable()
                                    .frame(width: 12,height: 12)
                                    .foregroundColor(.red)
                                
                                
                            }
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            VStack(spacing:6){
                                HStack{
                                    Text(invoice[index].OrderID)
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                                .padding(.leading,10 )
                                HStack{
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 10,height: 10)
                                        .foregroundColor(.green)
                                    Text(invoice[index].Date)
                                        .font(.system(size: 13))
                                    Spacer()
                                }
                                .padding(.leading,10)
                            }
                            HStack{
                                Text("₹ \(invoice[index].Order_Value)")
                                    .font(.system(size: 14))
                                Spacer()
                                Text("View Order")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        Totalval=invoice[index].Order_Value
                                        value = Totalval
                                        OrderId = invoice[index].OrderID
                                        OrderNo = OrderId
                                        Orderdate = invoice[index].Date
                                        HistoryInf.toggle()
                                        OrderDetialsView.toggle()
                                        OrderDetialsView2.toggle()
                                        
                                        
                                        let productNames = invoice[index].Product_Name.split(separator: ",")
                                        let aFormData: [String] = productNames.map { String($0) }
                                        let NoOfQty = invoice[index].Quantity.split(separator: ",")
                                        let aFormDataQty:[String] = NoOfQty.map{
                                            String($0)
                                        }
                                        
                                        for character in aFormData {
                                            let trimmedCharacter = (character as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                                            if let trimmedCharacter = trimmedCharacter {
                                                print(trimmedCharacter)
                                                ProName.append(trimmedCharacter)
                                            }
                                        }
                                        for items in aFormDataQty{
                                            let trimmedCharacter = (items as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                                            if let trimmedCharacter = trimmedCharacter{
                                                print(trimmedCharacter)
                                                Qty.append(trimmedCharacter)
                                            }
                                        }
                                        
                                        print(ProName.count)
                                        print(Qty.count)
                                     
                                    }
                               
                            }
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            
                            //                                        Rectangle()
                            //                                            .strokeBorder(style: StrokeStyle(lineWidth: 2,dash: [5]))
                            //                                            .foregroundColor(.gray)
                            //                                            .frame(height: 2)
                            //                                            .padding(10)
                            //                                        HStack{
                            //                                            Text(invoice[index].Product_Name)
                            //                                                .font(.system(size: 14))
                            //                                                .foregroundColor(.gray)
                            //                                            Spacer()
                            //                                        }
                            //                                            .padding(10)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black)
                                .padding(10)
                        }
                    }
                }
            }else{
                NoOrderdate()
                Spacer()
            }
        }
            
        }
    }
}
struct ORDERVSINVOICE:View{
    @Binding var invoice: [getInvoice]
    @Binding var Loader : Bool
    @Binding var Pdf_String:String
    @Binding var Navi_pdf_View:Bool
    @Binding var Main_View:Bool
    @Binding var showToast:Bool
    var body: some View{
            VStack{
                HStack(spacing:160){
                    Text("ORDER")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Text("INVOICE")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                if Loader{
                    ScrollView(showsIndicators: false){
                        ForEach(0 ..< invoice.count, id: \.self) { index in
                            ShimmeringSkeletonRow()
                                .transition(.opacity)
                                .onAppear{
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                        withAnimation {
                                            Loader = false
                                        }
                                    }}
                            
                        }
                    }
                }
                else{
                    if (invoice.count != 0){
                        ScrollView{
                            
                            ForEach(0..<invoice.count, id: \.self) { index in
                                VStack(spacing:0){
                                    HStack{
                                        Text("Relivet Animal Health")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .padding(.leading,10)
                                        Spacer()
                                    }
                                    HStack{
                                        VStack{
                                            HStack{
                                                Text(invoice[index].OrderID)
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                Spacer()
                                            }
                                            VStack(spacing:0){
                                                HStack{
                                                    Image(systemName: "calendar")
                                                        .resizable()
                                                        .frame(width: 10,height: 10)
                                                        .foregroundColor(.green)
                                                    Text(invoice[index].Date)
                                                        .font(.system(size: 13))
                                                    Spacer()
                                                }
                                            }
                                            .padding(.top,-10)
                                            HStack{
                                                Text("₹ \(invoice[index].Order_Value)")
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            
                                        }
                                        .padding(.leading,10)
                                        Rectangle()
                                            .frame(width: 0.7)
                                            .foregroundColor(.gray)
                                            .padding(.bottom,10)
                                            .padding(.top,10)
                                        VStack(spacing:0){
                                            HStack{
                                                Text(invoice[index].Saledoc_No)
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            HStack{
                                                
                                                Image(systemName:"ellipsis.circle.fill")
                                                    .resizable()
                                                    .frame(width: 12,height: 12)
                                                    .foregroundColor(.red)
                                                Text(invoice[index].Status)
                                                    .font(.system(size: 14))
                                                Spacer()
                                                
                                            }
                                            HStack{
                                                Text("₹ \(invoice[index].Order_Value)")
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                        }
                                        
                                    }
                                }
                                .onTapGesture{
                                    print(index)
                                    get_invoice_details(index: index)
                                }
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.black)
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                
                            }
                            
                            .listStyle(PlainListStyle())
                        }
                    }else{
                        NoOrderdate()
                        Spacer()
                    }
                }
                
            }
    }
    func get_invoice_details(index:Int){
        
        if invoice[index].Status == "Fully invoiced" || invoice[index].Status == "Partially invoiced"{
        let axn = "get_invoice_details"
        let Item = invoice[index].Saledoc_No
        print(Item)
        let apikey = "\(axn)&orderNo=\(Item)"
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apikey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { response in
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
                    if let jsonData = prettyPrintedJson.data(using: .utf8){
                        do{
                            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                if let response = jsonObject["response"] as? [[String: Any]] {
                                    print(response)
                                    if let xstring = response[0]["xstring"] as? String {
                                        Pdf_String = xstring
                                        Navi_pdf_View.toggle()
                                        Main_View.toggle()
                                    }
                                    
                                } else {
                                    print("Error: Couldn't extract HTML")
                                }
                            }
                        } catch{
                            print("Error Data")
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
        }else{
            //ShowToastMes.shared.tost = "Not inviced"
            showToast.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                            self.showToast.toggle()
                                }
                //ShowToastMes.shared.tost = ""
            }
        }
    }
    
    struct AddSomeViewe:View{
        @Binding var HistoryInf:Bool
        @Binding var OrderDetialsView:Bool
        var body: some View{
            NavigationView{
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 80)
                        HStack {
                            
                            Text("Order Details")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                .padding(.leading,50)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .padding(.top,50)
                                .padding(.trailing,15)
                                .onTapGesture {
                                    HistoryInf.toggle()
                                    OrderDetialsView.toggle()
                                }
                        }
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
            
        }
    }
}

struct PDFWebView: View {
    let pdfData: Data
    @Binding var Navi_pdf_View:Bool
    @Binding var Main_View:Bool
    var body: some View {
        VStack{
        ZStack{
            Rectangle()
                .foregroundColor(ColorData.shared.HeaderColor)
                .frame(height: 80)
            HStack {
                Image("backsmall")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .padding(.top,50)
                    .frame(width: 50)
                    .onTapGesture {
                        From_To_Date.shared.SetDate = 1
                        Navi_pdf_View.toggle()
                        Main_View.toggle()
                    }
                Text("Invoice")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top,50)
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity)
        .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
        WebView_pdf(data: pdfData)
    }
    }
}

struct WebView_pdf: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("temp.pdf") {
            do {
                try data.write(to: url)
                let request = URLRequest(url: url)
                uiView.load(request)
            } catch {
                print("Error writing PDF to disk: \(error)")
            }
        }
    }
}
