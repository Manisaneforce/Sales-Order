//
//  PaymentScreen.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI
import URLImage
import Alamofire
//import Jiopay_pg_uat
struct Payment_Data: Any {
    let id = UUID()
    var orderId : String
    var initiatedOn:String
    var updatedOn:String
    var totalAmt:String
    var  status:String
    var message:String
    var transactionId:String
    var Color_Code:Color
}
var Payment_Detils_Data:[Payment_Data] = []

struct PaymentScreen: View, DateSelection{
   
    @State private var selectedDate = Date()
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = ""
    @State private var ToDate = ""
    @State private var CalenderTit = ""
    @State private var navigateToHomepage = false
    @State private var Filterdate = false
    @State private var SelectFromDate = Date()
    @State private var loader:Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let currentDate = Date()
    let calendar = Calendar.current
    @ObservedObject var monitor = Monitor()
    @State private var No_Data_Mes = ""
    var body: some View {
        NavigationView{
            VStack{
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
                            Text("PAYMENT LEDGER")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                            
                            Spacer()
                        }
                        }else{
                            Internet_Connection()
                        }
                        
                    }.onReceive(monitor.$status) { newStatus in
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
                        Payment_Detils()
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
                        
                        //.padding(10)
                        
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
                    
                    if !Payment_Detils_Data.isEmpty{
                        Payment_Scroll()
                    }else{
                        Spacer()
                        Text(No_Data_Mes)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                        Spacer()
                    }
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
                                Payment_Detils()
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
                    quick_date_Selection_view(Filterdate: $Filterdate, FromDate: $FromDate, SelectFromDate: $SelectFromDate, ToDate: $ToDate, Loader: $loader,delegate: self)
                }
                if loader{
                    Sales_Order.loader()
                }
            }
        }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
    func didTapButton(in selection: quick_date_Selection_view) {
        loader.toggle()
        Payment_Detils()
    }
    func  Payment_Detils(){
        loader.toggle()
        Payment_Detils_Data.removeAll()
        let axn = "get/payment_ledger"
        let apiKey: String = "\(axn)&sfc=\(CustDet.shared.CusId)&from=\(FromDate)&to=\(ToDate)"
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON{ response in
            switch response.result {
            case .success(let value):
                print(value)
                if let json = value as? [String:AnyObject] {
                    if let response = json["response"] as? [AnyObject]{
                        for i in response{
                            print(i)
                            let Amt = String(i["totalAmt"] as? Double ?? 0)
                            let color = Color(hex: i["colorCode"] as? String ?? "#000000")
                            
                            Payment_Detils_Data.append(Payment_Data(orderId: i["orderId"] as? String ?? "", initiatedOn: i["initiatedOn"] as? String ?? "", updatedOn: i["updatedOn"] as? String ?? "", totalAmt: Amt, status: i["status"] as? String ?? "", message: i["message"] as? String ?? "", transactionId: i["transactionId"] as? String ?? "", Color_Code: color))
                        }
                    }else{
                        No_Data_Mes = json["msg"] as? String ?? ""
                    }
                }
                loader.toggle()
            case .failure(let error):
                print(error)
                No_Data_Mes = error.localizedDescription
                loader.toggle()
            }
        }
    }
    
    private func calculateStartDate(for days: Int) -> Date {
         let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
         return startDate ?? currentDate
     }
    
    private  func Selectdate(){
          if SelMode == "DOF"{
              SelectFromDate = selectedDate
              FromDate=dateFormatter.string(from: selectedDate)
          }
          if SelMode == "DOT"{
              ToDate = dateFormatter.string(from: selectedDate)
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
}
struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen()
       
    }
}

