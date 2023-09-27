//
//  ContentView.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI
import Alamofire
import Foundation

struct Outputdata {
    var data: [String: AnyObject] = [:]
}
var phoneNumber2: String = ""
struct ContentView: View {
    @State private var phoneNumber: String = ""
    //@State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @State private var isTextFieldHidden: Bool = false
    @State private var isTextFieldHidden2: Bool = true
    @State private var OTPtext: Bool = true
    @State private var Mobilnumber:Bool = false
    @State private var Verybutton:Bool = true
    @State private var oldValue = ""
    @State private var VerifyBt: Bool = true
    @State private var SubmitBt: Bool = false
    @State private var objcalls: [AnyObject]?
    @State private var showOTPVerifyView = false
    @State private var showToast = false
    @State private var ShowTost = ""
    @State private var NavigteBoll = false
    @State private var jsondata = Outputdata()
    @State private var StoragePhoneNumber = ""
    @State private var userEmail:String = UserDefaults.standard.string(forKey: "savedPhoneNumber") ?? ""
    @State private var HomePageNvigater:Bool = false
   // @State private var jsondata = JSONData()

    @State private var Value = ""

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
                
                LottieUIView(filename: "mobile_number").frame(width: 180,height: 180)
                    .offset(y: -60)
                    .onAppear {
                            print("Saved Value  \(userEmail)")
                        if userEmail.isEmpty{
                            HomePageNvigater = false
                        }else{
                           HomePageNvigater = true
                        }
                      

                    }
             
                if  !Mobilnumber{
                    Text("Enter your registered mobile number")
                        .font(.system(size: 17))
                        .font(.title)
                        .foregroundColor(Color.gray)
                        .frame(width: 400, height: 120)
                        .offset(y: 50)
                }
                if !isTextFieldHidden {
                    TextField("Mobile Number", text: $phoneNumber)
                       // .border(Color.blue, width: 2)
                        .cornerRadius(10)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 325)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ColorData.shared.HeaderColor, lineWidth: 2)
                        )
                        .offset(y: 100)
                        .keyboardType(.numberPad)
                        .onChange(of: phoneNumber, perform: { newValue in
                            // Limit the phone number to 10 characters
                            if newValue.count > 10 {
                                phoneNumber = String(newValue.prefix(10))
                               
                            }
                            // Remove non-numeric characters
                            phoneNumber = phoneNumber.filter { "0123456789".contains($0) }
                            //UserDefaults.standard.set(phoneNumber, forKey: "savedPhoneNumber")
                        })
                }
                

                if #available(iOS 15.0, *) {
                    //NavigationLink(destination: OTPVerify(numberOffFields: 6)){
                    Button(action: {
                       // var StoragePhoneNumber = ""
                        
                        
                        
                        
                        let axn = "send/sms"
                        let apiKey = "\(axn)&mobile=\(phoneNumber)"
                        phoneNumber2 = phoneNumber
                        print(phoneNumber2)
                        
                        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
                            .validate(statusCode: 200 ..< 299)
                            .responseJSON { response in
                                switch response.result {
                                case .success(let value):
                                    if let json = value as? [String: AnyObject] {
                                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                                            print("Error: Cannot convert JSON object to Pretty JSON data")
                                            return
                                        }
                                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                            print("Error: Could print JSON in String")
                                            return
                                        }
                                        
                                        print(prettyPrintedJson)
                                        jsondata.data = json
                                        
                                        let mobileNumber = json["mobile"] as? String ?? ""
                                        if mobileNumber.count < 10 {
                                            // If the mobile number is less than 10 characters
                                            print(json["result"] as? String ?? "")
                                            ShowTost = (json["result"] as? String ?? "")
                                            showToast = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showToast = false
                                            }
                                        } else {
                                            NavigteBoll = true
                                            // If the mobile number is 10 characters or more
                                            print(json["msg"] as? String ?? "")
                                            ShowTost = json["msg"] as? String ?? ""
                                            showToast = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showToast = false
                                            }
                                           
                                        }
                                        

                                 
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                    }) {
                        Text("SEND OTP")
                            //.font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .frame(width: 325, height: 40)
                            .background(ColorData.shared.HeaderColor)
                            .cornerRadius(10)
                    }
                    .toast(isPresented: $showToast, message: "\(ShowTost)")
                    .offset(y: 150)
                    
            }
                if NavigteBoll {
                    if #available(iOS 15.0, *) {
                        NavigationLink(
                            destination: OTPVerify(numberOffFields: 6, jsondata: $jsondata), // Make sure you're using $jsondata here
                            isActive: $NavigteBoll
                        ) {
                            EmptyView()
                        }
                    } else {
                        // Handle non-iOS 15 case if needed
                    }
                }
                NavigationLink(destination: HomePage(), isActive: $HomePageNvigater) {
                    EmptyView()
                }
                
            
        }
           
    }
        .navigationBarHidden(true)
        
            }
        }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            if #available(iOS 15.0, *) {
                ContentView()
                //AddNewView()
            } else {
                
            }
        }
    }


struct AddNewView: View {
    var body: some View{
        VStack{
            Image("logo_new")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 100)
            
            VStack{
                Text("Welcome to ReliVet")
                    .font(.title)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundColor(Color.gray)
                Text("Sign in to continue")
                    .font(.system(size: 20))
                    .font(.title)
                    .foregroundColor(Color.gray)
                
                    
            }
        }
    }
}
