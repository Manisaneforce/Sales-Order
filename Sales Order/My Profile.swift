//
//  My Profile.swift
//  Sales Order
//
//  Created by San eforce on 13/09/23.
//

import SwiftUI
import Alamofire
import Combine
import CoreLocation
struct AddAddress : Any{
    let listedDrCode:String
    let address : String
    let id : Int
    let stateCode: Int
    
}
struct ListState:Any{
    let id:String
    let title:String
}
struct My_Profile: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var Addres:[String]=["Saidapet, Chennai - 600 017","Saidapet, Chennai - 600 017Saidapet, Chennai - 600 017"]
    @State private var RetAddressData:[AddAddress] = []
    @State private var List_State:[ListState]=[]
    @State private var AddresHed = ""
    @State private var AddNewAddres:Bool = false
    @State private var SelectSatae:Bool = false
    @State private var GetLoction:Bool = false
    @State private var actionButton:Bool = false
    @State private var AddressTextInpute:String = ""
    @State private var selectedstateText:String = "Select State"
    @State private var OpenMod:String = ""
    @State private var Editid:Int = 0
    @State private var listedDrCode = ""
    @State private var ClickIndex = Int()
    @State private var ShowTost = ""
    @State private var ontap_Educational_Details:Bool = false
    @State private var Ontap_Registration_certificate:Bool = false
    var body: some View {
        NavigationView{
            ZStack{
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(ColorData.shared.HeaderColor)
                        .frame(height: 80)
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                .frame(width: 50)
                            
                        }
                        Text("MY PROFILE")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                        
                        Spacer()
                    }
                    
                }
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.leading)
                .edgesIgnoringSafeArea(.trailing)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                ScrollView{
                    HStack{
                        Image("Group 6")
                            .frame(width: 56, height: 56)
                            .shadow(color: Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.18), radius: 9, x: 0, y: 4)
                        VStack(alignment: .leading,spacing:7){
                            Text(CustDet.shared.CusName)
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.2))
                            
                            Text("+91 \(CustDet.shared.Mob)")
                                .font(
                                    Font.custom("Roboto", size: 12)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.1, green: 0.59, blue: 0.81))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    .padding(10)
                    HStack{
                        VStack(alignment: .leading,spacing:10){
                            Text("Primary Address")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.2))
                            
                            Text(CustDet.shared.Addr)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                        }
                        Spacer()
                    }
                    .padding(.leading,10)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 0.5)
                        .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                    
                        .padding(10)
                    HStack{
                        Text("Billing & Shipping Address")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        Spacer()
                        Text("Add")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.1, green: 0.59, blue: 0.81))
                            .onTapGesture {
                                OpenMod = "Add"
                                AddresHed = "Add New Address"
                                AddressTextInpute=""
                                AddNewAddres.toggle()
                            }
                    }
                    .padding(.leading,10)
                    .padding(.trailing,25)
                    .onAppear{RetAddress()}
                    
                    ForEach(0..<RetAddressData.count, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                            //.frame( height: 46)
                                .background(Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05))
                                .cornerRadius(4)
                            HStack{
                                Text(RetAddressData[index].address)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.2))
                                    .padding(.leading,10)
                                    .padding(.top,20)
                                    .padding(.bottom,20)
                                Spacer()
                                Button(action:{
                                    ClickIndex = index
                                    Editid = RetAddressData[index].id
                                    AddressTextInpute = RetAddressData[index].address
                                    listedDrCode = RetAddressData[index].listedDrCode
                                    actionButton.toggle()
                                } )
                                {
                                    Image("Group 2")
                                        //.resizable()
                                        .frame(width: 30, height: 40)
                                        //.background(Color.red)
                                }