struct Payment_Scroll:View{
    var body: some View{
        ScrollView{
            ForEach(Payment_Detils_Data.indices, id: \.self) { index in
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                                   .fill(Color.white)
                                  // .shadow(radius: 5)
                VStack{
                    HStack{
                        Text("OrderId :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].orderId)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.56, green: 0.27, blue: 0.68, opacity: 1.00))
                        Spacer()
                    }
                    .padding(.vertical,2)
                    HStack{
                        Text("Transaction Id :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].transactionId)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.56, green: 0.27, blue: 0.68, opacity: 1.00))
                        Spacer()
                    }
                    .padding(.vertical,2)
                    HStack{
                        Text("TotalAmt :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].totalAmt)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.56, green: 0.27, blue: 0.68, opacity: 1.00))
                        Spacer()
                    }
                    .padding(.vertical,2)
                    HStack{
                        Text("initiatedOn :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].initiatedOn)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.56, green: 0.27, blue: 0.68, opacity: 1.00))
                        Spacer()
                    }
                    .padding(.vertical,2)
                    HStack{
                        Text("updatedOn :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].updatedOn)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.56, green: 0.27, blue: 0.68, opacity: 1.00))
                        Spacer()
                    }
                    .padding(.vertical,2)
                  
                    HStack{
                        Text("Status :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].status)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Payment_Detils_Data[index].Color_Code)
                        Spacer()
                    }
                    .padding(.vertical,2)
                    HStack{
                        Text("Message :")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Text(Payment_Detils_Data[index].message)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical,2)
                }
                .padding(.horizontal,5)
                .padding(.vertical,5)
            }
                .padding(.horizontal,5)
                .padding(.vertical,2)
            }
        }
    }
}

extension Color {
    
    
    init(hex: String) {
            let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            let scanner = Scanner(string: hexString)
            
            if hexString.hasPrefix("#") {
                scanner.scanLocation = 1
            }
            
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
            
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red   = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue  = Double(b) / 255.0
            
            self.init(red: red, green: green, blue: blue)
        }
}





//For Testing Code
struct SkeletonLoader: View {
    @State private var animation = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5), Color.gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
            .frame(width: 100, height: 10)
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .top, endPoint: .bottom))
                        .mask(
                            Rectangle()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height)
                                .offset(x: animation ? geometry.size.width : -geometry.size.width)
                        )
                        .offset(x: animation ? geometry.size.width : -geometry.size.width)
                        .animation(
                            Animation.linear(duration: 1.2)
                                .repeatForever(autoreverses: false)
                        )
                }
            )
            .onAppear {
                self.animation.toggle()
            }
    }
}


struct Loader: View {
    @State private var isLoading = true

    var body: some View {
     
            ForEach(0..<5, id: \.self) { index in
                if isLoading {
                    ShimmeringSkeletonRow()
                        .transition(.opacity)
                } else {
                    DataRow(index: index)
                }
            }
            .onAppear {
                // Simulate loading delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        
    }
}

struct ShimmeringSkeletonRow: View {
    @State private var isShimmering = false
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(width: 50,height: 50)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(RoundedRectangle(cornerRadius: 8))
                                .opacity(isShimmering ? 1 : 0)
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .onAppear {
                                    self.isShimmering = true
                                }
                        )
                    
                }
                VStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .mask(RoundedRectangle(cornerRadius: 8))
                            .opacity(isShimmering ? 1 : 0)
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false)
                            )
                            .onAppear {
                                self.isShimmering = true
                            }
                    )
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(RoundedRectangle(cornerRadius: 8))
                                .opacity(isShimmering ? 1 : 0)
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .onAppear {
                                    self.isShimmering = true
                                }
                        )
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(RoundedRectangle(cornerRadius: 8))
                                .opacity(isShimmering ? 1 : 0)
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .onAppear {
                                    self.isShimmering = true
                                }
                        )
            }
            }
        }
}
}

struct ShimmeringSkeletonRow_For_Order: View {
    @State private var isShimmering = false
    var body: some View{
        VStack{
            HStack{
               
                VStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .mask(RoundedRectangle(cornerRadius: 8))
                            .opacity(isShimmering ? 1 : 0)
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false)
                            )
                            .onAppear {
                                self.isShimmering = true
                            }
                    )
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .padding(.vertical, 5)
                        .padding(.leading, 10)
                        .padding(.trailing,50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(RoundedRectangle(cornerRadius: 8))
                                .opacity(isShimmering ? 1 : 0)
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .onAppear {
                                    self.isShimmering = true
                                }
                        )
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .padding(.vertical, 5)
                        .padding(.leading, 10)
                        .padding(.trailing,80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(RoundedRectangle(cornerRadius: 8))
                                .opacity(isShimmering ? 1 : 0)
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false)
                                )
                                .onAppear {
                                    self.isShimmering = true
                                }
                        )
            }
            }
        }
        .padding(.vertical,10)
    }
}


struct LoaderSkil: View{
    @State private var isShimmering = false
    var body: some View{
        VStack{
            
        }
    }
}

struct DataRow: View {
    var index: Int

    var body: some View {
        Text("Row \(index)")
            .font(.title)
            .padding()
    }
}



