//
//  OTPVerify.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI
import Foundation
import Alamofire
import Combine

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
    @State private var OtpView:Bool = true
    @State private var NotReg:Bool = false
    @State private var OtpLoader = false
    @ObservedObject var monitor = Monitor()
    @State private var showAlert_Int = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
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
        if OtpView{
            NavigationView {
                
                ZStack {
                    ScrollView(showsIndicators: false){
                    VStack{
                        VStack {
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
                            .padding(.top,40)
                            
                            LottieUIView(filename: "OTP").frame(width: 200,height: 200)
                            
                            Text("+91 \(phoneNumber2)")
                                .font(.system(size: 17))
                                .font(.title)
                                .foregroundColor(Color.gray)
                            Text("Enter your OTP")
                                .font(.system(size: 17))
                                .font(.title)
                                .foregroundColor(Color.gray)
                                .padding(.bottom,25)
                          
                            
                                .onAppear {
                                    Toast(mes: ShowToastMes.shared.tost)
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
                            
                           
                                Button(action: {
                                    if monitor.status == .disconnected {
                                                    ShowAlert(title: "Information", message: "Check the Internet Connection")
                                                    return
                                                }
                                    OtpLoader.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                                        
                                        let axn = "get/login"
                                        let apiKey: String = "\(axn)"
                                        let deviceID = UIDevice.current.identifierForVendor!.uuidString
                                        let aFormData: [[String: Any]] = [[
                                            "mobile":"\(phoneNumber2)",
                                            "deviceid":"\(deviceID)"
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
                                                                if let results = jsonObject["msg"] as? String  {
                                                                    if results == "" {
                                                                        if let result = jsonObject["result"] as? [[String:Any]], let firstResult = result.first {
                                                                            print(firstResult)
                                                                            UserDefaults.standard.set(prettyPrintedJson, forKey: "CustDet")
                                                                            UserDefaults.standard.set(prettyPrintedJson, forKey: "savedPhoneNumber")
                                                                            let CusName = firstResult["CusName"] as? String ?? ""
                                                                            let StkID = firstResult["StkID"] as? String ?? ""
                                                                            let Addr = firstResult["Addr"] as? String ?? ""
                                                                            let StkMob = firstResult["StkMob"] as? String ?? ""
                                                                            let StkNm = firstResult["StkNm"] as? String ?? ""
                                                                            let StkAddr = firstResult["StkAddr"] as? String ?? ""
                                                                            let CusID = firstResult["CusID"] as? String ?? ""
                                                                            let ERP_Code = firstResult["ERP_Code"] as? String ?? ""
                                                                            let Mob = firstResult["Mob"] as? String ?? ""
                                                                            let Div = firstResult["Div"] as? Int ?? 0
                                                                            let Det:[String:Any] = ["CusName":CusName,"StkID":StkID,"Addr":Addr,"StkMob":StkMob,"StkNm":StkNm,"StkAddr":StkAddr,"CusID":CusID,"ERP_Code":ERP_Code,"Mob":Mob,"Div":Div];
                                                                            print(Det)
                                                                            CustDet.shared.CusId = CusID
                                                                            CustDet.shared.CusName = CusName
                                                                            CustDet.shared.StkID = StkID
                                                                            CustDet.shared.Addr = Addr
                                                                            CustDet.shared.StkMob = StkMob
                                                                            CustDet.shared.StkNm = StkNm
                                                                            CustDet.shared.StkAddr = StkAddr
                                                                            CustDet.shared.ERP_Code = ERP_Code
                                                                            CustDet.shared .Mob = Mob
                                                                            CustDet.shared.Div = Div
                                                                            CustDet.shared.Det = Det
                                                                            NavigteBoll = true
                                                                        }
                                                                        //SyncData.shared.SyncAllData()
                                                                    }else{
                                                                        OtpView.toggle()
                                                                        NotReg.toggle()
                                                                        Msg = results
                                                                    }
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
                                       
                                        Toast(mes: "Pls Enter Correct OTP")
                                    }
                                        OtpLoader.toggle()
                                    }
                                }){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(ColorData.shared.HeaderColor)
                                            .frame(height: 40)
                                            .cornerRadius(2)
                                    Text("Verify")
                                        .fontWeight(.semibold)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(15)
                                .alert(isPresented: $showAlert_Int) {
                                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .destructive(Text("Ok")))
                                }
                                }
                            if showResendButton {
                                Button(action: {
                                    if monitor.status == .disconnected {
                                                    ShowAlert(title: "Information", message: "Check the Internet Connection")
                                                    return
                                                }
                                    startTimer()
                                    OtpReSend()
                                    showResendButton = false
                                }) {
                                    Text("Resend OTP")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text("OTP didn't receive? Resend the OTP  \(remainingTime) in seconds")
                                    .font(.custom("Poppins-SemiBold", size: 15))
                                    .padding(.horizontal,10)
                                    .multilineTextAlignment(.center)
                            }
                            
                        
                            
                        }
                        if NavigteBoll {
                            NavigationLink(
                                destination: HomePage(),isActive: $NavigteBoll
                            ) {
                                EmptyView()
                            }
                        }
                        
                    }
                  
                }
                     //.ignoresSafeArea(.keyboard, edges: .bottom)
                     .onTapGesture {
                         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                     }
                     .onAppear {
                         UIScrollView.appearance().bounces = false
                     }
                    if OtpLoader{
                        ZStack{
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
//                                GetLoction.toggle()
                            }
                        HStack{
                            LottieUIView(filename: "loader").frame(width: 50,height: 50)
                                .padding(.horizontal,20)
                            Text("Verifying...")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.vertical,20)
                                .padding(.trailing,20)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(20)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .toast(isPresented: $showToast, message: ShowToastMes.shared.tost)
    }
      
        if NotReg{
            NotRegister(Msg: $Msg,OtpView: $OtpView,NotReg: $NotReg)
        }
    }
    private func ShowAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert_Int = true
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
    private func Toast(mes:String){
        ShowToastMes.shared.tost = mes
        if (ShowToastMes.shared.tost != "" ){
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if (showToast == true){
                    ShowToastMes.shared.tost = ""
                }
            showToast = false
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
    @Binding var OtpView:Bool
    @Binding var NotReg:Bool
    var body: some View{
        NavigationView {
        VStack{
            LottieUIView(filename: "something_went_wrong").frame(width: 200,height: 200)
            
            Text(Msg)
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(15)
                .cornerRadius(5)
            
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                
                Text("Close")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
            }
            .frame(height: 40)
            .padding(.horizontal,30)
            
            .onTapGesture {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: NewMobileNoScrean())
                }
                
            }
        }
    }
        .navigationViewStyle(StackNavigationViewStyle())
       
        
    }
}

func OtpReSend(){
    let axn = "send/sms"
    let apiKey = "\(axn)&mobile=\(phoneNumber2)"
    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                }
            case .failure(let error):
                print(error)
            }
        }
}





