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
    @State private var OtpView:Bool = true
    @State private var NotReg:Bool = false
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
                ScrollView(showsIndicators: false){
                ZStack {
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
                            
                            Text("+91\(phoneNumber2)")
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
                                                                
                                                                
                                                                if let results = jsonObject["msg"] as? String  {
                                                                    
                                                                    
                                                                    if results == "" {
                                                                        if let result = jsonObject["result"] as? [[String:Any]], let firstResult = result.first {
                                                                            print(firstResult)
                                                                            UserDefaults.standard.set(prettyPrintedJson, forKey: "CustDet")
                                                                            UserDefaults.standard.set(prettyPrintedJson, forKey: "savedPhoneNumber")
                                                                            let CusName = firstResult["CusName"] as? String
                                                                            let StkID = firstResult["StkID"] as? String
                                                                            let Addr = firstResult["Addr"] as? String
                                                                            let StkMob = firstResult["StkMob"] as? String
                                                                            let StkNm = firstResult["StkNm"] as? String
                                                                            let StkAddr = firstResult["StkAddr"] as? String
                                                                            let CusID = firstResult["CusID"] as? String
                                                                            let ERP_Code = firstResult["ERP_Code"] as? String
                                                                            let Mob = firstResult["Mob"] as? String
                                                                            let Div = firstResult["Div"] as? Int
                                                                            let Det:[String:Any] = ["CusName":CusName!,"StkID":StkID!,"Addr":Addr!,"StkMob":StkMob!,"StkNm":StkNm!,"StkAddr":StkAddr!,"CusID":CusID!,"ERP_Code":ERP_Code!,"Mob":Mob!,"Div":Div!];
                                                                            print(Det)
                                                                            CustDet.shared.CusId = CusID!
                                                                            CustDet.shared.CusName = CusName!
                                                                            CustDet.shared.StkID = StkID!
                                                                            CustDet.shared.Addr = Addr!
                                                                            CustDet.shared.StkMob = StkMob!
                                                                            CustDet.shared.StkNm = StkNm!
                                                                            CustDet.shared.StkAddr = StkAddr!
                                                                            CustDet.shared.ERP_Code = ERP_Code!
                                                                            CustDet.shared .Mob = Mob!
                                                                            CustDet.shared.Div = Div!
                                                                            CustDet.shared.Det = Det
                                                                            print(CustDet.shared.CusName)
                                                                            print(CustDet.shared.Det)
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
                                            }
                                        }
                                        
                                    }else{
                                       
                                        Toast(mes: "Pls Enter Correct OTP")
                                      
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
                                }
                           
                            
                            if showResendButton {
                                Button(action: {
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
            }
               // .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
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
                    window.rootViewController = UIHostingController(rootView: ContentView())
                }
                
            }
        }
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
       
        
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

