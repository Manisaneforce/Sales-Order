//
//  MyOrdersDetails.swift
//  Sales Order
//
//  Created by San eforce on 05/09/23.
//

import SwiftUI
import Alamofire
struct getInvoice: Any{
    let Status:String
    let OrderID:String
    let Date:String
    let Order_Value:String
    let Product_Name:String
    let Quantity:String
}
//var invoice:[getInvoice]=[]
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
    @State var OrderId = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let currentDate = Date()
    let calendar = Calendar.current
    var body: some View {
        if HistoryInf{
        NavigationView{
            ZStack{
                Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
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
                            
                            
                            Text("History Info")
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
                        orderandinvoice()
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
                            CalenderTit = "Select Date"
                            isPopoverVisible.toggle()
                            
                        }
                        .padding(10)
                        
                        //.padding(10)
                        
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
                    TapBar(HistoryInf: $HistoryInf, OrderDetialsView: $OrderDetialsView, currentTab: $currentTab, invoice: $invoice, OrderId: $OrderId)
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
                                    
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                                    orderandinvoice()
                                    
                                    
                                }
                            
                            Divider()
                            Text("Last 30 days")
                                .onTapGesture{
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 30)))
                                    orderandinvoice()
                                }
                        }
                        Spacer()
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
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
        if OrderDetialsView{
            VStack{
                //AddSomeViewe(HistoryInf: $HistoryInf, OrderDetialsView: $OrderDetialsView)
                OrderDetView(OrderId: $OrderId, Orderdate: $OrderId)
            }
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
    private  func Selectdate(){
          if SelMode == "DOF"{
             // FromDate = selectedDate
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
        let axn = "get/orderandinvoice"
        let apiKey: String = "\(axn)"
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
                                        let Status = itemsdata["Status"] as? String
                                        let OrderID = itemsdata["OrderID"] as? String
                                        let Order_Value = itemsdata["Order_Value"] as? Double
                                        let Date = itemsdata["Date"] as? String
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
                                        invoice.append(getInvoice(Status: Status!, OrderID: OrderID!, Date: Date!, Order_Value: String(Order_Value!), Product_Name: productNames, Quantity: qty))
                                        
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
                    
                    print("______________________prodGroup_______________")
                   
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
    var body: some View {
        ZStack(alignment:.top){
        TabView(selection: $currentTab) {
            ORDER(invoice: $invoice,HistoryInf: $HistoryInf,OrderDetialsView: $OrderDetialsView, OrderId: $OrderId)
                .tag(0)
            INVOICE()
                .tag(1)
            ORDERVSINVOICE(invoice: $invoice)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never)).edgesIgnoringSafeArea(.all)
    }
    }
}
struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["ORDER", "INVOICE", "ORDER VS INVOICE"]
    
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
   // @Namespace var namespace
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
    //@State private var View:[ViOredr]=[]
    @State private var ProName = [String]()
    @State private var Qty = [String]()
    @Binding var OrderId:String
    
    var body: some View{
        VStack{
                                ScrollView{
                                    ForEach(0..<invoice.count, id: \.self) { index in
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
                                                    OrderId = invoice[index].OrderID
                                                    HistoryInf.toggle()
                                                    OrderDetialsView.toggle()
                                                   
                                                   
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
        }
    }
}

struct INVOICE:View{
    var body: some View{
        Text("INVOICE")
    }
}

struct ORDERVSINVOICE:View{
    @Binding var invoice: [getInvoice]
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
                                ScrollView{
                                  
                                    ForEach(0..<invoice.count, id: \.self) { index in
                                        HStack{
                                            VStack{
                                                HStack{
                                                    Text("Relivet Animal Health")
                                                        .font(.system(size: 14))
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                HStack{
                                                    Text(invoice[index].OrderID)
                                                        .font(.system(size: 14))
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
                                                HStack{
                                                    
                                                    Image(systemName:"ellipsis.circle.fill")
                                                        .resizable()
                                                        .frame(width: 12,height: 12)
                                                        .foregroundColor(.red)
                                                    Text("Pending")
                                                        .font(.system(size: 14))
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
                                            //Spacer()
                                            Rectangle()
                                                .frame(width: 0.7)
                                                .foregroundColor(.gray)
                                                .padding(.bottom,10)
                                                .padding(.top,10)
                                            //Spacer()
                                            VStack{
                                                HStack{
                                                    
                                                    Image(systemName:"ellipsis.circle.fill")
                                                        .resizable()
                                                        .frame(width: 12,height: 12)
                                                        .foregroundColor(.red)
                                                    Text("Pending")
                                                        .font(.system(size: 14))
                                                    Spacer()
                                                    
                                                }
                                            }
                                            
                                        }
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.black)
                                            .padding(.leading,10)
                                            .padding(.trailing,10)
                  
              }
        }
        }
        }
        }

struct AddSomeViewe:View{
    @Binding var HistoryInf:Bool
    @Binding var OrderDetialsView:Bool
//    @Binding var ProName : [String]
//    @Binding var Qty : [String]
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
        .navigationBarHidden(true)
        
    }
}
