//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//



import SwiftUI

struct HomePage: View {
    @State private var currentDate = ""
    @State private var showAlert = false
    @State private var navigateToContentView = false
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
                                        UserDefaults.standard.removeObject(forKey: "savedPhoneNumber")
                                        
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
                                            navigateToContentView = true
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                Text("")
                            }
                            .padding(.top,50)
                            NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                                            EmptyView()
                                        }
                        }
                        
                    }
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                    
                    
                    .onAppear() {
                        updateDate()
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 4)
                     
                        VStack{
                            HStack{
                                Text("Hi! Kartik Test")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading,40)
                            .padding(7)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 12) {
                            NavigationLink(destination: Order()){
                                DashboardItem(imageName: "package", title: "Order")
                                
                            }
                            
                            // NavigationLink(destination: UpdateLocation()) {
                            NavigationLink(destination:MyOrdersScreen()){
                                DashboardItem(imageName: "features", title: "My Orders")
                            }
                            NavigationLink(destination:PaymentScreen()){
                                DashboardItem(imageName: "credit-card", title: "Payments")
                            }
                            DashboardItem(imageName: "business-report", title: "Reports")
                            DashboardItem(imageName: "resume", title: "My Profile")
                            DashboardItem(imageName: "feedback", title: "Complaints")
                        }
                    }
                    }
                    .padding(10)
                    .frame(height:200)
                    
                    
                    
                    
                    Spacer()
//                    SliderAd()
//                        .frame(height: 150)
//                        .foregroundColor(Color.blue)
//                        .offset()
                }
                //.frame(minHeight: geometry.size.height)
                
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
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
        Dashboard()
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
 
struct Dashboard: View{
    @State private var currentDate = ""
    var body: some View{
        NavigationView{
            ZStack{
                Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 80)
                        HStack{
                            Text("Dashboard")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                            Spacer()
                            HStack(spacing:30){
                                Text(currentDate)
                                    .padding(.top,50)
                                    .foregroundColor(.white)
                                Image("logout")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .padding(.top,50)
                            }
                        }
                        //.padding(10)
                    }
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
               
                //Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .shadow(radius: 5)
                    VStack{
                        HStack(spacing:50){
                            NavigationLink(destination: Order()){
                                DashboardItem(imageName: "package", title: "Order")
                                
                            }
                            
                            NavigationLink(destination:MyOrdersScreen()){
                                DashboardItem(imageName: "features", title: "My Orders")
                            }
                            NavigationLink(destination:PaymentScreen()){
                                DashboardItem(imageName: "credit-card", title: "Payments")
                            }
                        }
                        HStack(spacing:50){
                            DashboardItem(imageName: "business-report", title: "Reports")
                            DashboardItem(imageName: "resume", title: "My Profile")
                            DashboardItem(imageName: "feedback", title: "Complaints")
                        }
                    }
                }
                .padding(10)
                .frame(height:150)
                    Spacer()
            }
            }
        }
    }
    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = formatter.string(from: Date())
        Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { _ in
            currentDate = formatter.string(from: Date())
        }
    }
}