@available(iOS 15.0, *)
struct NewOTPScrean:View{
    @State private var MobNo: String = ""
    @ObservedObject var monitor = Monitor()
    @State private var showAlert_Int = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var OtpLoader = false
    @State private var NavigteBoll = false
    @State private var OtpView:Bool = true
    @State private var showToast = false
    @State private var Msg = ""
    @State private var NotReg:Bool = false
    @Binding var jsondata: Outputdata
    let numberOffFields: Int
    @State private var Value = ""
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    @State var pinFive: String = ""
    @State var pinSix: String = ""
    @State private var showAlert = false
    @State private var alertMessages = ""
    @State private var remainingTime = 60
    @State private var showResendButton = false
    @State private var timer: Timer?
    @State private var EndMob:String = ""
    init(numberOffFields: Int, jsondata: Binding<Outputdata>) {
        self.numberOffFields = numberOffFields
        self._jsondata = jsondata
    }
    var body: some View{
        if OtpView{
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
                            Toast(mes: ShowToastMes.shared.tost)
                            EndMob = String(String(phoneNumber2).suffix(4))
                            startTimer()
                        }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 350)
                        VStack(alignment: .center){
                            VStack(spacing:0){
                                Image("OTPLogo")
                                //.fixedSize()
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180,height: 130)
                                
                                Text("Enter recevied 6 digit OTP on your")
                                    .font(.system(size: 12))
                                Text("Mobile number ending with ***\(EndMob)")
                                    .font(.system(size: 12))
                            }
                            VStack(alignment: .center){
                                OtpFormFieldView(pinOne: $pinOne, pinTwo: $pinTwo, pinThree: $pinThree, pinFour: $pinFour, pinFive: $pinFive, pinSix: $pinSix)
                                Button(action: {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    VerrifyOTP()
                                }){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(ColorData.shared.HeaderColor)
                                            .frame(height: 40)
                                            .cornerRadius(10)
                                        Text("Verify OTP")
                                            .fontWeight(.heavy)
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal,20)
                                } .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Error"),
                                        message: Text(alertMessages),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                                HStack(spacing: 0){
                                    Text("Dont receive the OTP?")
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                    Text("RESEND OTP")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                        .foregroundColor(showResendButton ? Color.blue : Color.gray)
                                        .onTapGesture {
                                            if monitor.status == .disconnected {
                                                ShowAlert(title: "Information", message: "Check the Internet Connection")
                                                return
                                            }
                                            startTimer()
                                            OtpReSend()
                                            showResendButton.toggle()
                                            Toast(mes:"OTP resend successfully")
                                        }
                                }
                                
