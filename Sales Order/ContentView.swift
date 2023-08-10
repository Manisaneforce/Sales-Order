//
//  ContentView.swift
//  Sales Order
//
//  Created by San eforce on 02/08/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var phoneNumber2: String = ""
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

    @State private var Value = ""

    var body: some View {
       
        NavigationView {
            ZStack {
                Image("logo_new")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
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
                
                Image("Phonecall")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .offset(y: -60)
                
                // Show the text field conditionally based on the state variable
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
                        .border(Color.blue, width: 2)
                        .cornerRadius(10)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 325)
                        .offset(y: 100)
                        .keyboardType(.numberPad)  // Set keyboard to number pad
                        .onChange(of: phoneNumber, perform: { newValue in
                            // Limit the phone number to 10 characters
                            if newValue.count > 10 {
                                phoneNumber = String(newValue.prefix(10))
                            }
                            // Remove non-numeric characters
                            phoneNumber = phoneNumber.filter { "0123456789".contains($0) }
                        })
                }
                
                if #available(iOS 15.0, *) {
                    //NavigationLink(destination: OTPVerify(numberOffFields: 6)){
                    Button(action: {
                        let axn = "send/sms"
                        let apiKey = "\(axn)&mobile=\(phoneNumber)"
                        
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
                                        NavigationLink(destination:OTPVerify(numberOffFields: 6)){
                                            EmptyView()
                                        }
                                     
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                    }) {
                        Text("Submit")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    .offset(y: 145)
                    
                //}
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
            } else {
                
            }
        }
    }

