//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//



import SwiftUI

struct HomePage: View {
    var body: some View {
        
        NavigationView {
           
            GeometryReader { geometry in // Using GeometryReader to calculate available height
              // Color = #dfe6e9
                Color(red: 0.87, green: 0.90, blue: 0.91, opacity: 1.00)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 20) {
                        

                        Text("ReliVet Dashboard")
                            .font(.system(size: 25))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(-1)
                            .padding([.top, .leading, .bottom])
                            .cornerRadius(10)
                            .offset(x: -65,y: -40)
                        
                            .padding(.top)
                        Spacer(minLength: 0)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 20) {
                            DashboardItem(imageName: "order", title: "Order")
                            NavigationLink(destination: NextScreen()) {
                                DashboardItem(imageName: "Myorder", title: "My Orders")
                            }
                            
                            DashboardItem(imageName: "order", title: "Payments")
                            Rectangle()
                                   .fill(Color.gray) // Customize the line color as you like
                                   .frame(height: 1)
                                   .padding(.horizontal)
                                   .opacity(0.5)
                            Rectangle()
                                   .fill(Color.gray) // Customize the line color as you like
                                   .frame(height: 1)
                                   .padding(.horizontal)
                                   .opacity(0.5)
                            Rectangle()
                                   .fill(Color.gray) // Customize the line color as you like
                                   .frame(height: 1)
                                   .padding(.horizontal)
                                   .opacity(0.5)
                            DashboardItem(imageName: "Reports", title: "Reports")
                            DashboardItem(imageName: "Shop", title: "My Profile")
                            DashboardItem(imageName: "order", title: "Add")
                            Rectangle()
                                   .fill(Color.gray) // Customize the line color as you like
                                   .frame(height: 1)
                                   .padding(.horizontal)
                                   .opacity(0.5)
                        }
                        .offset(x:2)
                        .padding()
                        //.border(Color.gray, width: 2)
                        .background(Color.white)
                        .cornerRadius(15)
                        .frame(width: 370,height: -500)
                        Spacer(minLength:580)
                    }
                    .offset(x:-2.2)
                    .frame(width: 400)
                    
                    .frame(minHeight: geometry.size.height) // Set minimum height to prevent scrolling when content is small
                }
               
            }
        }
        .navigationBarHidden(true)
    }
       
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
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
