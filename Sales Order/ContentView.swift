//
//  ContentView.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI
import Alamofire
import Foundation
import AppTrackingTransparency
import Combine

struct Outputdata {
    var data: [String: AnyObject] = [:]
}
var phoneNumber2: String = ""
struct ContentView: View {
    @State private var phoneNumber: String = ""
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
    @ObservedObject var monitor = Monitor()
    @State private var Loader = false
    @State private var showAlert_Int = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var Value = ""
    @State var isTapped = false
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
                            
                            
//                            TextField("Mobile Number", text: $phoneNumber)
//                            // .border(Color.blue, width: 2)
//                                .cornerRadius(5)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(ColorData.shared.HeaderColor, lineWidth: 1.5)
//                                )
//                                .padding(.horizontal,15)
//                                .keyboardType(.numberPad)
//                                .onChange(of: phoneNumber, perform: { newValue in
//                                    if newValue.count > 10 {
//                                        phoneNumber = String(newValue.prefix(10))
//
//                                    }
//                                    phoneNumber = phoneNumber.filter { "0123456789".contains($0) }
//                                })
                            VStack(alignment: .leading, spacing: 4) {
                                HStack{
                                    TextField("", text: $phoneNumber) { status in
                                        if status {
                                            withAnimation(.easeIn) {
                                                isTapped = true
                                            }
                                        }
                                    } onCommit: {
                                        if phoneNumber == "" {
                                            withAnimation(.easeOut) {
                                                isTapped = false
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.top, isTapped ? 20 : 5)
                                    .background(
                                        Text("Mobile Number")
                                            .font(.custom("Poppins-Bold", size: 13))
                                            .scaleEffect(isTapped ? 0.8 : 1)
                                            .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                                            .padding(.leading,5)
                                            .foregroundColor(.gray),
                                        alignment: .leading
                                    )
                                    .keyboardType(.numberPad)
                                    .onChange(of: phoneNumber) { newValue in
                                        if newValue.count > 10 {
                                            phoneNumber = String(newValue.prefix(10))
                                        }
                                        phoneNumber = phoneNumber.filter { "0123456789".contains($0) }
                                    }
                                    Spacer()
                                    Text("\(phoneNumber.count)/10")
                                        .padding(.trailing, 10)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                    
                                    
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                Color.gray.opacity(0.09)
                                    .padding(.horizontal, 15)
                                    .cornerRadius(5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(ColorData.shared.HeaderColor, lineWidth: 1.5)
                                    .padding(.horizontal, 15)
                            )
                            

                            if #available(iOS 15.0, *) {
                                
                                    Button(action: {
                                        if monitor.status == .disconnected {
                                                        ShowAlert(title: "Information", message: "Check the Internet Connection")
                                                        return
                                                    }
                                        
                                        let axn = "send/sms"
                                        let apiKey = "\(axn)&mobile=\(phoneNumber)"
                                        phoneNumber2 = phoneNumber
                                        print(phoneNumber2)
                                        Loader.toggle()
                                        AF.request("https://rad.salesjump.in/server/Db_Retail_v100.php?axn=" + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
                                            .validate(statusCode: 200 ..< 299)
                                            .responseJSON { response in
                                                switch response.result {
                                                case .success(let value):
                                                    Loader.toggle()
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
                                    }.alert(isPresented: $showAlert_Int) {
                                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .destructive(Text("Ok")))
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
                            VStack{
                                Text("App Version \(Bundle.main.appVersionLong)")
                                    .padding(.bottom,10)
                                    .padding(.top,150)
                                    .font(.system(size: 12))
                            }
                           
                        }
                       
                  Spacer()
                }
                //.ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                if Loader{
                    loader()
                }
            }
            .toast(isPresented: $showToast, message: "\(ShowTost)")
            .frame(width: geometry.size.width, height: geometry.size.height)
                
        }
           
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
            }
    private func ShowAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert_Int = true
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
               
            } else {
                
            }
        }
    }

struct PrivacyPolicy:View{
    @State private var isChecked = false
    @ObservedObject var monitor = Monitor()
   
    var body: some View{
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                if monitor.status == .connected {
                    HStack {
                        Text("PRIVACY POLICY")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                            .padding(.leading,10)
                        
                        Spacer()
                        
                    }
                }else{
                    Internet_Connection()
                }
                
            }  .onReceive(monitor.$status) { newStatus in
                if newStatus == .connected {
                 }
              }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity)
            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
            
            WebViews(urlString: "https://rad.salesjump.in/privacyrad.html")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.horizontal,10)
            
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
                            window.rootViewController = UIHostingController(rootView: NewMobileNoScrean())
                        }
                    }else{
                    }
                }
            }
        }
    }
}
struct CheckPermissions:View{
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(ColorData.shared.HeaderColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("ReliVet")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 40))
                    Spacer()
                }
                .padding(.top,50)
                .padding(.leading,16)
                
                VStack{
                    Text("Turning on tracking location services allow us to provide features Like :")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .padding(.vertical,5)
                VStack{
                    HStack{
                        Image(systemName: "location.circle")
                            .resizable()
                            .frame(width: 35,height: 35)
                            .padding(.horizontal,5)
                        Text("Getting Location For Order Submit")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .padding(.trailing,50)
                        Spacer()
                    }
                    HStack{
                        Image("geotag-b")
                            .resizable()
                            .frame(width: 35,height: 35)
                            .padding(.horizontal,5)
                        Text("Getting Delivery Address Of Customer")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .padding(.trailing,50)
                        Spacer()
                    }
                }
                .padding(.top,20)
                .padding(.leading,20)
                
                
                Spacer()
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 40)
                        Text("Continue")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .onTapGesture {
                        if #available(iOS 14, *) {
                            ATTrackingManager.requestTrackingAuthorization { status in
                                switch status {
                                    case .authorized:
                                        print("enable tracking")
                                    case .denied:
                                        print("disable tracking")
                                    default:
                                        print("disable tracking")
                                }
                                UserDefaults.standard.set(true, forKey: "TrackPermission")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    
                                    if let window = UIApplication.shared.windows.first {
                                        window.rootViewController = UIHostingController(rootView: ContentView())
                                    }
                                }
                            }
                        }else{}
                    }
                    .padding(.horizontal,40)
                    Text("You can change this later in the settings app")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    
                }
                .padding(.bottom,80)
            }
                
        }
    }
}



