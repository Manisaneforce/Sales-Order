//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//



import SwiftUI
import Combine
import CoreLocation
import Alamofire

struct HomePage: View {
    @State private var currentDate = ""
    @State private var showAlert = false
    @State private var CustSAVEDet:String = UserDefaults.standard.string(forKey: "CustDet") ?? ""
    @State private var currentPage = 0
    @State private var showToast = false
    @State private var isPaymentenbl = 0
    @StateObject private var networkMonitor = NetworkMonitor.shared
    let imageUrls = [
         "https://rad.salesjump.in/server/rad/Banner%201.jpg",
         "https://rad.salesjump.in/server/rad/FiproRel-S%200.67%20mL%20Carton.png",
         "https://rad.salesjump.in/server/rad/FiproRel-S%201.34%20mL%20Carton.png",
         "https://rad.salesjump.in/server/rad/FiproRel-S%202.68%20mL%20Carton.png",
         "https://rad.salesjump.in/server/rad/FiproRel-S%204.02%20mL%20Carton.png"
     ]
    @State private var currentImageIndex = 0
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        NavigationView {
            
           // GeometryReader { geometry in
            ZStack{
                Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(){
                        isPaymentEnabled()
                    }
                VStack(spacing:22){
                
                    ZStack {
                               Rectangle()
                                    .foregroundColor(ColorData.shared.HeaderColor)
                                    .frame(height: 80)

                                if networkMonitor.isConnected {
                                    HStack {
                                        Text("Dashboard")
                                            .font(.custom("Poppins-Bold", size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.leading,10)
                                            .padding(.top, 50)
                                        Spacer()
                                        HStack(spacing: 30) {
                                            Text(currentDate)
                                                .font(.custom("Poppins-SemiBold", size: 15))
                                                .font(.headline)
                                                .foregroundColor(.white)

                                            VStack {
                                                Button(action: {
                                                    showAlert = true
                                                }) {
                                                    Image("logout")
                                                        .renderingMode(.template)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("Logout"),
                                                    message: Text("Do you want to log out?"),
                                                    primaryButton: .default(Text(" OK ")) {
                                                        // Handle logout action
                                                        UserDefaults.standard.removeObject(forKey: "savedPhoneNumber")
                                                        UserDefaults.standard.removeObject(forKey: "CustDet")

                                                        if let window = UIApplication.shared.windows.first {
                                                            window.rootViewController = UIHostingController(rootView: ContentView())
                                                        }
                                                    },
                                                    secondaryButton: .cancel()
                                                )
                                            }
                                        }
                                        .padding(.top, 50)
                                        .padding(.trailing, 16)
                                    }
                                } else {
                                    Internet_Connection()
                                }
                            }
                            .edgesIgnoringSafeArea(.top)
                            .frame(maxWidth: .infinity)
                            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
                            .onAppear {
                                networkMonitor.startMonitoring()
                            }
                            .onDisappear {
                                networkMonitor.stopMonitoring()
                            }
                    
                    
                    .onAppear() {
                        isPaymentEnabled()
                        if (ShowToastMes.shared.tost != "" ){
                            showToast = true
                          
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                if (showToast == true){
                                    ShowToastMes.shared.tost = ""
                                }
                            showToast = false
                        }
                            
                    }
                        
                        print(CustSAVEDet)
                        if let jsonData = CustSAVEDet.data(using: .utf8){
                            do{
                                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
                                    
                                    
                                    if let result = jsonObject["result"] as? [[String:Any]], let firstResult = result.first {
                                        print(firstResult)
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
                                        CustDet.shared.CusId = CusID!//Sf_Code
                                        CustDet.shared.CusName = CusName!
                                        CustDet.shared.StkID = StkID!
                                        CustDet.shared.Addr = Addr!
                                        CustDet.shared.StkMob = StkMob!
                                        CustDet.shared.StkNm = StkNm!
                                        CustDet.shared.StkAddr = StkAddr!
                                        CustDet.shared.ERP_Code = ERP_Code!
                                        CustDet.shared .Mob = Mob!
                                        CustDet.shared.Div = Div!
                
                                    }
                                    
                                    
                                }
                            } catch{
                                print("Error Data")
                            }
                        }
                        GetCurrentLoction()
                        updateDate()
                        DashBoradImg()
                        Prod_Sch_Det()
                        prod_Tax_Det()
                    }
                    VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 4)
                        
                        VStack{
                            HStack{
                                Text("Greetings Dr.\(CustDet.shared.CusName)")
                                    .font(.custom("Poppins-SemiBold", size: 15))
                                Spacer()
                            }
                            .padding(.leading,15)
                            .padding(7)
                            .onAppear{
                                
                            }
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 12) {
                                NavigationLink(destination: Order()){
                                    DashboardItem(imageName: "package", title: "New Order")
                                    
                                }
                                
                                // NavigationLink(destination: UpdateLocation()) {
                                NavigationLink(destination:MyOrdersScreen()){
                                    DashboardItem(imageName: "features", title: "My Orders")
                                }
                                
                                if (isPaymentenbl == 1){
                                    NavigationLink(destination:PaymentScreen()){
                                        DashboardItem(imageName: "credit-card", title: "Payment Ledger")
                                    }
                                }
                                NavigationLink(destination:MyOrdersDetails(OrderId: "Add data")){
                                    DashboardItem(imageName: "business-report", title: "Reports")
                                }
                                NavigationLink(destination:My_Profile()){
                                    DashboardItem(imageName: "resume", title: "My Profile")
                                }
                                NavigationLink(destination:ReachOut()){
                                    DashboardItem(imageName: "feedback", title: "Reach Out")
                                }
                            }
                        
                        }
                    }
                    .padding(10)
                    .frame(height: sizeClass == .compact ? 200 : 300)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 5)
                            Image(uiImage: loadImage())
                                            .resizable()
                                            .cornerRadius(10)
                        }
                        .padding(10)
                        .onAppear {
                                    //startTimer()
                                }
                        .frame(height: sizeClass == .compact ? 220 : 320)
                }
                    
                    Spacer()
                    VStack{
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width:150,height: 100)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .toast(isPresented: $showToast, message: ShowToastMes.shared.tost)
    }
    
    func startTimer() {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                withAnimation {
                    currentImageIndex = (currentImageIndex + 1) % imageUrls.count
                }
            }
        }
        
        func loadImage() -> UIImage {
            guard let url = URL(string: imageUrls[currentImageIndex]),
                  let data = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: data) else {
                return UIImage(systemName: "photo") ?? UIImage()
            }
            return uiImage
        }
    
    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = formatter.string(from: Date())
        Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { _ in
            currentDate = formatter.string(from: Date())
        }
    }
    func GetCurrentLoction(){
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            print(sLocation)
            lazy var geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                if(placemarks != nil){
//                    if(placemarks!.count>0){
//                        let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
//                        for i in 0...jAddress.count-1 {
//                            print(jAddress[i])
//                            if i==0{
//                                sAddress = String(format: "%@", jAddress[i])
//                            }else{
//                                sAddress = String(format: "%@, %@", sAddress,jAddress[i])
//                            }
//                        }
//                    }
//                }
//
//            }
        }, error:{ errMsg in
            print (errMsg)
            //self.LoadingDismiss()
        })
    }
    
    func isPaymentEnabled(){
        let axn = "enable_payments"
        let apiKey = "\(axn)&divisionCode=\(CustDet.shared.Div)&id=\(CustDet.shared.CusId)"
        
        AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil)
            .validate(statusCode: 200 ..< 299)
            .responseJSON { response in
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
                        var lstisPaymentEnabled:[String:AnyObject] = [:]
                        if let list = GlobalFunc.convertToDictionary(text: prettyPrintedJson) as? [String:AnyObject] {
                            lstisPaymentEnabled = list;
                            
                        }
                        print(lstisPaymentEnabled)
                        isPaymentenbl = paymentenb.shared.isPaymentenbl
                        paymentenb.shared.isPaymentenbl = lstisPaymentEnabled["isPaymentEnabled"] as? Int ?? 0

                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

struct SliderAd: View {
    var body: some View {
        Image("")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 360, height: 150)
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
    }
}

struct DashboardItem: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text(title)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct NextScreen: View {
    var body: some View {
        Text("My Orders")
    }
}

func DashBoradImg(){
    let axn = "get_ad_images"
    
    let apiKey: String = "\(axn)"
    
    AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .post, parameters: nil, encoding: URLEncoding(), headers: nil).validate(statusCode: 200 ..< 299).responseJSON { response in
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
                DashboardBaner.shared.ImgUrl.removeAll()
                if let data = prettyPrintedJson.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let response = json["response"] as? [[String: Any]] {
                                print(response)
                                for item in response{
                                    let url = item["url"] as? String
                                    let modifiedUrlString = url!.replacingOccurrences(of: " ", with: "%20")
                                    
                                    DashboardBaner.shared.ImgUrl.append(modifiedUrlString)
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                } else {
                    print("Invalid JSON string")
                }
                print(DashboardBaner.shared.ImgUrl)
            }
        case .failure(let error):
            print(error)
        }
    }
}

// SwipGestore
//https://chat.openai.com/c/4ca48131-f3e9-4e77-b1c0-27c233b20df6

