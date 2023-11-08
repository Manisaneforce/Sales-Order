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
    @State private var PrivacySc = UserDefaults.standard.string(forKey: "Privacydata") ?? ""
    @State private var HomePageNvigater:Bool = false
   // @State private var jsondata = JSONData()

    @State private var Value = ""

    var body: some View {
       
        NavigationView {
            GeometryReader { geometry in
            ZStack{
                ScrollView(showsIndicators: false){
                   Spacer()
                        VStack(alignment: .center){
                            
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
                            .padding(.top,30)
                            
                            
                            LottieUIView(filename: "mobile_number").frame(width: 150,height: 150)
                                .onAppear {
                                    print(PrivacySc)
                                    if (PrivacySc == ""){
                                        PriPolicy()
                                    }
                                    print("Saved Value  \(userEmail)")
                                    if userEmail.isEmpty{
                                        //HomePageNvigater = false
                                    }else{
                                        if let window = UIApplication.shared.windows.first {
                                            window.rootViewController = UIHostingController(rootView: HomePage())
                                        }
                                    }
                                    
                                    
                                }
                            
                            Text("Enter your registered mobile number")
                                .font(.system(size: 17))
                                .font(.title)
                                .foregroundColor(Color.gray)
                                .padding(.bottom,30)
                            
                            
                            TextField("Mobile Number", text: $phoneNumber)
                            // .border(Color.blue, width: 2)
                                .cornerRadius(5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(ColorData.shared.HeaderColor, lineWidth: 1.5)
                                )
                                .padding(.horizontal,15)
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
                            
                            
                            
                            if #available(iOS 15.0, *) {
 
                                    Button(action: {
                                        
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
                                                            //ShowTost = (json["result"] as? String ?? "")
                                                            ShowTost = "Please enter a valid mobile number"
                                                            showToast = true
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                showToast = false
                                                            }
                                                        } else {
                                                            NavigteBoll = true
                                                            // If the mobile number is 10 characters or more
                                                            print(json["msg"] as? String ?? "")
                                                            //ShowTost = json["msg"] as? String ?? ""
                                                            ShowToastMes.shared.tost = "OTP sent successfully"
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
                                        ZStack{
                                        Rectangle()
                                            .foregroundColor(ColorData.shared.HeaderColor)
                                            .frame(height: 40)
                                            .cornerRadius(2)
                                        Text("SEND OTP")
                                            .fontWeight(.heavy)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(10)
                                        }
                                        .padding(15)
                                    }

                                
                                
                            }
                            if NavigteBoll {
                                if #available(iOS 15.0, *) {
                                    NavigationLink(
                                        destination: OTPVerify(numberOffFields: 6, jsondata: $jsondata), // Make sure you're using $jsondata here
                                        isActive: $NavigteBoll
                                    ) {
                                        EmptyView()
                                    }
                                } else{
                                    // Handle non-iOS 15 case if needed
                                }
                            }
                            NavigationLink(destination: HomePage(), isActive: $HomePageNvigater) {
                                EmptyView()
                            }
                            
                            Spacer()
                        }
                       
                  Spacer()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
            }
            .toast(isPresented: $showToast, message: "\(ShowTost)")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
           
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
            }
    func PriPolicy(){
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: PrivacyPolicy())
        }
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

struct PrivacyPolicy:View{
    @State private var isChecked = false
   
    var body: some View{
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                HStack {
                    Text("PRIVACY POLICY")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,50)
                        .padding(.leading,10)
                    
                    Spacer()
                    
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity)
            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
            WebViews(urlString: "https://rad.salesjump.in/server/radprivacy.html")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            Spacer()
            VStack(spacing: 10){
                HStack{
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .onTapGesture {
                            isChecked.toggle()
                        }
                    Text("Accept privacy policy")
                        .font(.system(size: 13))
                    
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal,10)
                ZStack{
                    Rectangle()
                        .foregroundColor(isChecked ? ColorData.shared.HeaderColor : .gray)
                        .frame(height: 40)
                        .cornerRadius(10)
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }
                .padding(.horizontal,10)
                .onTapGesture {
                    if (isChecked == true){
                        print(isChecked)
                        UserDefaults.standard.set(isChecked, forKey: "Privacydata")
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: ContentView())
                        }
                    }else{
                    }
                }
            }
        }
    }
}

//Full Button  click in Mobile Number Screen and OTP Screen == Error Fix But Didn't Show Toast
//Product not Change In Click Button RV Test = Error Fix
//Aliment Change In List View In MY Order Screen =  Error fix
//Didn’t save Discount Value in order Submite = Fix Error
