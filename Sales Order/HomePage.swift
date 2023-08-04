//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in // Using GeometryReader to calculate available height
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        Text("ReliVet Dashboard")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .offset(y: -230)
                        
                            .padding(.top, 40)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                            DashboardItem(imageName: "sbi-logo", title: "SBI")
                            NavigationLink(destination: NextScreen()) {
                                DashboardItem(imageName: "image2", title: "Item 2")
                            }
                            DashboardItem(imageName: "image3", title: "Item 3")
                            DashboardItem(imageName: "image4", title: "Item 4")
                            // Add more DashboardItem views with different images and titles as needed
                        }
                        .offset(y:-250)
                        .padding()
                        Spacer()
                    }
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
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct NextScreen: View {
    var body: some View {
        Text("Next Screen")
    }
}
