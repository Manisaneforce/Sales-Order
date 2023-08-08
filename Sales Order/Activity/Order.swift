//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI

struct Order: View {
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(height: 100)
                    
                    HStack {
                        NavigationLink(destination: HomePage()) {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                        .offset(x: -120, y: 25)
                        
                        Text("Order")
                            .font(.system(size: 25))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .offset(x: -20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, -420)
                .edgesIgnoringSafeArea(.top)
                
                VStack{
                    
                    Text("DR. INGOLE")
                        .font(.system(size: 15))
                    //.padding(.top, -515)
                        .padding(.leading, -185)
                        .multilineTextAlignment(.leading)
                    HStack{
                        Image("SubmittedCalls")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                        //.renderingMode(.template)
                        //.foregroundColor(.white)
                            .padding(.leading, -180)
                        Text("9923125671")
                            .font(.system(size: 15))
                        //.padding(.top, -515)
                            .padding(.leading, -165)
                            .multilineTextAlignment(.leading)
                    }
                    Text("Shivaji Park, Dadar")
                        .font(.system(size: 15))
                    //.padding(.top, -515)
                        .padding(.leading, -185)
                        .multilineTextAlignment(.leading)
                    
                    Text("ReliVet")
                        .font(.system(size: 15))
                    //.padding(.top, -515)
                        .padding(.leading, -185)
                        .frame(alignment: .leading)
                        .foregroundColor(Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)))
                    
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            Text("Ectoparasiticidal")
                                .padding()
                            
                            Text("Dewormer")
                            Text("Health Supplement")
                            Text("Anti infective")
                            Text("Ectoparasiticidal")
                            
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .offset(y:-320)
                
                Spacer()
                VStack{
                HStack{
                    Image("logo_new")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 70)
                        .cornerRadius(4)
                    VStack(alignment: .leading,spacing: 5){
                        Text("FIPOREL_ S DOG 0.67 ML")
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        Text("RLVT001")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack{
                            Text("MRP ₹0")
                            
                            Text("Price₹ 197.00")
                            
                            
                        }
                        
                    }
                }
            }
                .offset(y:-480)
            }
            .padding(.top, 400)
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarHidden(true)
    }
}


struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}


