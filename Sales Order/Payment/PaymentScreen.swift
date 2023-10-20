//
//  PaymentScreen.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI
//import Jiopay_pg_uat
struct PaymentScreen: View {
    @State private var selectedDate = Date()
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = ""
    @State private var ToDate = ""
    @State private var CalenderTit = ""
    @State private var navigateToHomepage = false
    @State private var Filterdate = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                            Text("PAYMENT LEDGER")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                //.padding(.leading,50)
                            Spacer()
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
                        HStack{
                            Text("Date")
                                .foregroundColor(Color.white)
                                .font(.system(size: 15))
                            Spacer()
                            HStack(spacing:40){
                                Text("Debit")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                Text("Credit")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                Text("Balance")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                                
                        }
                        .padding(10)
                    }
                   
                    .frame(height:40)
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        HStack{
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text("0.00")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                        .padding(10)
                    }
                    .frame(height: 50)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ColorData.shared.HeaderColor, lineWidth: 1)
                            .padding(10)
                    )
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
                           // Filterdate.toggle()
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
                            VStack{
                                
                                Text("Last 7 days")
                                 
                            }
                            .frame(width: 320)
                            .background(Color.white)
                                .onTapGesture{
                                    
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                                    
                                }
                            
                            Divider()
                            VStack{
                                Text("Last 30 days")
                            }
                            .frame(width: 320)
                            .background(Color.white)
                                .onTapGesture{
                                    Filterdate.toggle()
                                    FromDate = (formattedDate(date: calculateStartDate(for: 30)))
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
    

    private func calculateStartDate(for days: Int) -> Date {
         let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
         return startDate ?? currentDate
     }
    private  func Selectdate(){
          if SelMode == "DOF"{
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
}
struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen()
       
    }
}

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
