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
                        //Color(red: 0.58, green: 0.65, blue: 0.65)
                        //.foregroundColor(Color(red: 0.74, green: 0.76, blue: 0.78))
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
                            
                            Text(currentDate) // Display current date and time here
                                .font(.system(size: 15))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .offset(x: 30, y: 20)
                            
                            
                            VStack {
                                Button(action: {
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
                                        // Handle logout and navigation here
                                        // For example:
                                        // self.logout()
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
                    
                        NavigationLink(destination: NextScreen()) {
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
                    .frame(width: 380)
                    
                    Spacer() // This Spacer pushes the LazyVGrid to the bottom
                    
                    SliderAd()
                        .frame(height: 150)
                        .foregroundColor(Color.blue)
                        .offset()
                   // Spacer(minLength: 440)
                                    
                    
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
        
        // Update date every day
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
        // Replace this with your actual slider advertisement content
        Image("")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 360, height: 150)
           // .offset(y:-300)
            .padding(10)
            //.border(Color.gray, width: 2)
            .background(Color.white)
           // .background(Color(red: 0.87, green: 0.90, blue: 0.91, opacity: 1.00))
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
        //.border(Color.gray, width: 2)
        .background(Color.white)
       // .background(Color(red: 0.87, green: 0.90, blue: 0.91, opacity: 1.00))
        .cornerRadius(10)
    }
}
struct line : View{
    var body: some View{
        Text("Order")
        
    }
}

struct NextScreen: View {
    var body: some View {
        Text("My Orders")
    }
}
//@ViewBuilder
//func createVerticalSeparator() -> some View {
//    Rectangle()
//        .fill(Color.gray)
//        .frame(width: 1)
//        .opacity(0.5)
//}
//
//@ViewBuilder
//func createHorizontalSeparator() -> some View {
//    Rectangle()
//        .fill(Color.gray)
//        .frame(height: 1)
//        .opacity(0.5)
//}