                                HStack{
                                    Spacer()
                                    Text("Version \(Bundle.main.appVersionLong)")
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }.padding(.horizontal,20)
                                
                            }
                            if NavigteBoll {
                                NavigationLink(
                                    destination: HomePage(),isActive: $NavigteBoll
                                ) {
                                    EmptyView()
                                }
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
                if OtpLoader{
                    ZStack{
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                //                                GetLoction.toggle()
                            }
                        HStack{
                            LottieUIView(filename: "loader").frame(width: 50,height: 50)
                                .padding(.horizontal,20)
                            Text("Verifying...")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.vertical,20)
                                .padding(.trailing,20)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(20)
                    }
                }
            }  .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .toast(isPresented: $showToast, message: ShowToastMes.shared.tost)
    }
        if NotReg{
            NotRegister(Msg: $Msg,OtpView: $OtpView,NotReg: $NotReg)
        }
}
    private func ShowAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert_Int = true
    }
    func VerrifyOTP(){
        if monitor.status == .disconnected {
                        ShowAlert(title: "Information", message: "Check the Internet Connection")
                        return
                    }
        OtpLoader.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("JSON Data: \(jsondata.data)")
        let otpNumber = pinOne+pinTwo+pinThree+pinFour+pinFive+pinSix
        let otpInt=Int(otpNumber)
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
            let axn = "get/login"
            let apiKey: String = "\(axn)&device=iOS&version=Vi_\(Bundle.main.appVersionLong).\(Bundle.main.appBuild)"
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let aFormData: [[String: Any]] = [[
                "mobile":"\(phoneNumber2)",
                "deviceid":"\(deviceID)"
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
                                    if let results = jsonObject["msg"] as? String  {
                                        if results == "" {
                                            if let result = jsonObject["result"] as? [[String:Any]], let firstResult = result.first {
                                                print(firstResult)
                                                UserDefaults.standard.set(prettyPrintedJson, forKey: "CustDet")
                                                UserDefaults.standard.set(prettyPrintedJson, forKey: "savedPhoneNumber")
                                                let CusName = firstResult["CusName"] as? String ?? ""
                                                let StkID = firstResult["StkID"] as? String ?? ""
                                                let Addr = firstResult["Addr"] as? String ?? ""
                                                let StkMob = firstResult["StkMob"] as? String ?? ""
                                                let StkNm = firstResult["StkNm"] as? String ?? ""
                                                let StkAddr = firstResult["StkAddr"] as? String ?? ""
                                                let CusID = firstResult["CusID"] as? String ?? ""
                                                let ERP_Code = firstResult["ERP_Code"] as? String ?? ""
                                                let Mob = firstResult["Mob"] as? String ?? ""
                                                let Div = firstResult["Div"] as? Int ?? 0
                                                let Det:[String:Any] = ["CusName":CusName,"StkID":StkID,"Addr":Addr,"StkMob":StkMob,"StkNm":StkNm,"StkAddr":StkAddr,"CusID":CusID,"ERP_Code":ERP_Code,"Mob":Mob,"Div":Div];
                                                print(Det)
                                                CustDet.shared.CusId = CusID
                                                CustDet.shared.CusName = CusName
                                                CustDet.shared.StkID = StkID
                                                CustDet.shared.Addr = Addr
                                                CustDet.shared.StkMob = StkMob
                                                CustDet.shared.StkNm = StkNm
                                                CustDet.shared.StkAddr = StkAddr
                                                CustDet.shared.ERP_Code = ERP_Code
                                                CustDet.shared .Mob = Mob
                                                CustDet.shared.Div = Div
                                                CustDet.shared.Det = Det
                                            }
                                            SyncData.shared.SyncAllData{result in
                                                NavigteBoll = true
                                            }
                                        }else{
                                            OtpView.toggle()
                                            NotReg.toggle()
                                            print(results)
                                            Msg = results
                                        }
                                    }
                                }
                            } catch{
                                print("Error Data")
                            
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    OtpLoader.toggle()
                    alertMessages = error.localizedDescription
                    showAlert = true
                }
            }
        }else{
            Toast(mes: "Pls Enter Correct OTP")
        }
            OtpLoader.toggle()
        }
    }
    private func Toast(mes:String){
        
        ShowToastMes.shared.tost = mes
        if (ShowToastMes.shared.tost != "" ){
            showToast = true
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if (showToast == true){
                    ShowToastMes.shared.tost = ""
                }
            showToast = false
        }
    }
    }
    private func startTimer() {
        remainingTime = 5
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                showResendButton.toggle()
                timer?.invalidate()
                timer = nil
            }
        }
    }
    func OtpReSend(){
        let axn = "send/sms"
        let apiKey = "\(axn)&mobile=\(phoneNumber2)"
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
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
                        jsondata.data = json
                        print(prettyPrintedJson)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}