struct NewMobileNoScrean:View{
    @State private var phoneNumber: String = ""
    @ObservedObject var monitor = Monitor()
    @State private var showAlert_Int = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var Loader = false
    @State private var jsondata = Outputdata()
    @State private var showToast = false
    @State private var ShowTost = ""
    @State private var NavigteBoll = false
    @State private var HomePageNvigater:Bool = false
    @State private var PrivacySc = UserDefaults.standard.string(forKey: "Privacydata") ?? ""
    @State private var userEmail:String = UserDefaults.standard.string(forKey: "savedPhoneNumber") ?? ""
    @State private var showAlert = false
    @State private var alertMessages = ""
    @State var isTapped = false
    var body: some View{
        NavigationView {
        ZStack{
            VStack{
                
                VStack(alignment:.center){
                    Image("logo_new")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250,height: 150)
                    
                    Image("Welcome to ReliVet!")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200,height: 50)
                    Text("Sign in to continue")
                        .font(.custom("Poppins-SemiBold", size: 12))
                }
                Spacer()
                    .onAppear {
                        print(PrivacySc)
                        if (PrivacySc == ""){
                            PriPolicy()
                        }
                        print("Saved Value  \(userEmail)")
                        if userEmail.isEmpty{
                        }else{
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: HomePage())
                            }
                        }
                    }
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 350)
                    VStack(alignment: .center){
                        VStack(spacing:0){
                            Image("NumberPad")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180,height: 130)
                            
                            Text("Enter Registered 10 digit Mobile number")
                                .font(.system(size: 12))
                        }
                        VStack(alignment: .center){
                            VStack(alignment: .leading, spacing: 4) {
                                HStack{
                                    TextField("", text: $phoneNumber) { status in
                                        if status {
                                            withAnimation(.easeIn) {
                                                isTapped = true
                                            }
                                        }
                                    } onCommit: {
                                        if phoneNumber == "" {
                                            withAnimation(.easeOut) {
                                                isTapped = false
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.top, isTapped ? 20 : 5)
                                    .background(
                                        Text("Mobile Number")
                                            .font(.custom("Poppins-Bold", size: 13))
                                            .scaleEffect(isTapped ? 0.8 : 1)
                                            .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                                            .padding(.leading,5)
                                            .foregroundColor(.gray),
                                        alignment: .leading
                                    )
                                    .keyboardType(.numberPad)
                                    .onChange(of: phoneNumber) { newValue in
                                        if newValue.count > 10 {
                                            phoneNumber = String(newValue.prefix(10))
                                        }
                                        phoneNumber = phoneNumber.filter { "0123456789".contains($0) }
                                    }
                                    Spacer()
                                    Text("\(phoneNumber.count)/10")
                                        .padding(.trailing, 10)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                    
                                    
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                Color.gray.opacity(0.09)
                                    .padding(.horizontal, 15)
                                    .cornerRadius(5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(ColorData.shared.HeaderColor, lineWidth: 1.5)
                                    .padding(.horizontal, 15)
                            )
                            .padding()
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                SendOTP()
                                
                            }) {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(ColorData.shared.HeaderColor)
                                        .frame(height: 40)
                                        .cornerRadius(10)
                                    Text("Send OTP")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.center)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal,22)
                            }.alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text(alertMessages),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            if NavigteBoll {
                                if #available(iOS 15.0, *) {
                                    NavigationLink(
//                                        destination: OTPVerify(numberOffFields: 6, jsondata: $jsondata), // Make sure you're using $jsondata here
//                                        isActive: $NavigteBoll
                                        destination: NewOTPScrean(numberOffFields: 6, jsondata: $jsondata), // Make sure you're using $jsondata here
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
                            HStack{
                                Spacer()
                                Text("Version \(Bundle.main.appVersionLong)")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }.padding(.horizontal,20)
                            
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                        .padding(10)
                )
                .padding(.horizontal,10)
                .padding(.top,-10)
                Spacer()
                VStack(alignment: .center){
                    Text("Powered by")
                        .font(.custom("Poppins-SemiBold", size: 10))
                    Image("SalesJumpLog")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100,height: 50)
                }
            }
            if Loader{
                loader()
            }
        }  .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toast(isPresented: $showToast, message: "\(ShowTost)")
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
}
    private func ShowAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert_Int = true
    }
    func PriPolicy(){
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: PrivacyPolicy())
        }
    }
    func SendOTP(){
        if monitor.status == .disconnected {
            ShowAlert(title: "Information", message: "Check the Internet Connection")
            return
        }
        let axn = "send/sms"
        let apiKey = "\(axn)&mobile=\(phoneNumber)"
        phoneNumber2 = phoneNumber
        print(phoneNumber2)
        Loader.toggle()
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    Loader.toggle()
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
                    Loader.toggle()
                    alertMessages = error.localizedDescription
                    showAlert = true
                }
            }
    }
}
