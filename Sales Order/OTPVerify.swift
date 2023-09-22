//
//  OTPVerify.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI
import Foundation
import Alamofire

@available(iOS 15.0, *)
struct OTPVerify: View {
   
//    @State private var phoneNumber: String = ""
//    @State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    @State private var showToast = false
    @State private var toststring = ""
    @State private var NavigteBoll = false
    @State private var NotRegisterSc = false
    @State private var Msg = ""
    @State private var showToasts = false
    @State private var timer: Timer?
    @State private var remainingTime = 5
    @State private var showResendButton = false
    
    @Binding var jsondata: Outputdata
    //@Binding var phoneNumber:String
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
                VStack(spacing: 55) {
                Image("logo_new")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 100)
                    
                    .padding(.top,180)
                    Spacer()
                   
                        Text("Welcome to ReliVet")
                            .font(.title)
                            .bold()
                            .font(.system(size: 24))
                            .foregroundColor(Color.gray)
                            .frame(width: 300, height: 300)
                        
                            .padding(.top,-200)
                        
                        Text("Sign in to continue")
                            .font(.system(size: 20))
                            .font(.title)
                            .foregroundColor(Color.gray)
                            .frame(width: 200, height: 150)
                        
                           .padding(.top,-250)
                  
            
                LottieUIView(filename: "OTP").frame(width: 200,height: 200)
                    
                        .padding(.top,-250)
                
                
                Text("Enter your OTP")
                    .font(.system(size: 17))
                    .font(.title)
                    .foregroundColor(Color.gray)
                    .frame(width: 400, height: 120)
                    .padding(.top,-150)
                    
                    Spacer(minLength: 250)
                    
                        .onAppear {
                            startTimer()
                        }
                        .onDisappear {
                            timer?.invalidate()
                            timer = nil
                        }
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
                .padding(.top,-500)
                
                
                Button(action: {
                    print("JSON Data: \(jsondata.data)")
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
                        
                   // http://rad.salesjump.in/server/Db_Retail_v100.php?axn=get/login
                        let axn = "get/login"
                        let apiKey: String = "\(axn)"
                        let aFormData: [[String: Any]] = [[
                            "mobile":"\(phoneNumber2)",
                            "deviceid":"deviceToken"
                        ]]
                        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
                        let jsonString = String(data: jsonData!, encoding: .utf8)!
                        let params: Parameters = [
                            "data": jsonString
                        ]
                       print(params)
                        print(phoneNumber2)
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
                                    
                                    if let jsonData = prettyPrintedJson.data(using: .utf8){
                                        do{
                                            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                                
                                                
                                                if let results = jsonObject["msg"] as? String {
                                                    NotRegisterSc = true
                                                    print(results)
                                                    Msg = results
                                                } else {
                                                    
                                                    let result = jsonObject["result"] as? [[String:Any]]
                                                    print(result)
                                                    NavigteBoll = true
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
                        
                    }else{
                        toststring = "Pls Enter Correct OTP"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                
                }){
                    Text("Verify")
                        .frame(width: 300, height: 12)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    
                }
                .padding(.top,-400)
                    
                    if showResendButton {
                        Button(action: {
//                            .onAppear{
//                                APIClient()
//                            }
                            startTimer()
                            showResendButton = false
                        }) {
                            Text("Resend")
                                .font(.title)
                                .frame(height: 20)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, -400)
                    } else {
                        Text("OTP didn't receive? Resend the OTP  \(remainingTime) in seconds")
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                            .padding(.top, -400)
                    }
                     

                
            }
                if NavigteBoll {
                    NavigationLink(
                        destination: HomePage(),isActive: $NavigteBoll
                    ) {
                        EmptyView()
                    }
                }
                NavigationLink(
                    destination: NotRegister(Msg: $Msg),isActive: $NotRegisterSc
                ) {
                    EmptyView()
                }
                  
//                .toast(isPresented: $showToast, message: "\(toststring)")
//                                .padding(.top,-100)
        }
        
    }
      .navigationBarHidden(true)
    }
    private func startTimer() {
        remainingTime = 60
        showResendButton = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                showResendButton = true
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

@available(iOS 15.0, *)
struct OTPVerify_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerify(numberOffFields: 6, jsondata: .constant(Outputdata()))
      //  NotRegister()
    }
}
struct NotRegister: View {
    @Binding var Msg:String
    var body: some View{
        LottieUIView(filename: "something_went_wrong").frame(width: 200,height: 200)
        
        Text(Msg)
            .font(.system(size: 15))
            .fontWeight(.semibold)
            .padding(15)
       
        
    }
}



