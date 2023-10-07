//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//



import SwiftUI
import Combine
import CoreLocation

struct HomePage: View {
    @State private var currentDate = ""
    @State private var showAlert = false
    @State private var CustSAVEDet:String = UserDefaults.standard.string(forKey: "CustDet") ?? ""
  
    var body: some View {
        NavigationView {
           // GeometryReader { geometry in
            ZStack{
                Color(red: 0.87, green: 0.90, blue: 0.91)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing:22){
                    
                    ZStack(){
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 80)
                        
                        HStack() {
                            Text(" ")
                            Text("Dashboard")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                            
                            Spacer()
                            HStack(spacing:30){
                                Text(currentDate)
                                    .font(.system(size: 15))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                //.offset(x: 30, y: 20)
                                
                                
                                VStack {
                                    Button(action: {
                                        
                                        
                                        showAlert = true
                                    }) {
                                        Image("logout")
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                    }
                                    //.offset(x: 55, y: 20)
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Logout"),
                                        message: Text("Do you want to log out?"),
                                        primaryButton: .default(Text("OK")) {
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
                            .padding(.top,50)
                            .padding(.trailing,16)
                        }
                        
                    }
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                    
                    
                    .onAppear() {
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
                                        
                                        
                                    }
                                    
                                    
                                }
                            } catch{
                                print("Error Data")
                            }
                        }
                        GetCurrentLoction()
                        updateDate()
                    }
                    VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 4)
                        
                        VStack{
                            HStack{
                                Text("Greetings \(CustDet.shared.CusName)")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
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
                                NavigationLink(destination:PaymentScreen()){
                                    DashboardItem(imageName: "credit-card", title: "Payment Ledger")
                                }
                                NavigationLink(destination:MyOrdersDetails(OrderId: "Add data")){
                                    DashboardItem(imageName: "business-report", title: "Reports")
                                }
                                NavigationLink(destination:My_Profile()){
                                    DashboardItem(imageName: "resume", title: "My Profile")
                                }
                                NavigationLink(destination:Feedback()){
                                    DashboardItem(imageName: "feedback", title: "Reach Out")
                                }
                            }
                        
                        }
                    }
                    .padding(10)
                    .frame(height:200)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 4)
                            VStack{
                                Image("Banner 1")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .padding(.vertical,2)
                            }
                            
                        }
                        .padding(10)
                        .frame(height:220)
                }
                    
                    
                    
                    
                    Spacer()
                    VStack{
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width:150,height: 100)
                            .background(Color(red: 0.87, green: 0.90, blue: 0.91))
                    }
                }
                
                
            }
        }
        .navigationBarHidden(true)
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
            var sAddress: String = ""
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
                //.font(.callout)
                .font(.system(size: 12))
                //.fontWeight(.semibold)
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
 