struct OtpModifer: ViewModifier {

    @Binding var pin : String

    var textLimt = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 35, height: 35)
            .background(Color.white.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}

@available(iOS 15.0, *)
struct OtpFormFieldView: View {
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
    }
    @FocusState private var pinFocusState : FocusPin?
    @Binding var pinOne: String
    @Binding var pinTwo: String
    @Binding var pinThree: String
    @Binding var pinFour: String
    @Binding var pinFive: String
    @Binding var pinSix: String

    var body: some View {
            VStack {
                HStack(spacing: 15) {
                    TextField("", text: $pinOne)
                        .modifier(OtpModifer(pin: $pinOne))
                        .onChange(of: pinOne) { newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinTwo
                            }
                        }
                        .focused($pinFocusState, equals: .pinOne)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                                )

                    TextField("", text: $pinTwo)
                        .modifier(OtpModifer(pin: $pinTwo))
                        .onChange(of: pinTwo) { newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinThree
                            } else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinOne
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinTwo)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                                )

                    TextField("", text: $pinThree)
                        .modifier(OtpModifer(pin: $pinThree))
                        .onChange(of: pinThree) { newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinFour
                            } else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinTwo
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinThree)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                                )

                    TextField("", text: $pinFour)
                        .modifier(OtpModifer(pin: $pinFour))
                        .onChange(of: pinFour) { newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinFive
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinThree
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinFour)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                                )
                    TextField("", text: $pinFive)
                        .modifier(OtpModifer(pin: $pinFive))
                        .onChange(of: pinFive) { newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinSix
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinFour
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinFive)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                                )
                    TextField("", text: $pinSix)
                        .modifier(OtpModifer(pin: $pinSix))
                        .onChange(of: pinSix) { newVal in
                            if (newVal.count == 0) {
                                pinFocusState = .pinFive
                            }
                        }
                        .focused($pinFocusState, equals: .pinSix)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.00), lineWidth: 1)
                             )
                }

                .padding(.vertical)
            }

    }
}
