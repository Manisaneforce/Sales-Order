//
//  MyOrdersScreen.swift
//  Sales Order
//
//  Created by San eforce on 05/09/23.
//

import SwiftUI
import Alamofire
struct OrderDetails: Any{
    let OrderNo : String
    let No_Of_items : String
    let Quantity : String
    let Order_Value : String
    let Status : String
    let Order_Date : String
    let isPaid : String
}
struct MyOrdersScreen: View {
    @State private var Filterdate = false
    @State private var isCalendarVisible = false
    @State private var selectedDate = Date()
    @State private var OrderPaymentDetails:[OrderDetails]=[]
    @State private var FilterDate = ""
    @State private var CurrentData = ""
    @State private var NaviOrdeDetNiew = false
    
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
                        .foregroundColor(Color.blue)
                        .frame(height: 80)
                    
                    HStack {
                        
                        Button(action: {
                            
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
                    
                    
                }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                
                
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        HStack {
                            if #available(iOS 15.0, *) {
                                Text("\(CurrentData)")
                            } else {
                                // Fallback on earlier versions
                            }
                            Image(systemName: "calendar")
                                .foregroundColor(Color.blue)
                        }
                    }
                    .onTapGesture {
                        
                        isCalendarVisible = true
                    }
                    .padding(10)
                    .sheet(isPresented: $isCalendarVisible) {
                                   CalendarView(selectedDate: $selectedDate, isCalendarVisible: $isCalendarVisible)
                               }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        HStack {
                            Text("\(CurrentData)")
                            Image(systemName: "calendar")
                                .foregroundColor(Color.blue)
                        }
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
                        .foregroundColor(Color.blue)
                        .frame(height: 40)
                    HStack(spacing:40){
                        Text("Descrition")
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
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
                .onAppear{
                    OrderPaymentDetails.removeAll()
                    FilterDate=(formattedDate(date: currentDate))
                    CurrentData = (formattedDate(date: currentDate))
                
                    print(selectedDate)
                    OrderDetailsTriger()
                }
                List(0 ..< OrderPaymentDetails.count, id: \.self) { index in
                    VStack{
                        HStack(spacing:45){
                            Text(OrderPaymentDetails[index].OrderNo)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].No_Of_items)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Quantity)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Order_Value)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                            Text(OrderPaymentDetails[index].Status)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.trailing)
                            
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
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                      
                    }
                    .onTapGesture{
                        print(index)
                        NaviOrdeDetNiew = true
                    }
                }
                .listStyle(PlainListStyle())
                NavigationLink(destination: OrderDetView(), isActive: $NaviOrdeDetNiew) {
                                EmptyView()
                            }
                Spacer()
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
                                FilterDate = (formattedDate(date: calculateStartDate(for: 7)))
                                CurrentData = (formattedDate(date: currentDate))
                                OrderDetailsTriger()
                                print(FilterDate)
                                print(CurrentData)
                            }
                            
                        Divider()
                        Text("Last 30 days")
                            .onTapGesture{
                                OrderPaymentDetails.removeAll()
                                Filterdate.toggle()
                                FilterDate = (formattedDate(date: calculateStartDate(for: 30)))
                                CurrentData = (formattedDate(date: currentDate))
                                OrderDetailsTriger()
                                print(FilterDate)
                                print(CurrentData)
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
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func calculateStartDate(for days: Int) -> Date {
        let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
        return startDate ?? currentDate
    }
    func OrderDetailsTriger(){
        let axn = "get/orderlst&sfCode=96&fromdate=\(FilterDate)&todate=\(CurrentData)"
      
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
        OrderDetView()
    }
}


struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isCalendarVisible: Bool
    @State private var temporarySelectedDate: Date

    init(selectedDate: Binding<Date>, isCalendarVisible: Binding<Bool>) {
        _selectedDate = selectedDate
        _isCalendarVisible = isCalendarVisible
        _temporarySelectedDate = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $temporarySelectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .onAppear {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    temporarySelectedDate = dateFormatter.date(from: dateFormatter.string(from: selectedDate)) ?? selectedDate
                }

            Button("Done") {
                selectedDate = temporarySelectedDate
                isCalendarVisible = false // Close the calendar when "Done" is tapped
                printSelectedDate(selectedDate)
            }
            .padding()
            
            Text("Selected Date: \(formattedDate(date: selectedDate))")
                .font(.headline)
                .foregroundColor(.blue)
        }
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func printSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        print("Selected Date: \(formattedDate)")
        
    }
}

struct OrderDetView:View{
    @State private var phase = 0.0
    var body: some View{
        NavigationView{
        ZStack{
            Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(height: 80)
                    
                    HStack {
                        
                        Button(action: {
                            
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
                    VStack{
                        HStack(spacing:100){
                            Text("Relivate Animale Health")
                            
                            Text("ORDER")
                        }
                        HStack{
                            Image(systemName: "phone.circle.fill")
                                .foregroundColor(Color.blue)
                            Text("99")
                            Spacer()
                        }
                        .padding(.leading,17)
                        ZStack{
                            Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2,dash: [5]))
                            
                                .foregroundColor(Color.gray)
                            
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
                    VStack{
                        HStack(spacing:180){
                            Text("MUMBAI01-2023")
                            Text("Delivery")
                        }
                        .padding(10)
                        HStack{
                            Text("05/09/2023 10:13:38")
                            Spacer()
                        }
                        .padding(10)
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
