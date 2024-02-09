//
//  loader.swift
//  Sales Order
//
//  Created by San eforce on 09/02/24.
//

import Foundation
import SwiftUI
struct loader:View{
    var body: some View{
        ZStack{
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
//                                GetLoction.toggle()
            }
        HStack{
            LottieUIView(filename: "loader").frame(width: 50,height: 50)
                .padding(.horizontal,20)
            Text("Loading ...")
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
