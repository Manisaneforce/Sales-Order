//
//  PaymentScreen.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI

struct PaymentScreen: View {
    @State private var selectedDate = Date()
    @State private var isPopoverVisible = false
    @State private var SelMode: String = ""
    @State private var FromDate = Date()
    @State private var ToDate = Date()
    @State private var CalenderTit = ""
    @State private var navigateToHomepage = false
    @Environment(\.presentationMode) var presentationMode
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
                            
                            Text("PAYMENT LEDGER")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                .padding(.leading,50)
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
                        }
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .padding(.bottom,8)
        })
    
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


//struct EditeOrder:View{
//    var body: some View{
//        ScrollView{
//            ForEach(0..<5, id: \.self) { index in
//                VStack{
//                    HStack{
//                        Image("sanlogo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 75,height: 75)
//                            .padding(.leading,10)
//                        Spacer()
//                        VStack{
//                            HStack{
//                                Text(AllPrvprod[index].ProName)
//                                    .font(.system(size: 14))
//                                    .fontWeight(.semibold)
//                                    .padding(.leading,10)
//                                Spacer()
//                            }
//                            HStack{
//                                Text(AllPrvprod[index].Uomnm)
//                                Spacer()
//                                Text("Rs: \(AllPrvprod[index].ProMRP)")
//                                    .font(.system(size: 12))
//                                    .fontWeight(.semibold)
//                            }
//                            .padding(.leading,10)
//                            .padding(.trailing,12)
//                            HStack{
//                                Button(action: {
//                                    deleteItem(at: index)
//                                }) {
//                                    Image(systemName: "trash.fill")
//                                        .foregroundColor(Color.red)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                                Spacer()
//                                HStack{
//                                Button(action:{
//                                    if filterItems[index].quantity > 0 {
//                                        filterItems[index].quantity -= 1
//                                    }
//                                    let ProId = AllPrvprod[index].ProID
//                                    if let jsonData = Allproddata.data(using: .utf8){
//                                        do{
//                                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
//                                                print(jsonArray)
//                                                let itemsWithTypID3 = jsonArray.filter { ($0["ERP_Code"] as? String) == ProId }
//
//                                                if !itemsWithTypID3.isEmpty {
//                                                    for item in itemsWithTypID3 {
//                                                        let Qty = String(filterItems[index].quantity)
//                                                        minusQty(sQty: Qty, SelectProd: item)
//
//                                                    }
//                                                } else {
//                                                    print("No data with TypID")
//                                                }
//
//                                            }
//                                        } catch{
//                                            print("Data is error\(error)")
//                                        }
//                                    }
//                                }){
//                                    Text("-")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                                    Text("\(filterItems[index].quantity)")
//                                        .fontWeight(.bold)
//                                        .foregroundColor(Color.black)
//                                    Button(action:{
//                                        ilterItems[index].quantity += 1
//                                        print(AllPrvprod[index].ProID)
//                                        let ProId = AllPrvprod[index].ProID
//                                        if let jsonData = Allproddata.data(using: .utf8){
//                                            do{
//                                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
//                                                    print(jsonArray)
//                                                    let itemsWithTypID3 = jsonArray.filter { ($0["ERP_Code"] as? String) == ProId }
//
//                                                    if !itemsWithTypID3.isEmpty {
//                                                        for item in itemsWithTypID3 {
//                                                            let Qty = String(filterItems[index].quantity)
//                                                            addQty(sQty: Qty, SelectProd: item)
//
//                                                        }
//                                                    } else {
//                                                        print("No data with TypID")
//                                                    }
//
//                                                }
//                                            } catch{
//                                                print("Data is error\(error)")
//                                            }
//                                        }
//                                    }){
//                                        Text("+")
//                                            .font(.headline)
//                                            .fontWeight(.bold)
//                                    }
//                                    .buttonStyle(PlainButtonStyle())
//                            }
//                                .padding(.vertical, 4)
//                                .padding(.horizontal, 15)
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.gray, lineWidth: 2)
//                                )
//                                .foregroundColor(Color.blue)
//                        }
//                            .padding(.leading,10)
//                            .padding(.trailing,10)
//                            .padding(.top,-5)
//                            Divider()
//                                .padding(5)
//
//                            HStack{
//                                Text("Total")
//                                    .font(.system(size: 14))
//                                    .fontWeight(.semibold)
//                                Spacer()
//                                Text("₹\(Double(AllPrvprod[index].ProMRP)! * Double(filterItems[index].quantity), specifier: "%.2f")")
//                                    .font(.system(size: 14))
//                                    .fontWeight(.semibold)
//                            }
//                            .padding(.leading,10)
//                            .padding(.trailing,10)
//                        }
//
//                    }
//                  Rectangle()
//                        .frame(height: 1)
//                        .foregroundColor(.gray)
//
//
//                }
//            }
//        }
//    }
//}