//
                            }
                            .padding(.leading,10)
                            .padding(.trailing,30)
                        }
                        .padding(.leading,7)
                        .padding(.trailing,7)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    VStack{
                        HStack{
                            Image("documents")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Text("My documents")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                            Image("back")
                            
                        }
                        .padding(.horizontal,20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                        VStack{
                            Button(action: {
                                ontap_Educational_Details.toggle()
                            })
                            {
                            HStack{
                                ZStack{
                                    //                                Rectangle()
                                    //                                  .foregroundColor(.clear)
                                    //                                  .frame(width: 32, height: 32)
                                    //                                  .background(Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.1))
                                    //                                  .cornerRadius(4)
                                    HStack{
                                        Image("Educational Details")
                                            .resizable()
                                            .frame(width: 22,height: 22)
                                            .foregroundColor(.black)
                                        Text("Educational Details")
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                    }
                                    
                                }
                                Spacer()
                                if (ontap_Educational_Details == true) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                   } else {
                                       Image("back")
                                   }
                                
                            }
                        }
                            if ontap_Educational_Details{
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05))
                                    .cornerRadius(4)
                                VStack(spacing: 10){
                                    HStack{
                                        Text("UG Degree certificate")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("PG Degree certificate")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal,10)
                                .padding(.vertical,15)
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,5)
                        }
                        }
                        
                        .padding(.horizontal,20)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                        VStack{
                            Button(action: {
                                Ontap_Registration_certificate.toggle()
                            })
                            {
                                HStack{
                                    Image("Registration certificate")
                                        .resizable()
                                        .frame(width: 20,height: 20)
                                    Text("Valid Registration certificate")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Spacer()
                                    if (Ontap_Registration_certificate == true) {
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.black)
                                       } else {
                                           Image("back")
                                       }
                                }
                                .padding(.horizontal,20)
                            }
                            if Ontap_Registration_certificate{
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05))
                                    .cornerRadius(4)
                                VStack(spacing: 10){
                                    HStack{
                                        Text("State Veterinary Council")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("Veterinary Council of India (VCI)")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal,10)
                                .padding(.vertical,15)
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,5)
                        }
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                        
                        HStack{
                            Image("PAN card")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Text("PAN card")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                            Image("back")
                            
                        }
                        .padding(.horizontal,20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                        HStack{
                            Image("GST Number & Documen")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Text("GST Number & Document")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                            Image("back")
                            
                        }
                        .padding(.horizontal,20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                        
                    
                    }
                    VStack{
                        HStack{
                            Image("Drug License:s copies or self-declaratio")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Text("Drug License/s copies or self-declaration")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                            Image("back")

                        }
                        .padding(.horizontal,20)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(10)
                    }
                }
              
                Spacer()
            }
                if AddNewAddres{
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            AddNewAddres.toggle()
                        }
                    VStack{
                        HStack {
                            Text(AddresHed)
                                .font(.headline)
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .padding(.top, 10)
                            
                            Spacer()
                            
                            Button(action: {
                                AddNewAddres.toggle()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        Divider()
                        HStack{
                            Text("State")
                                .padding(.leading,25)
                            Spacer()
                        }
                        HStack(spacing: 180){
                            Text(selectedstateText)
                                .font(.system(size: 15))
                                .frame(width: 100)
                                .padding(.leading,10)
                            
                            
                            
                            Image(systemName: "chevron.down")
                                .padding(.trailing,5)
                        }
                        .frame(height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ColorData.shared.HeaderColor,lineWidth: 2)
                        )
                        .onTapGesture {
                            SelectSatae.toggle()
                            
                            let axn = "get_states"
                          
                            let apiKey = "\(axn)"
                            
                            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
                                .validate(statusCode: 200 ..< 299)
                                .responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        print(value)
                                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                                            print("Error: Cannot convert JSON object to Pretty JSON data")
                                            return
                                        }
                                        guard let prettyPrintedJsons = String(data: prettyJsonData, encoding: .utf8) else {
                                            print("Error: Could print JSON in String")
                                            return
                                        }
                                        print(prettyPrintedJsons)
                                        
                                        // Assuming prettyPrintedJsons is a JSON string
                                        if let jsonData = prettyPrintedJsons.data(using: .utf8),
                                           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                           let responseArray = json["response"] as? [[String: Any]] {
                                            for stateItem in responseArray {
                                                if let id = stateItem["id"] as? String, let title = stateItem["title"] as? String {
                                                    
                                                    List_State.append(ListState(id: id, title: title))
                                                }
                                            }
                                        }
                                      
                                        if let json = value as? [AnyObject] {
                                            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                                                print("Error: Cannot convert JSON object to Pretty JSON data")
                                                return
                                            }
                                            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                                print("Error: Could print JSON in String")
                                                return
                                            }
                                            
                                            print(prettyPrintedJson)
                                            
                                            
                                            print("______________________prodGroup_______________")
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                        }
                        
                        HStack{
                            Text("Full Address")
                                .padding(.leading,25)
                            Spacer()
                        }
                        HStack(spacing:180){
                            //TextField("Enter full address with pincode",text: $AddressTextInpute)
                            TextEditor(text: $AddressTextInpute)
                            
                                .frame(width: 310,height: 100)
                            // .padding()
                                .overlay(
                                    Text("Enter full address with pincode")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 4)
                                        .opacity(AddressTextInpute.isEmpty ? 1 : 0)
                                )
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ColorData.shared.HeaderColor,lineWidth: 2)
                        )
                        
                        
                        HStack{
                            Spacer()
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(Color.blue)
                            Text("Use my current location")
                                .font(.system(size: 17))
                                .foregroundColor(Color.blue)
                            Spacer()
                        }
                        .onTapGesture {
                            AddressTextInpute.removeAll()
                            GetCurrentLoction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                GetLoction.toggle()
                                print(AddressTextInpute)
                            }
                            GetLoction.toggle()
                        }
                        .frame(height: 40)
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .frame(height: 50)
                            VStack{
                                
                                Text("Submit")
                                    .foregroundColor(Color.white)
                                
                            }
                        }
                        .onTapGesture {
                            if OpenMod == "Add"{
                                if let encodedAddress = AddressTextInpute.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL+"insert_ret_address"+"&listedDrCode=\(CustDet.shared.CusId)"+"&address=\(encodedAddress)", method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON {
                                    AFdata in
                                    switch AFdata.result
                                    {
                                        
                                    case .success(let value):
                                        print(value)
                                        if let json = value as? [String: Any] {
                                            
                                            print(json)
                                            RetAddress()
                                            AddNewAddres.toggle()
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                            
                                        }
                                        
                                    case .failure(let error):
                                        
                                        let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                            return
                                        })
                                        
                                    }
                                }
                            }
                        }
                            if OpenMod == "Edit"{
                                if let encodedAddress = AddressTextInpute.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                    let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "update_ret_address" + "&id=\(Editid)" + "&listedDrCode=\(CustDet.shared.CusId)" + "&address=\(encodedAddress)"

                                    AF.request(urlString, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
                                        switch AFdata.result {
                                        case .success(let value):
                                            print(value)
                                            if let json = value as? [String: Any] {
                                                print(json)
                                                RetAddress()
                                                AddNewAddres.toggle()
                                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                            }

                                        case .failure(let error):
                                            let alert = UIAlertController(title: "Information", message: error.errorDescription, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { _ in
                                                return
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                if SelectSatae{
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            SelectSatae.toggle()
                        }
                    VStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .frame(height: 40)
                            Text("")
                            Text("Select State")
                                .foregroundColor(Color.white)
                        }
                        
                        Divider()
                        List(0..<List_State.count,id: \.self){index in
                            Button(action:{
                                selectedstateText = List_State[index].title
                                SelectSatae.toggle()
                            })
                            {
                                Text(List_State[index].title)
                            }
                           
                        }
                        .listStyle(PlainListStyle())
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(ColorData.shared.HeaderColor)
                                .frame(height: 60)
                          
                                Text("Close")
                                    .foregroundColor(Color.white)
                                    
                            
                        }
                        .onTapGesture {
                            SelectSatae.toggle()
                            
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                if GetLoction{
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            GetLoction.toggle()
                        }
                    VStack{
                        LottieUIView(filename: "Gettingloction").frame(width: 220,height: 150)
                        Text("Getting Current Loction...")
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                    
                }
                if actionButton{
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            actionButton.toggle()
                        }
                    VStack{
                        Text("Select an Action")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .padding(.top,25)
                            .padding(.bottom,25)
                            .padding(.leading,10)
                        
                        HStack{
                            Text("Edit")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .padding(15)
                            Spacer()
                        }
                        .onTapGesture {
                            AddresHed = "Edit Address"
                            OpenMod = "Edit"
                            actionButton.toggle()
                            AddNewAddres.toggle()
                            
                        }
                        HStack{
                            Text("Delete")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .padding(15)
                            Spacer()

                        }
                        .onTapGesture {
                            
                            let axn = "delete_ret_address&id=\(Editid)&listedDrCode=\(listedDrCode)"
                          //http://rad.salesjump.in/server/Db_Retail_v100.php?axn=delete_ret_address&id=58&listedDrCode=96
                            let apiKey = "\(axn)"
                            
                            AF.request(APIClient.shared.BaseURL+APIClient.shared.DBURL + apiKey, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
                                .validate(statusCode: 200 ..< 299)
                                .responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        print(value)
                             
                                        if let json = value as? [String:AnyObject] {
                                            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                                                print("Error: Cannot convert JSON object to Pretty JSON data")
                                                return
                                            }
                                            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                                print("Error: Could print JSON in String")
                                                return
                                            }
                                            deleteItem()
                                            print(prettyPrintedJson)
                                
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            actionButton.toggle()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
        }
    }
        .navigationBarHidden(true)
    }
    private func RetAddress(){
        let axn = "get_ret_addresses&listedDrCode=\(CustDet.shared.CusId)"
        let apiKey = "\(axn)"

       
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
                        RetAddressData.removeAll()
                        if let jsonData = prettyPrintedJson.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let responseArray = json["response"] as? [[String: Any]] {
                            print(responseArray)
                            for AddressItem in responseArray {
                                if let ListedDrCode = AddressItem["ListedDrCode"] as? String, let Address = AddressItem["Address"] as? String, let ID = AddressItem["id"] as? Int, let stateCode = AddressItem["State_Code"] as? Int {
                                    RetAddressData.append(AddAddress(listedDrCode: ListedDrCode, address: Address, id: ID, stateCode: stateCode))
                                   
                                }
                            }
                        }
                        
                       
            
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    private func GetCurrentLoction(){
       
        LocationService.sharedInstance.getNewLocation(location: { location in
            let sLocation: String = location.coordinate.latitude.description + ":" + location.coordinate.longitude.description
            lazy var geocoder = CLGeocoder()
            var sAddress: String = ""
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if(placemarks != nil){
                    if(placemarks!.count>0){
                        let jAddress:[String] = placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String]
                        for i in 0...jAddress.count-1 {
                            print(jAddress[i])
                            if i==0{
                                sAddress = String(format: "%@", jAddress[i])
                            }else{
                                sAddress = String(format: "%@, %@", sAddress,jAddress[i])
                            }
                        }
                    }
                }
                AddressTextInpute = sAddress
                print(sAddress)
            }
        }, error:{ errMsg in
            print (errMsg)
        })
    }
    private func deleteItem(){
        RetAddressData.remove(at: ClickIndex )
    }
}

struct My_Profile_Previews: PreviewProvider {
    static var previews: some View {
        My_Profile()
    }
}


