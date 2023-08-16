//
//  OTPVerify.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI
import Foundation

@available(iOS 15.0, *)
struct OTPVerify: View {
   
    @State private var phoneNumber: String = ""
    @State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    @State private var showToast = false
    @State private var toststring = ""
    @State private var NavigteBoll = false
    
    @Binding var jsondata: Outputdata
    let numberOffFields: Int
    @State var enterValue: [String]
    @State private var Value = ""
    init(numberOffFields: Int, jsondata: Binding<Outputdata>) {
        self.numberOffFields = numberOffFields
        self._jsondata = jsondata
        self.enterValue = Array(repeating: "", count: numberOffFields)
    }
   
    var body: some View {
        
        NavigationView {
        ZStack {
         
            Image("logo_new")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 100)
                .offset(y: -310)
            
            Text("Welcome to ReliVet")
                .font(.title)
                .bold()
                .font(.system(size: 24))
                .foregroundColor(Color.gray)
                .frame(width: 300, height: 300)
                .offset(y: -190)
            
            Text("Sign in to continue")
                .font(.system(size: 20))
                .font(.title)
                .foregroundColor(Color.gray)
                .frame(width: 200, height: 150)
                .offset(y: -160)
            
//            Image("Phonecall")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//                .offset(y: -60)
            LottieUIView(filename: "OTP").frame(width: 200,height: 200)
                .offset(y: -60)

            
            Text("Enter your OTP")
                .font(.system(size: 17))
                .font(.title)
                .foregroundColor(Color.gray)
                .frame(width: 400, height: 120)
                .offset(y: 50)
            
            
            HStack{
                
                ForEach(0..<6, id: \.self) {index in
                    TextField("", text: $enterValue[index], onEditingChanged:
                                { editing in
                        if editing{
                            oldValue = enterValue[index]
                        }
                        
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 42,height: 42)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(5)
                    .multilineTextAlignment(.center)
                    .offset(y: 95)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .onChange(of: enterValue[index]) { newValue in
                        if enterValue[index].count > 1{
                            let currentvalue = Array(enterValue[index])
                            print(currentvalue)
                            
                            if currentvalue[0] == Character(oldValue){
                                enterValue[index]=String(enterValue[index].suffix(1))
                            }else{
                                enterValue[index]=String(enterValue[index].prefix(1))
                            }
                        }
                        
                        if !newValue.isEmpty {
                            if index == numberOffFields - 1{
                                fieldFocus = nil
                            }else{
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        }else{
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
                }
                
            }
         
            //NavigationLink(destination: HomePage()) {
           
            Button(action: {
                print("JSON Data: \(jsondata.data)") // This will print the current value of jsondata
                let otpNumber = enterValue[0]+enterValue[1]+enterValue[2]+enterValue[3]+enterValue[4]+enterValue[5]
                print(otpNumber.count)
                let otpInt=Int(otpNumber)
                //print(otpInt!)
                let value: Int? = otpInt
                var item = 0
                if let unwrappedValue = value {
                    item=unwrappedValue
                    
                } else {
                    //Text("No value")
                }
                let otpdata = jsondata.data["otp"]
                print(item)
                print(otpdata as! Int)
                print(otpNumber.count >= 6)
                
                if item == otpdata as! Int {
                    print(item)
                    NavigteBoll = true
                }else{
                    toststring = "Pls Enter Correct OTP"
                    showToast = true
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                         showToast = false
                                     }
                }
                
//                if otpNumber.count >= 6 {
//                    toststring = "Enter Six Digit OTP number"
//                    showToast = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        showToast = false
//                    }
//                }
//                else if item != otpdata as! Int{
//                    toststring = "Pls Enter Correct OTP"
//                    showToast = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        showToast = false
//                    }
//                }
//                else if  otpNumber.isEmpty{
//                    toststring = "Enter OTP"
//                    showToast = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        showToast = false
//                    }
//                }
//                else{
//
//                }
                
                
            }){
                           Text("Verify")
                              .frame(width: 300, height: 12)
                               .font(.title)
                              .foregroundColor(.white)
                               .padding()
                               .background(Color.blue)
                              .cornerRadius(10)
                              
                     }
            .toast(isPresented: $showToast, message: "\(toststring)")
            .offset(y:148)
            if NavigteBoll {
                NavigationLink(
                    destination: HomePage(),isActive: $NavigteBoll
                ) {
                    EmptyView()
                }
            }

            
        }
        
    }
      .navigationBarHidden(true)
    }
}

@available(iOS 15.0, *)
struct OTPVerify_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerify(numberOffFields: 6, jsondata: .constant(Outputdata()))
    }
}
