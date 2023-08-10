//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI

struct Order: View {
    @State private var number = 0
    @State private var inputNumberString = ""
    @State private var Arry = ["FIPOREL_ S DOG 0.67 ML","gjehfu","ndhbhbf","FIPOREL_ S DOG 0.67 ML"]
    @State private var nubers = [15,555,554,54]
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
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
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("Ectoparasiticidal")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .frame(height:25)
                                .cornerRadius(10)
                            
                            Text("Dewormer")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .frame(height:25)
                                .cornerRadius(10)
                            Text("Health Supplement")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .frame(height:25)
                                .cornerRadius(10)
                            Text("Anti infective")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .frame(height:25)
                                .cornerRadius(10)
                            Text("Ectoparasiticidal")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .frame(height:25)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
                NavigationView {
                List(0 ..< Arry.count, id: \.self) { index in
                    HStack {
                        Image("logo_new")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 70)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(Arry[index])
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text("RLVT001")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("MRP ₹\(nubers[index])")
                                Spacer()
                                Text("Price ₹197.00")
                            }
                            HStack {
                                NavigationLink(destination: ExtractedView()) {
                                   
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Text("Mani")
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 20)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray, lineWidth: 2)
                                            )
                                    }
                                }
                                
                                Spacer()
                                HStack {
                                    Button(action: {
                                        self.number -= 1
                                        
                                    }) {
                                        Text("-")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Text("\(number)")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                    Button(action: {
                                        self.number += 1
                                    }) {
                                        Text("+")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.trailing)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                                .foregroundColor(Color.blue)
                            }
                            
                            HStack {
                                Text("Free : 0")
                                Spacer()
                                Text("₹0.00")
                            }
                            Divider()
                            HStack {
                                Text("Total Qty: \(number)")
                                Spacer()
                                let totalvalue = nubers[0]
                                Text("₹\(totalvalue).00")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .background(Color.white)
                }
                .listStyle(PlainListStyle())
            }
                
            }
            .padding(.top, 10)
            .navigationBarHidden(true)
        }
        
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.trailing, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
    }
}


struct ExtractedView: View {
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
    var body: some View {
        
        ZStack{
            VStack{
                Text(selectedItem)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 15)
                    .background(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        isPopupVisible.toggle()
                    }
            }
            
            
            if isPopupVisible {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPopupVisible.toggle()
                    }
                VStack {
                    HStack {
                        Text("Select Item")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            isPopupVisible.toggle()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    SearchBar(text: $selectedItem) // Assuming you have a SearchBar view
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    VStack {
                        Button(action: {
                            selectedItem = "Pipette"
                            isPopupVisible.toggle()
                        }) {
                            VStack {
                                Text("Pipette")
                                Text("1x1=1")
                            }
                        }
                        Divider()
                        Button(action: {
                            selectedItem = "Box"
                            isPopupVisible.toggle()
                        }) {
                            VStack {
                                Text("Box")
                                Text("10x1=10")
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            }
        }
    
      
    }
}
