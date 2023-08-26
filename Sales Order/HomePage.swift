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
            GeometryReader { geometry in
                Color(red: 0.87, green: 0.90, blue: 0.91)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: -50) { 
                    
                    ZStack(){
                        Rectangle()
                            .foregroundColor(Color.blue)
                            .frame(height: 100)
                        
                        HStack() {
                            Text("Dashboard")
                                .font(.system(size: 25))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding([.top, .leading, .bottom])
                                .cornerRadius(10)
                                .offset(x: -70, y: 20)
                            
                            Text(currentDate)
                                .font(.system(size: 15))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .offset(x: 30, y: 20)
                            
                            
                            VStack {
                                Button(action: {
                                    UserDefaults.standard.removeObject(forKey: "savedPhoneNumber")
                                    
                                    showAlert = true
                                }) {
                                    Image("logout")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                }
                                .offset(x: 55, y: 20)
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
                            NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                                            EmptyView()
                                        }
                        }
                    }
                    .onAppear() {
                        updateDate()
                    }
                    .offset( y: -75)
                    .padding(.top)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                        NavigationLink(destination: Order()){
                            DashboardItem(imageName: "order", title: "Order")
                            
                        }
                    
                        NavigationLink(destination: UpdateLocation()) {
                            DashboardItem(imageName: "Myorder", title: "My Orders")
                        }
                        
                        DashboardItem(imageName: "order", title: "Payments")
                        DashboardItem(imageName: "Reports", title: "Reports")
                        DashboardItem(imageName: "Shop", title: "My Profile")
                        DashboardItem(imageName: "order", title: "Add")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .frame(width: .infinity)
                    .frame(width: 380)
                    
                    Spacer()
                    SliderAd()
                        .frame(height: 150)
                        .foregroundColor(Color.blue)
                        .offset()
                }
                .frame(minHeight: geometry.size.height)
                
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
                .font(.callout)
                .font(.system(size: 14))
                .fontWeight(.semibold)
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
 
