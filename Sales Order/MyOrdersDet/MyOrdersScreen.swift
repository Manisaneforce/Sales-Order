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
                                Text(selectedDate.formatted(date: .long, time: .omitted))
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
                            Text("2023-09-05")
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
                    let axn = "get/orderlst&sfCode=96&fromdate=2023-09-05&todate=2023-09-05"
                  
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
                }
                .listStyle(PlainListStyle())
                
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
                                Filterdate.toggle()
                            }
                            
                        Divider()
                        Text("Last 30 days")
                            .onTapGesture{
                                Filterdate.toggle()
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
}

struct MyOrdersScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyOrdersScreen()
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
            // Here, you can implement your custom calendar picker.
            // For example, you can use a DatePicker or any other custom calendar UI.
            DatePicker("Select a date", selection: $temporarySelectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("Done") {
                selectedDate = temporarySelectedDate
                isCalendarVisible = false // Close the calendar when "Done" is tapped
            }
            .padding()
        }
    }
}
