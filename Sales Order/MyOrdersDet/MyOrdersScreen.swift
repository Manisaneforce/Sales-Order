//
//  MyOrdersScreen.swift
//  Sales Order
//
//  Created by San eforce on 05/09/23.
//

import SwiftUI
import Alamofire
import UIKit
struct OrderDetails: Any{
    let OrderNo : String
    let No_Of_items : String
    let Quantity : String
    let Order_Value : String
    let Status : String
    let Order_Date : String
    let isPaid : String
}
var selecteddate = ""
var html:String = ""
struct MyOrdersScreen: View {
    @State private var Filterdate = false
    @State private var isCalendarVisible = false
    @State private var selectedDate = Date()
    @State private var OrderPaymentDetails:[OrderDetails]=[]
    @State private var FilterDate = ""
    @State private var CurrentData = ""
    @State private var NaviOrdeDetNiew = false
    @State private var OrderId:String = ""
    @State private var Orderdate:String = ""
    @State private var Jiomoneypage = false
    @State private var navigateToHomepage = false
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = ""
    @State private var ToDate = ""
    @State private var TotalVal:String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   // @State private var html:String = ""
    
    let currentDate = Date()
    let calendar = Calendar.current
    var body: some View {
        NavigationView{
        ZStack{
            Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(red: 0.10, green: 0.59, blue: 0.81, opacity: 1.00))
                        .frame(height: 80)
                    
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
                        Text("MY ORDER")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                        Spacer()
                    }
                    NavigationLink(destination: HomePage(), isActive: $navigateToHomepage) {
                                    EmptyView()
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
                    OrderDetailsTriger()
                   
                }
                
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        HStack {
                                Text(FromDate)
                         
                            Image(systemName: "calendar")
                                .foregroundColor(Color.blue)
                        }
                    }
                    .onTapGesture {
                        SelMode = "DOF"
                        isPopoverVisible.toggle()
                        
                    }
                    .padding(10)
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        HStack {
                            Text(ToDate)
                            Image(systemName: "calendar")
                                .foregroundColor(Color.blue)
                        }
                    }
                    .onTapGesture {
                        SelMode = "DOT"
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
                        .foregroundColor(Color(red: 0.10, green: 0.59, blue: 0.81, opacity: 1.00))
                        .frame(height: 40)
                    HStack{
                        Text("Descrition")
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
                        Spacer()
                        HStack(spacing:40){
                            Text("items")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                            Text("Qty")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                            Text("Values")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                            Text("Type")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(10)
                }
             
                List(0 ..< OrderPaymentDetails.count, id: \.self) { index in
                    VStack{
                        HStack{
                            Text(OrderPaymentDetails[index].OrderNo)
                                .font(.system(size: 12))
                                .frame(width: 100, alignment: OrderPaymentDetails[index].OrderNo.count > 10 ? .center : .leading)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            HStack(spacing:40){
                            Text(OrderPaymentDetails[index].No_Of_items)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Quantity)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Order_Value)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Status)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.trailing)
                        }
                            
                            
                        }
                        HStack{
                            Text(OrderPaymentDetails[index].Order_Date)
                                .font(.system(size: 9))
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "circle.circle.fill")
                                .resizable()
                                .frame(width: 7,height: 7)
                                .foregroundColor(Color.red)
                            Text("Order recevied.Pending for Invoice")
                                .font(.system(size: 9))
                                .foregroundColor(Color.red)
                            Spacer()
                            let orderDetail = OrderPaymentDetails[index]
                            if orderDetail.isPaid.isEmpty {
                            Button(action:{
                                
                            }){
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(Color.blue)
                                        .cornerRadius(10)
                                    Text("Pay")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.white)
                                    
                                    
                                }
                                .frame(width: 50,height: 12)
                                .onTapGesture{
                                    OrderId = OrderPaymentDetails[index].OrderNo
                                    
                                    PaymentHTML()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        }
                      
                    }
                    .onTapGesture{
                        print(index)
                    TotalVal = OrderPaymentDetails[index].Order_Value
                      OrderId = OrderPaymentDetails[index].OrderNo
                      Orderdate =   OrderPaymentDetails[index].Order_Date
                        
                        print(OrderId)
                        NaviOrdeDetNiew = true
                    }
                }
                .listStyle(PlainListStyle())
                NavigationLink(destination: OrderDetView(OrderId:$OrderId, Orderdate: $Orderdate, TotalVal: $TotalVal), isActive: $NaviOrdeDetNiew) {
                                EmptyView()
                            }
                NavigationLink(destination: Jiomoney(), isActive: $Jiomoneypage) {
                                EmptyView()
                            }
                Spacer()
            }
            
            .popover(isPresented: $isPopoverVisible) {
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 60)
                            .padding(20)
                        Text("Select Date")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    VStack {
                        
                        DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                        
                        Button(action:{
                            Selectdate()
                            isPopoverVisible.toggle()
                        }){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(ColorData.shared.HeaderColor)
                                    .frame(height: 40)
                                    .padding(20)
                                Text("Submit Date")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        //.padding()
                    }
                }
                
            }
            
            if Filterdate{
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        Filterdate.toggle()
                    }
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.blue)
                            .frame(height: 50)
                        VStack{
                            Text("Select Quick Dates")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    VStack{
                        
                        Text("Last 7 days")
                            .onTapGesture{
                                OrderPaymentDetails.removeAll()
                                Filterdate.toggle()
                                FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                                OrderDetailsTriger()
                            }
                            
                        Divider()
                        Text("Last 30 days")
                            .onTapGesture{
                                OrderPaymentDetails.removeAll()
                                Filterdate.toggle()
                                FromDate = (formattedDate(date: calculateStartDate(for: 30)))
                                OrderDetailsTriger()
                            }
                        
                    }
                    Spacer()
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.blue)
                            .frame(height: 50)
                        VStack{
                            Text("Close")
                                .font(.system(size: 18))
                                .foregroundColor(Color.white)
                        }
                    }
                    .onTapGesture {
                        Filterdate.toggle()
                    }
                    
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            }
            
        }
    }
        .navigationBarHidden(true)
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
    private  func Selectdate(){
          if SelMode == "DOF"{
              FromDate=dateFormatter.string(from: selectedDate)
              OrderDetailsTriger()
              
          }
          if SelMode == "DOT"{
              ToDate = dateFormatter.string(from: selectedDate)
              OrderDetailsTriger()
          }
      }
    func PaymentHTML(){
    
    
        AF.request("https://rad.salesjump.in/server/Reliance_JioMoney/AuthenticateCredentials.php?uuid=123456789&invoice=\(OrderId)", method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                        if let jsonData = prettyPrintedJson.data(using: .utf8){
                            do{
                                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                    if let HTML = jsonObject["html"] as? String {
                                        print(HTML)
                                        html = HTML
                                         print(html)
                                        Jiomoneypage = true
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
    
    func calculateStartDate(for days: Int) -> Date {
        let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
        return startDate ?? currentDate
    }
    func OrderDetailsTriger(){
        let axn = "get/orderlst&sfCode=\(CustDet.shared.CusId)&fromdate=\(FromDate)&todate=\(ToDate)"
      
        let apiKey = "\(axn)"
    
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                        OrderPaymentDetails.removeAll()
                        if let jsonData = prettyPrintedJson.data(using: .utf8){
                            do{
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]{
                                    for Items in jsonArray{
                                        let OrderNo = Items["OrderNo"] as? String
                                        let NoofItems = Items["No_Of_items"] as? String
                                        let Qty = String((Items["Quantity"] as? Int)!)
                                        var OrderValue = ""
                                        if let orderValue = Items["Order_Value"] as? Double {
                                            OrderValue = String(format: "%.2f", orderValue)
                                            print("Formatted Order Value: \(OrderValue)")
                                        } else {
                                            print("Order Value is not a valid Double.")
                                        }

                                        let Status = Items["Status"] as? String
                                        let OrderDate = Items["Order_Date"] as? String
                                        let Ispaid = Items["isPaid"] as? String
                                        print(Items)
                                        
                                        OrderPaymentDetails.append(OrderDetails(OrderNo: OrderNo!, No_Of_items: NoofItems!, Quantity: Qty, Order_Value: OrderValue, Status: Status!, Order_Date: OrderDate!, isPaid: Ispaid!))
                                    }
                                }
                            } catch{
                                print("Error Data")
                            }
                        }
                        print(OrderPaymentDetails)

                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

struct MyOrdersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyOrdersScreen()
    }
}

struct listProdDet: Any{
    let Product_Name:String
    let Unit_Name : String
    let New_Qty : String
    let BillRate : String
    let value :String
}
struct OrderDetView:View{
    @State private var phase = 0.0
    @Binding var OrderId: String
    @Binding var Orderdate: String
    @State private var SelectDet:[listProdDet]=[]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var TotalVal:String
    
    var body: some View{
        NavigationView{
        ZStack{
            Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(red: 0.10, green: 0.59, blue: 0.81, opacity: 1.00))
                        .frame(height: 80)
                    
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
                        
                        
                        Text("SALES ORDER")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                        Spacer()
                        HStack(spacing:25){
                            Image(systemName: "printer.filled.and.paper")
                                .resizable()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color.white)
                                .onTapGesture{
                                    printDocument()
                                }
                            Image(systemName: "square.and.arrow.up.fill")
                                .resizable()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color.white)
                            
                            Text("")
                        }
                        .padding(.top,50)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
           
                VStack(spacing:-10){
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .shadow(radius: 5)
                    VStack(spacing:-12){
                        HStack(){
                            Text(CustDet.shared.StkNm)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                            Spacer()
                            Text("ORDER")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }
                        .padding(10)
                        HStack{
                            Image(systemName: "phone.circle.fill")
                                .foregroundColor(Color.blue)
                            Text(CustDet.shared.StkMob)
                            Spacer()
                        }
                        .padding(10)
                        ZStack{
                            Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2,dash: [5]))
                            
                                .foregroundColor(Color.gray)
                            VStack(spacing:-15){
                                HStack{
                                    Text("BILL TO")
                                        .fontWeight(.bold)
                                        .font(.system(size: 13))
                                    Spacer()
                                }
                                .padding(10)
                                HStack{
                                    Text(CustDet.shared.CusName)
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(10)
                                HStack{
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(Color.blue)
                                    Text(CustDet.shared.Mob)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(10)
                                HStack{
                                    Text(CustDet.shared.Addr)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(10)
                                    
                            }
                            
                            
                        }
                       
                        .padding(10)
                    }
                }
                .frame(height: 200)
                .padding(10)
                
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        ScrollView{
                        VStack{
                            VStack(spacing:-15){
                                HStack{
                                    Text(OrderId)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                    Spacer()
                                    HStack{
                                        Text("Delivery")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(10)
                                HStack{
                                    Text(Orderdate)
                                    Spacer()
                                }
                                .padding(10)
                                VStack(spacing:-15){
                                    Rectangle()
                                        .frame(height: 1)
                                        .padding(10)
                                    HStack{
                                        Text("Item")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                        Spacer()
                                        HStack(spacing:30){
                                            Text("UOM")
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                            Text("Qty")
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                            Text("Price")
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                            Text("Total")
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(10)
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .padding(10)
                                }
                            }
                            .onAppear{
                                print(OrderId)
                                let axn = "get/orderDet&orderID=\(OrderId)"
                                //http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/orderDet&orderID=MUMBAI01-2023-2024-SO-95
                                let apiKey = "\(axn)"
                                
                                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                                                if let jsonData = prettyPrintedJson.data(using: .utf8){
                                                    do{
                                                        if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]{
                                                            for Items in jsonArray{
                                                                print(Items)
                                                                
                                                                let Product_Name = Items["Product_Name"] as? String
                                                                let UOM = Items["UOM"] as? String
                                                                let New_Qty = String((Items["New_Qty"] as? Int)!)
                                                                var BillRate = ""
                                                                if let BillRates = Items["BillRate"] as? Double {
                                                                    BillRate = String(format: "%.2f", BillRates)
                                                                    print("Formatted Order Value: \(BillRates)")
                                                                } else {
                                                                    print("Order Value is not a valid Double.")
                                                                }
                                                                
                                                                
                                                                var value = ""
                                                                if let values = Items["value"] as? Double {
                                                                    value = String(format: "%.2f", values)
                                                                    print("Formatted Order Value: \(values)")
                                                                } else {
                                                                    print("Order Value is not a valid Double.")
                                                                }
                                                                
                                                                SelectDet.append(listProdDet(Product_Name: Product_Name!, Unit_Name: UOM!, New_Qty: New_Qty, BillRate: BillRate, value: value))
                                                            }
                                                        }
                                                    } catch{
                                                        print("Error Data")
                                                    }
                                                }
                                                print(SelectDet)
                                                
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                
                            }
                            ForEach(0 ..< SelectDet.count, id: \.self) { index in
                                HStack{
                                    Text(SelectDet[index].Product_Name)
                                        .font(.system(size: 12))
                                                    .frame(width: 100, alignment: SelectDet[index].Product_Name.count > 10 ? .center : .leading)
                                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    HStack(spacing:30){
                                        
                                        Text(SelectDet[index].Unit_Name)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 50,alignment: SelectDet[index].Product_Name.count > 10 ? .center : .leading)
                                        
                                        
                                        Text(SelectDet[index].New_Qty)
                                            .font(.system(size: 12))
                                        
                                        Text(SelectDet[index].BillRate)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.center)
                                        
                                        Text(SelectDet[index].value)
                                            .font(.system(size: 12))
                                        //.padding(-10)
                                        
                                    }
                                }
                                
                                
                                
                                
                            }
                            .listStyle(PlainListStyle())
                            .padding(13)
                            VStack(spacing:-10){
                                Rectangle()
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1,dash: [2]))
                                    .foregroundColor(Color.gray)
                                    .frame(height: 2)
                                    .padding(10)
                                HStack{
                                    Text("PRICE DETAILS")
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(10)
                                Rectangle()
                                    .foregroundColor(Color.gray)
                                    .frame(height: 1)
                                    .padding(10)
                                VStack(spacing:-10){
                                    HStack{
                                        Text("Subtotal")
                                            .font(.system(size: 12))
                                        
                                        Spacer()
                                        Text("202.64")
                                            .font(.system(size: 12))
                                    }
                                    .padding(10)
                                    HStack{
                                        Text("Total item")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("1")
                                            .font(.system(size: 12))
                                    }
                                    .padding(10)
                                    HStack{
                                        Text("Total Qty")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("1")
                                            .font(.system(size: 12))
                                    }
                                    .padding(10)
                                    HStack{
                                        Text("GST 12%")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("23.64")
                                            .font(.system(size: 12))
                                    }
                                    .padding(10)
                                    Rectangle()
                                        .foregroundColor(Color.gray)
                                        .frame(height: 1)
                                        .padding(10)
                                }
                            }
                            HStack{
                                Text("NET AMOUNT")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                Spacer()
                                
                                Text(TotalVal)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                
                            }
                            .padding(10)
                        }
                    }
                }
                .padding(10)
            }
            }
        }
    }
        .navigationBarHidden(true)
    }
    
}


class CustomPrintFormatter: UIPrintFormatter {
    var customPageWidth: CGFloat = 200 // Adjust this value to match your bill format width
    var customPageHeight: CGFloat = 200 // Adjust this value to match your bill format height

    override func draw(in rect: CGRect, forPageAt pageIndex: Int) {
        let customPageRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: customPageWidth, height: customPageHeight)
        super.draw(in: customPageRect, forPageAt: pageIndex)
    }
}

func printDocument() {
    let printController = UIPrintInteractionController.shared

    let printInfo = UIPrintInfo(dictionary: nil)
    printInfo.jobName = "Print Job"
    printInfo.outputType = .general

    printController.printInfo = printInfo

    let formatter = CustomPrintFormatter()
    formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
    printController.printFormatter = formatter

    printController.present(animated: true, completionHandler: nil)
}
