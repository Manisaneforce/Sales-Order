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
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
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
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .offset(x: -20)
                    }
                }
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 )) // Adjust for safe area
                //.offset(y:-30)
                VStack(alignment: .leading, spacing: 10) {
                    Text("DR. INGOLE")
                        .font(.system(size: 15))
                    HStack {
                        Image("SubmittedCalls")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                        Text("9923125671")
                            .font(.system(size: 15))
                    }
                    Text("Shivaji Park, Dadar")
                        .font(.system(size: 15))
                    Text("ReliVet")
                        .font(.system(size: 15))
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
                .padding(.bottom, 20) // Adjust spacing
                
                List(0 ..< 5) { item in
                    HStack {
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 70)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("FIPOREL_ S DOG 0.67 ML")
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text("RLVT001")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("MRP ₹0")
                                Spacer()
                                Text("Price₹ 197.00")
                            }
                            HStack {
                                Text("Pipette")
                                Spacer()
                                HStack {
                                    Text("Order Qty :")
                                    Stepper("",
                                            onIncrement: {
                                                // Increment action
                                            },
                                            onDecrement: {
                                                // Decrement action
                                            })
                                }
                            }
                            HStack{
                                Text("Free : 0")
                                Spacer()
                                Text("₹0.00")
                            }
                            Divider()
                            HStack{
                                Text("tatal Qty: 0")
                                Spacer()
                                Text("₹0.00")
                            }
                        }
                    }
                    .padding(.vertical, 5) // Adjust spacing
                }
                .listStyle(PlainListStyle()) // Add list style
            }
            .padding(.top, 10) // Adjust top padding
            .navigationBarHidden(true)
        }
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
