//
//  MyOrdersScreen.swift
//  Sales Order
//
//  Created by San eforce on 05/09/23.
//

import SwiftUI
import Alamofire
import UIKit
import PDFKit
import FSCalendar
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
var OrderNo:String = ""
var OrdDate:String = ""
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
    @State private var SelMode: String = "DOF"
    @State private var FromDate = ""
    @State private var SelectFromDate = Date()
    @State private var ToDate = ""
    @State private var TotalVal:String = ""
    @State private var Loader:Bool = true
    @State private var showToast = false
    @State private var ShowTost = ""
    @ObservedObject var monitor = Monitor()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var payLoader = false
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
                        Text("MY ORDERS")
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
                }
                .onReceive(monitor.$status) { newStatus in
               if newStatus == .connected {
                }
             }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
              
        
                .onAppear{
                    Paymentnav.shared.NavId = 1
                    let fromDate = String(dateFormatter.string(from:selectedDate))
                    print(fromDate)
                    FromDate = fromDate
                    ToDate = fromDate
                    OrderDetailsTriger()
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
                        }
                        .padding(.horizontal,5)
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
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundColor(Color.blue)
                        }
                        .padding(.horizontal,5)
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
                        Text("Description")
                            .foregroundColor(Color.white)
                            .font(.system(size: 14))
                        Spacer()
                        HStack(spacing:40){
                            Text("Items")
                                .foregroundColor(Color.white)
                                .font(.system(size: 14))
                            Text("Qty")
                                .foregroundColor(Color.white)
                                .font(.system(size: 14))
                            Text("Value")
                                .foregroundColor(Color.white)
                                .font(.system(size: 14))
                            Text("Type")
                                .foregroundColor(Color.white)
                                .font(.system(size: 14))
                        }
                    }
                    .padding(10)
                }
                if Loader{
                    ScrollView(showsIndicators: false){
                        ForEach(0 ..< OrderPaymentDetails.count, id: \.self) { index in
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
                if (OrderPaymentDetails.count != 0){
                    List(0 ..< OrderPaymentDetails.count, id: \.self) { index in
                        VStack{
                            HStack{
                                Text(OrderPaymentDetails[index].OrderNo)
                                    .font(.system(size: 12))
                                    .frame(width: 100, alignment: OrderPaymentDetails[index].OrderNo.count > 10 ? .center : .leading)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                HStack(spacing:30){
                                    Text(OrderPaymentDetails[index].No_Of_items)
                                        .font(.system(size: 12))
                                        .frame(minWidth: 0,maxWidth: .infinity)
                                        .multilineTextAlignment(.leading)
                                    Text(OrderPaymentDetails[index].Quantity)
                                        .font(.system(size: 12))
                                        //.frame(minWidth: 0,maxWidth: .infinity)
                                        .frame(width: 30)
                                        .multilineTextAlignment(.leading)
                                    Text(OrderPaymentDetails[index].Order_Value)
                                        .font(.system(size: 12))
                                        .frame(width: 45)
                                        .multilineTextAlignment(.leading)
                                    Text(OrderPaymentDetails[index].Status)
                                        .font(.system(size: 12))
                                        .frame(width: 45)
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
                                if (paymentenb.shared.isPaymentenbl == 1){
                                    if orderDetail.isPaid.isEmpty {
                                        Button(action:{
                                            
                                        }){
                                            ZStack{
                                                Rectangle()
                                                    .foregroundColor(ColorData.shared.HeaderColor)
                                                    .cornerRadius(10)
                                                Text("Pay")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(Color.white)
                                                
                                                
                                            }
                                            .frame(width: 50,height: 12)
                                            .onTapGesture{
                                                OrderId = OrderPaymentDetails[index].OrderNo
                                                Invoiceid.shared.id = OrderPaymentDetails[index].OrderNo
                                                PaymentHTML()
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                        }
                        .onTapGesture{
                            print(index)
                            TotalVal = OrderPaymentDetails[index].Order_Value
                            OrderId = OrderPaymentDetails[index].OrderNo
                            print(OrderPaymentDetails)
                            print(OrderPaymentDetails[index].OrderNo)
                            OrderNo = OrderId
                            print(OrderNo)
                            Orderdate =   OrderPaymentDetails[index].Order_Date
                            OrdDate = Orderdate
                            
                            print(OrderId)
                            NaviOrdeDetNiew = true
                        }
                    }
                    .listStyle(PlainListStyle())
                }else{
                    NoOrderdate()
                }
            }
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
                        Filterdate.toggle()
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
                                OrderPaymentDetails.removeAll()
                                Loader.toggle()
                                Filterdate.toggle()
                                FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                                SelectFromDate = (formattedDates(date: calculateStartDate(for: 7))!)
                                let ToDates = String(dateFormatter.string(from:CurentDate))
                                ToDate = ToDates
                                OrderDetailsTriger()
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
                                OrderPaymentDetails.removeAll()
                                Loader.toggle()
                                Filterdate.toggle()
                                FromDate = (formattedDate(date: calculateStartDate(for: 30)))
                                SelectFromDate = (formattedDates(date: calculateStartDate(for: 30))!)
                                let ToDates = String(dateFormatter.string(from:CurentDate))
                                ToDate = ToDates
                                OrderDetailsTriger()
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
            if payLoader{
                ZStack{
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        //GetLoction.toggle()
                    }
                VStack{
                    LottieUIView(filename: "loader").frame(width: 100,height: 100)
                    Text("Please wait ...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(10)
                        .frame(width: 250)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
                
            }
        }
            
        }
        .toast(isPresented: $showToast, message: "\(ShowTost)")
    }
        .navigationViewStyle(StackNavigationViewStyle())
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
    func formattedDates(date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: formattedDateString)
    }
    private  func Selectdate(){
          if SelMode == "DOF"{
              SelectFromDate = selectedDate
              FromDate=dateFormatter.string(from: selectedDate)
              OrderDetailsTriger()
              
          }
          if SelMode == "DOT"{
              ToDate = dateFormatter.string(from: selectedDate)
              OrderDetailsTriger()
          }
      }
    func PaymentHTML(){
        payLoader.toggle()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        AF.request(APIClient.shared.BaseURL+"/server/Reliance_JioMoney/AuthenticateCredentials.php?uuid=\(deviceID)&invoice=\(OrderId)", method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                                        html = HTML
                                        payLoader.toggle()
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
                    payLoader.toggle()
                    ShowTost = "\(error)"
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                    }
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
                                        let OrderNo = Items["OrderNo"] as? String ?? ""
                                        let NoofItems = Items["No_Of_items"] as? String ?? ""
                                        let Qty = String((Items["Quantity"] as? Int)!)
                                        var OrderValue = ""
                                        if let orderValue = Items["Order_Value"] as? Double {
                                            OrderValue = String(format: "%.2f", orderValue)
                                            print("Formatted Order Value: \(OrderValue)")
                                        } else {
                                            print("Order Value is not a valid Double.")
                                        }

                                        let Status = Items["Status"] as? String ?? ""
                                        let OrderDate = Items["Order_Date"] as? String ?? ""
                                        let Ispaid = Items["isPaid"] as? String ?? ""
                                        print(Items)
                                        OrderPaymentDetails.append(OrderDetails(OrderNo: OrderNo, No_Of_items: NoofItems, Quantity: Qty, Order_Value: OrderValue, Status: Status, Order_Date: OrderDate, isPaid: Ispaid))
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
    let Tax:String
    let value :String
    let Offer_Product:String
    let off_pro_unit:String
    let Dic:String
    
}
struct OrderDetView:View{
    @State private var phase = 0.0
    @Binding var OrderId: String
    @Binding var Orderdate: String
    @State private var SelectDet:[listProdDet]=[]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var TotalVal:String
    @State private var isShowingSheet = false
    @State private var PagHeight:Int = 800
    @State private var TaxTyp = ""
    @State private var TotalTax:Double = 0.0
    @State private var NewQty:Int = 0
    @State private var umounit:Int = 0
    @State private var Allproddata:String = UserDefaults.standard.string(forKey: "Allproddata") ?? ""
    @State private var Billing = ""
    @State private var Shiping = ""
    @ObservedObject var monitor = Monitor()
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
                                .onTapGesture {
                                    // isShowingSheet.toggle()
                                    let pdfData = generatePDF()
                                    saveAndSharePDF(pdfData)
                                }
                            
                            
                            Text("")
                        }
                        .padding(.top,50)
                    }
                }else {
                    
                    Internet_Connection()
                }
                }  .onReceive(monitor.$status) { newStatus in
                    if newStatus == .connected {
                     }
                  }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
           
                VStack{
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.horizontal,10)
                            VStack{
                                HStack{
                                    Text(CustDet.shared.StkNm)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("ORDER")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal,20)
                                .padding(.vertical,2)
                                HStack{
                                    Image(systemName: "phone.circle.fill")
                                        .foregroundColor(Color.blue)
                                    Text(CustDet.shared.StkMob)
                                    Spacer()
                                }
                                .padding(.horizontal,20)
                                
                                ZStack{
                                    Rectangle()
                                        .strokeBorder(style: StrokeStyle(lineWidth: 2,dash: [5]))
                                        .foregroundColor(Color.gray)
                                        
                                    VStack(spacing:5){
                                        HStack{
                                            Text("BILL TO")
                                                .fontWeight(.bold)
                                                .font(.system(size: 12))
                                            Spacer()
                                        }
                                        .padding(.top,10)
                                        .padding(.horizontal,10)
                                        HStack{
                                            Text(CustDet.shared.CusName)
                                                .font(.system(size: 12))
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .padding(.horizontal,10)
                                        HStack{
                                            Image(systemName: "phone.circle.fill")
                                                .foregroundColor(Color.blue)
                                            Text(CustDet.shared.Mob)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                        .padding(.horizontal,10)
                                        VStack(alignment: .leading){
                                            if (Billing == Shiping){
                                              
                                                VStack(alignment: .leading){
                                                        Text("BILLING & SHIPPING ADDRESS:-")
                                                            .font(.system(size: 12))
                                                            //.foregroundColor(.gray)
                                                        Text(Billing)
                                                            .font(.system(size: 12))
                                                            .foregroundColor(.gray)
                                                    }
                                                
                                            }else{
                                                VStack(alignment:.leading){
                                                    
                                                        Text("BILLING ADDRESS:-")
                                                            .font(.system(size: 12))
                                                        Text(Billing)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                        Text("SHIPPING ADDRESS:-")
                                                            .font(.system(size: 12))
                                                    Text(Shiping)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                                .padding(.leading,12)

                                            }
                                        }
                                        .padding(.horizontal,10)
                                        .padding(.bottom,3)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal,20)
                                .padding(.top,3)
                                .padding(.bottom,10)
                                
                            }
                        }
                        .frame(height: Billing == Shiping ? 230 : 275)
                    }.padding(.horizontal,10)
                        .padding(.vertical,10)
                    Spacer()
                    
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.horizontal,20)
                            VStack{
                            ScrollView{
                                VStack{
                                    VStack{
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
                                        .padding(.top,5)
                                        .padding(.bottom,2.5)
                                        .padding(.horizontal,10)
                                        HStack{
                                            Text(Orderdate)
                                            Spacer()
                                        }
                                        .padding(.vertical,2)
                                        .padding(.horizontal,10)
                                        VStack{
                                            Rectangle()
                                                .frame(height: 1)
                                            
                                                VStack(alignment: .leading){
                                                    Text("Item")
                                                        .font(.system(size: 13))
                                                        .fontWeight(.bold)
                                                        .padding(.leading,10)
                                                        .frame(width: 70)
                                                        
                                                    Spacer()
                                                    HStack{
                                                        Text("UOM")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .frame(width: 60)
                                                        Spacer()
                                                        Text("Qty")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .frame(width: 35)
                                                        Spacer()
                                                        Text("Price")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .frame(width: 70)
                                                        Spacer()
                                                        Text("Tax")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .frame(width: 60)
                                                        Spacer()
                                                        Text("Total")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .frame(width: 70)
                                                            
                                                    }
                                                    .padding(.horizontal,10)
                                                }
                                               
                                            //.padding(.leading,10)
                                            Rectangle()
                                                .frame(height: 1)
                                                .padding(.bottom,10)
                                        }
                                    }
                                    .onAppear{
                                        print(OrderId)
                                        Get_Order_Addres(OrderID:OrderId)
                                        let axn = "get/orderDet&orderID=\(OrderId)"
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
                                                                    print(jsonArray)
                                                                    
                                                                    for Items in jsonArray{
                                                                        print(Items)
                                                                        if let TAX_details = Items["TAX_details"] as? [[String: Any]] {
                                                                            // Print the entire TAX_details array
                                                                            print(TAX_details)
                                                                            
                                                                            
                                                                            if let firstTaxDetail = TAX_details.first {
                                                                                if let taxName = firstTaxDetail["Tax_Name"] as? String {
                                                                                    if let taxamt = firstTaxDetail["Tax_Amt"] as? Double {
                                                                                        if let taxName = firstTaxDetail["Tax_Name"] as? String {
                                                                                            let correctedTaxName = taxName.replacingOccurrences(of: ",", with: "")
                                                                                            TaxTyp = correctedTaxName
                                                                                        }
                                                                                        TotalTax += taxamt
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                print("TAX_details is empty")
                                                                            }
                                                                        } else {
                                                                            print("TAX_details is not a valid array")
                                                                        }
                                                                        if let totqty
                                                                            = Items["New_Qty"] as? Int {
                                                                            NewQty += totqty
                                                                        }
                                                                        umounit += 1
                                                                        let Product_Name = Items["Product_Name"] as? String ?? ""
                                                                        let UOM = Items["UOM"] as? String ?? ""
                                                                        let New_Qty = String((Items["New_Qty"] as? Int ?? 0)!)
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
                                                                        var Tax_Amt = ""
                                                                        if let Tax_Amt2 = Items["Tax_value"] as? Double{
                                                                            Tax_Amt = String(format: "%.2f", Tax_Amt2)
                                                                        }else if (Items["Tax_value"] as? String == ""){
                                                                            Tax_Amt = "0.00"
                                                                        }
                                                                        var Offer_ProductCd = ""
                                                                        if  let Offer_ProductCd2 = Items["Offer_ProductCd"] as? String{
                                                                            Offer_ProductCd = Offer_ProductCd2
                                                                        }
                                                                        var off_pro_unit = "0"
                                                                        if let off_pro_unit2 = Items["off_pro_unit"] as? String{
                                                                            off_pro_unit = off_pro_unit2
                                                                        }
                                                                        var Dicpric = "0.00"
                                                                        if let dic_Pric = Items["discount_price"] as? Double{
                                                                            Dicpric =  String(format: "%.2f",dic_Pric)
                                                                        }
                                                                        
                                                                        var Offer_Product = ""
                                                                        print(Allproddata)
                                                                        if let jsonData = Allproddata.data(using: .utf8){
                                                                            do{
                                                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                                                                    print(jsonArray)
                                                                                    if let selectedPro = jsonArray.first(where: { ($0["id"] as! String) == Offer_ProductCd }) {
                                                                                        
                                                                                        Offer_Product  = (selectedPro["name"] as? String)!
                                                                                        print(selectedPro)
                                                                                    }
                                                                                }
                                                                            } catch{
                                                                                print("Data is error\(error)")
                                                                            }
                                                                        }
                                                                        SelectDet.append(listProdDet(Product_Name: Product_Name, Unit_Name: UOM, New_Qty: New_Qty, BillRate: BillRate, Tax: Tax_Amt, value: value,Offer_Product: Offer_Product,off_pro_unit: off_pro_unit, Dic: Dicpric))
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
                                            VStack(alignment:.leading){
                                                HStack{
                                                    Text(SelectDet[index].Product_Name)
                                                        .font(.system(size: 12))
                                                        .fontWeight(.semibold)
                                                        .frame(width: 100, alignment: SelectDet[index].Product_Name.count > 10 ? .leading : .leading)
                                                        .multilineTextAlignment(.leading)
                                                        
                                                    Spacer()
                                                    if (SelectDet[index].Dic != "0.00"){
                                                        Text("OFF :" + SelectDet[index].Dic)
                                                            .font(.system(size: 12))
                                                            .foregroundColor(.green)
                                                    }
                                                }
                                                .padding(.bottom,2)
                                                Spacer()
                                                HStack(){
                                                    Text("(\(SelectDet[index].Unit_Name))")
                                                        .font(.system(size: 12))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(width: 60,alignment: SelectDet[index].Product_Name.count > 10 ? .leading : .leading)
                                                        .padding(.leading,-2)
                                                        
                                                    Spacer()
                                                    Text(SelectDet[index].New_Qty)
                                                        .font(.system(size: 12))
                                                        .frame(width: 35)
                                                    Spacer()
                                                    Text(SelectDet[index].BillRate)
                                                        .font(.system(size: 12))
                                                        .frame(width: 70)
                                                        .multilineTextAlignment(.center)
                                                    Spacer()
                                                    Text(SelectDet[index].Tax)
                                                        .font(.system(size: 12))
                                                        .frame(width: 60)
                                                        .multilineTextAlignment(.center)
                                                    Spacer()
                                                    Text(SelectDet[index].value)
                                                        .font(.system(size: 12))
                                                        .frame(width: 70,alignment: SelectDet[index].Product_Name.count > 10 ? .trailing : .trailing)
                                                }
                                                HStack {
                                                    Rectangle()
                                                        .frame(height: 1)
                                                        .foregroundColor(.gray)
                                                        .padding(.leading,-13)
                                                        .padding(.trailing,-20)
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .onAppear{
                                            PagHeight += 50
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .padding(.horizontal,13)
                                    VStack{
                                        Rectangle()
                                            .strokeBorder(style: StrokeStyle(lineWidth: 1,dash: [2]))
                                            .foregroundColor(Color.gray)
                                            .frame(height: 2)
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                        HStack{
                                            Text("PRICE DETAILS")
                                                .font(.system(size: 16))
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        Rectangle()
                                            .foregroundColor(Color.gray)
                                            .frame(height: 1)
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                        VStack(spacing:-10){
                                            HStack{
                                                Text("Subtotal")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                
                                                Spacer()
                                                Text("₹"+TotalVal)
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                            HStack{
                                                Text("Total item")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                Spacer()
                                                Text("\(umounit)")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                            HStack{
                                                Text("Total Qty")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                Spacer()
                                                Text("\(NewQty)")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                            if TotalTax != 0.0{
                                                HStack{
                                                    //Text(TaxTyp)
                                                    Text("Tax")
                                                        .font(.system(size: 12))
                                                        .fontWeight(.semibold)
                                                    Spacer()
                                                    Text("₹\(String(format: "%.2f",TotalTax))")
                                                        .font(.system(size: 12))
                                                        .fontWeight(.semibold)
                                                }
                                                .padding(.vertical,5)
                                                .padding(.horizontal,10)
                                            }
                                            Rectangle()
                                                .foregroundColor(Color.gray)
                                                .frame(height: 1)
                                                .padding(.vertical,5)
                                                .padding(.horizontal,10)
                                        }
                                    }
                                    HStack{
                                        Text("NET AMOUNT")
                                            .font(.system(size: 16))
                                            .fontWeight(.bold)
                                        Spacer()
                                        
                                        Text("₹"+TotalVal)
                                            .font(.system(size: 16))
                                            .fontWeight(.bold)
                                    }
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                    
                                    Rectangle()
                                        .foregroundColor(Color.gray)
                                        .frame(height: 1)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                    
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Zero Billing Item")
                                                .foregroundColor(.blue)
                                                .fontWeight(.bold)
                                                .font(.system(size: 15))
                                            Spacer()
                                        }
                                        .padding(.leading,10)
                                        Rectangle()
                                            .foregroundColor(Color.gray)
                                            .frame(height: 1)
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                        
                                        HStack{
                                            Text("SKU")
                                                .font(.system(size: 10))
                                                .fontWeight(.bold)
                                            Spacer()
                                            Text("Free")
                                                .font(.system(size: 10))
                                                .fontWeight(.bold)
                                            
                                        }.padding(.horizontal,20)
                                        
                                        Rectangle()
                                            .foregroundColor(Color.gray)
                                            .frame(height: 1)
                                            .padding(.vertical,5)
                                            .padding(.horizontal,10)
                                        ForEach(0 ..< SelectDet.count, id: \.self) { index in
                                            if (SelectDet[index].Offer_Product != ""){
                                                    HStack{
                                                            Text(SelectDet[index].Offer_Product)
                                                                .font(.system(size: 12))
                                                                .fontWeight(.semibold)
                                                                .padding(.vertical,5)
                                                        Spacer()
                                                            Text(SelectDet[index].off_pro_unit)
                                                                .font(.system(size: 12))
                                                                .fontWeight(.semibold)
                                                                .padding(.vertical,5)
                                                    }
                                                    .padding(.horizontal,20)
                                            }
                                        }
                                    }
                                }.padding(.horizontal,20)
                            }
                        }
                       .padding(.bottom,10)
                    }
                }
            }
            }
        }
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
    func Get_Order_Addres(OrderID:String){
        let axn = "get_order_address"
        let apiKey = "\(axn)&orderID=\(OrderID)"
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = try? JSONSerialization.jsonObject(with: prettyJsonData, options: []) as? [String: Any] else {
                            print("Error: Could not convert Pretty JSON data to dictionary")
                            return
                        }
                        print(prettyPrintedJson)
                        if let Respons = prettyPrintedJson["response"] as? [String:AnyObject]{
                            print(Respons)
                            if let billingAddress = Respons["billingAddress"] as? String, let shippingAddress = Respons["shippingAddress"] as? String {
                            Billing = billingAddress
                            Shiping = shippingAddress
                        }
                    }else {
                        Billing = ""
                        Shiping = ""
                        print("Error: Unable to retrieve 'isAdd_Address_Enabled' from JSON")
                    }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func generatePDF() -> Data {
        
        let pageSize = CGSize(width: 612, height: PagHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        let pdfData = renderer.pdfData { (context) in
            // Begin PDF page
            context.beginPage()
            
            // Define font and size for title and text
            let titleFont = UIFont.boldSystemFont(ofSize: 20.0)
            let textFont = UIFont.systemFont(ofSize: 12.0)
            let textFontaSmal = UIFont.boldSystemFont(ofSize: 10.0)
            let textId = UIFont.systemFont(ofSize: 12.0)
            let ComFont = UIFont.systemFont(ofSize: 12.0)
            let Bill = UIFont.systemFont(ofSize: 15.0)
            
            // Define title and text
            let title = "ORDER SUMMARY"
            let text = CustDet.shared.StkNm
            let Mob = "MOB: \(CustDet.shared.StkMob)"
            let BillTo = "BILL TO :-"
            let ShipTO = "SHIPPING ADDRESS :-"
            let BillName = CustDet.shared.CusName
            let BillMob = CustDet.shared.Mob
            let BillAddres = Billing
            let ShipAddress = Shiping
            let OredId = "Order No: \(OrderNo)"
            let BillDate = "Date :\(OrdDate)"
            let Item = "Item"
            let Uom = "UOM"
            let Qty = "Qty"
            let Price = "Price"
            let Tax = "Tax"
            let Total = "Total"
            let SubTotal = "Sub Total"
            let SubTotalAmt = "₹"+TotalVal
            let TotalItem = "Total Item"
            var CountOfOrder = ""
            var TotalQty = "Total Qty"
            var TotaCountOfQty = "0"
            var ZeroBilling = "Zero Billing Item"
            var TotalTaxs = TaxTyp
            var TatalTaxAmt = "₹\(String(format: "%.2f",TotalTax))"
            let NetAmt = "NET AMOUNT"
            let TotalNetAmt = "₹\(TotalVal)"
            
            // Draw title
            let titleAttributes = [NSAttributedString.Key.font: titleFont]
            let titleRect = CGRect(x: 210, y: 50, width: 512, height: 50)
            title.draw(in: titleRect, withAttributes: titleAttributes)
            
            // Draw text
            let textAttributes = [NSAttributedString.Key.font: textFont]
            let textRect = CGRect(x: 50, y: 100, width: 512, height: 50)
            text.draw(in: textRect, withAttributes: textAttributes)
            
            let MobAttributes = [NSAttributedString.Key.font:ComFont]
            let MobRect = CGRect(x: 50, y: 120, width: 512, height: 50)
            Mob.draw(in:MobRect,withAttributes: MobAttributes)
            
            let BilHedAt = [NSAttributedString.Key.font:Bill]
            let BillHedRec = CGRect(x: 50, y: 140, width: 512, height: 50)
            BillTo.draw(in:BillHedRec,withAttributes: BilHedAt)
            
            let stkNameAt = [NSAttributedString.Key.font:ComFont]
            let StkName = CGRect(x: 50, y: 160, width: 512, height: 50)
            BillName.draw(in:StkName,withAttributes: stkNameAt)
            
            let stkMonat = [NSAttributedString.Key.font:ComFont]
            let StkMob = CGRect(x: 50, y: 180, width: 512, height: 50)
            BillMob.draw(in:StkMob,withAttributes: stkMonat)
            
            
            
            let StkAddAt = [NSAttributedString.Key.font:ComFont]
            let StkAddrs = CGRect(x: 50, y: 195, width: 512, height: 50)
            BillAddres.draw(in:StkAddrs,withAttributes: StkAddAt)
            
            let OrdIdAt = [NSAttributedString.Key.font:ComFont]
            let OrdsID = CGRect(x: 50, y: 225, width: 512, height: 50)
            OredId.draw(in:OrdsID,withAttributes: OrdIdAt)
            
            let OrdDateAt = [NSAttributedString.Key.font:ComFont]
            let Date = CGRect(x: 50, y: 240, width: 512, height: 50)
            BillDate.draw(in:Date,withAttributes: OrdDateAt)
            
            let Shiping = [NSAttributedString.Key.font:ComFont]
            let ShipingAdd = CGRect(x: 50, y: 260, width: 512, height: 50)
            ShipTO.draw(in:ShipingAdd,withAttributes: Shiping)
            
            let ShipingDet = [NSAttributedString.Key.font:ComFont]
            let ShipingAddss = CGRect(x: 50, y: 274, width: 512, height: 50)
            ShipAddress.draw(in:ShipingAddss,withAttributes: ShipingDet)
            
            
            
            
        
            let UperLine = UIGraphicsGetCurrentContext()
            UperLine?.setLineWidth(1.0)
            UperLine?.move(to: CGPoint(x: 0, y: 310))
            UperLine?.addLine(to: CGPoint(x: 700, y: 310))
            //LowLine?.addLine(to: CGPoint(x: 562, y: 280))
            UperLine?.strokePath()
           
            let ItemAt = [NSAttributedString.Key.font:ComFont]
            let ItemRe = CGRect(x: 50, y: 318, width: 512, height: 50)
            Item.draw(in:ItemRe,withAttributes: ItemAt)
            let UomRe = CGRect(x: 220, y: 318, width: 512, height: 50)
            Uom.draw(in:UomRe,withAttributes: ItemAt)
            let QtyRe = CGRect(x: 305, y: 318, width: 512, height: 50)
            Qty.draw(in:QtyRe,withAttributes: ItemAt)
            let PricRe = CGRect(x: 375, y: 318, width: 512, height: 50)
            Price.draw(in:PricRe,withAttributes: ItemAt)
            let TaxRe = CGRect(x: 450, y: 318, width: 512, height: 50)
            Tax.draw(in:TaxRe,withAttributes: ItemAt)
            let TotalRe = CGRect(x: 540, y: 318, width: 512, height: 50)
            Total.draw(in:TotalRe,withAttributes: ItemAt)
            
        
            let LowLine = UIGraphicsGetCurrentContext()
            LowLine?.setLineWidth(1.0)
            LowLine?.move(to: CGPoint(x: 0, y: 335))
            LowLine?.addLine(to: CGPoint(x: 700, y: 335))
            LowLine?.strokePath()
   
            var yOffset = 325
      
            for orderIndex in 0..<SelectDet.count {
                yOffset += 20
                let TotatNoofQty = Int(SelectDet[orderIndex].New_Qty)! + Int(TotaCountOfQty)!
                TotaCountOfQty = String(TotatNoofQty)
                
                let Count = orderIndex + 1
                CountOfOrder = String(Count)
                 let NoOfPro = "\(Count)."
                let orderNoAttributes = [NSAttributedString.Key.font: textFont]
                let orderNoAttributes_small = [NSAttributedString.Key.font: textFontaSmal]
                let NoOfInd = CGRect(x: 20, y: yOffset, width: 512, height: 50)
                NoOfPro.draw(in:NoOfInd,withAttributes:orderNoAttributes )
                
                let ProName = SelectDet[orderIndex].Product_Name
                let orderNoRect = CGRect(x: 50, y: yOffset, width: 512, height: 30)
                ProName.draw(in: orderNoRect, withAttributes: orderNoAttributes)
                 // Increase y-coordinate for next OrderNo
            
                let Uom = SelectDet[orderIndex].Unit_Name
                let UomRect = CGRect(x: 220, y: yOffset, width: 512, height: 30)
                Uom.draw(in: UomRect, withAttributes: orderNoAttributes)
            
                let Qty = SelectDet[orderIndex].New_Qty
                let QtyRect = CGRect(x: 305, y: yOffset, width: 512, height: 30)
                Qty.draw(in: QtyRect, withAttributes: orderNoAttributes)
                
                let Prce = SelectDet[orderIndex].BillRate
                let PriRect = CGRect(x: 375, y: yOffset, width: 512, height: 30)
                Prce.draw(in:PriRect,withAttributes: orderNoAttributes)
                
                let tax = SelectDet[orderIndex].Tax
                let taxRect = CGRect(x: 450, y: yOffset, width: 512, height: 30)
                tax.draw(in:taxRect,withAttributes: orderNoAttributes)
                
                let Total = SelectDet[orderIndex].value
                let TotalRect = CGRect(x: 540, y: yOffset, width: 512, height: 30)
                Total.draw(in:TotalRect,withAttributes: orderNoAttributes)
               
                   }
            print(TotaCountOfQty)
 
            let context = UIGraphicsGetCurrentContext()
                   context?.setLineWidth(1.0)
                   context?.move(to: CGPoint(x: 0, y: yOffset+50))
                   context?.addLine(to: CGPoint(x: 700, y: yOffset+50))
                   context?.strokePath()
            
            let SuTotalRe = CGRect(x: 50, y: yOffset+60, width: 512, height: 50)
            SubTotal.draw(in:SuTotalRe,withAttributes: ItemAt)
            let SubTotalAmtRe = CGRect(x: 400, y: yOffset+60, width: 512, height: 50)
            SubTotalAmt.draw(in:SubTotalAmtRe,withAttributes: ItemAt)
            let TotalItemRe = CGRect(x: 50, y: yOffset+80, width: 512, height: 50)
            TotalItem.draw(in:TotalItemRe,withAttributes: ItemAt)
            let CountOfRe = CGRect(x: 400, y: yOffset+80, width: 512, height: 50)
            CountOfOrder.draw(in:CountOfRe,withAttributes: ItemAt)
            let TotalQtyRe = CGRect(x: 50, y: yOffset+100, width: 512, height: 50)
            TotalQty.draw(in:TotalQtyRe,withAttributes: ItemAt)
            let TotalCotQty = CGRect(x: 400, y: yOffset+100, width: 512, height: 50)
            TotaCountOfQty.draw(in:TotalCotQty,withAttributes: ItemAt)
            let TotalTaxRe = CGRect(x: 50, y: yOffset+120, width: 512, height: 50)
            TotalTaxs.draw(in:TotalTaxRe,withAttributes: ItemAt)
            let TatalTaxAmtRe = CGRect(x: 400, y: yOffset+120, width: 512, height: 50)
            TatalTaxAmt.draw(in:TatalTaxAmtRe,withAttributes: ItemAt)
   
            
            let SubTotalUpLine = UIGraphicsGetCurrentContext()
            SubTotalUpLine?.setLineWidth(1.0)
            SubTotalUpLine?.move(to: CGPoint(x: 0, y: yOffset+140))
            SubTotalUpLine?.addLine(to: CGPoint(x: 700, y: yOffset+140))
            SubTotalUpLine?.strokePath()
            
            let NetAmtRe = CGRect(x: 50, y: yOffset+160, width: 512, height: 50)
            NetAmt.draw(in:NetAmtRe,withAttributes: ItemAt)
            
            let TotNetAmtRe = CGRect(x: 400, y: yOffset+160, width: 512, height: 50)
            TotalNetAmt.draw(in:TotNetAmtRe,withAttributes: ItemAt)
            
            let SubTotalDwnLine = UIGraphicsGetCurrentContext()
            SubTotalDwnLine?.setLineWidth(1.0)
            SubTotalDwnLine?.move(to: CGPoint(x: 0, y: yOffset+180))
            SubTotalDwnLine?.addLine(to: CGPoint(x: 700, y: yOffset+180))
            SubTotalDwnLine?.strokePath()
            
            
            let ZeroBillingRe = CGRect(x: 50, y: yOffset+200, width: 512, height: 50)
            ZeroBilling.draw(in:ZeroBillingRe,withAttributes: ItemAt)
            
            let ZeroBillingUpLine = UIGraphicsGetCurrentContext()
            ZeroBillingUpLine?.setLineWidth(1.0)
            ZeroBillingUpLine?.move(to: CGPoint(x: 0, y: yOffset+230))
            ZeroBillingUpLine?.addLine(to: CGPoint(x: 700, y: yOffset+230))
            ZeroBillingUpLine?.strokePath()
            
            let skc = "SKC"
            let skcRect = CGRect(x: 75, y: yOffset+245, width: 512, height: 50)
            skc.draw(in:skcRect,withAttributes: ItemAt)
            
            let Free = "Free"
            let FreeRect = CGRect(x: 450, y: yOffset+245, width: 512, height: 50)
            Free.draw(in:FreeRect,withAttributes: ItemAt)
            
            let ZeroBillingDwnLine = UIGraphicsGetCurrentContext()
            ZeroBillingDwnLine?.setLineWidth(1.0)
            ZeroBillingDwnLine?.move(to: CGPoint(x: 0, y: yOffset+260))
            ZeroBillingDwnLine?.addLine(to: CGPoint(x: 700, y: yOffset+260))
            ZeroBillingDwnLine?.strokePath()
            for orderIndex in 0..<SelectDet.count {
                if (SelectDet[orderIndex].Offer_Product != ""){
                    yOffset += 20
                    let offPro = SelectDet[orderIndex].Offer_Product
                    let offProRect = CGRect(x: 50, y: yOffset+260, width: 512, height: 50)
                    offPro.draw(in:offProRect,withAttributes: ItemAt)
                    
                    let offProunit = SelectDet[orderIndex].off_pro_unit
                    let offProunitRect = CGRect(x: 453, y: yOffset+260, width: 512, height: 50)
                    offProunit.draw(in:offProunitRect,withAttributes: ItemAt)
                }else{
                    print("No Free")
                }
            }
        }
        return pdfData
    }
        func saveAndSharePDF(_ data: Data) {
            print(OrderNo)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(OrderNo).pdf")
            do {
                try data.write(to: tempURL)
                let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            } catch {
                print("Error saving PDF: \(error)")
            }
        }
        
        func renderViewToImage(view: UIViewController) -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: view.view.bounds)
            return renderer.image { context in
                view.view.layer.render(in: context.cgContext)
            }
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
struct NoOrderdate:View{
    var body: some View{
        Spacer()
        Text("No Record Found")
    }
}

