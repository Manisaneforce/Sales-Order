//
//  PaymentScreen.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI

//var SelMode: String = ""
//var FromDate = Date()
//var ToDate = Date()
//var Getdate = Date()
struct PaymentScreen: View {
    @State private var selectedDate = Date()
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = Date()
    @State private var ToDate = Date()
    @State private var CalenderTit = ""
    @State private var navigateToHomepage = false
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
                                navigateToHomepage = true
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
                        NavigationLink(destination: HomePage(), isActive: $navigateToHomepage) {
                                        EmptyView()
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
                                Text(dateFormatter.string(from: FromDate))
                                 
                                
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
                                Text(dateFormatter.string(from: ToDate))
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
                            
                            //.padding()
                        }
                    }
                    
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
    private  func Selectdate(){
          if SelMode == "DOF"{
              FromDate = selectedDate
          }
          if SelMode == "DOT"{
              ToDate = selectedDate
          }
      }
}



struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen()
    }
}


