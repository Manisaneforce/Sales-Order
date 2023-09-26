//
//  My Profile.swift
//  Sales Order
//
//  Created by San eforce on 13/09/23.
//

import SwiftUI

struct My_Profile: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var Addres:[String]=["Saidapet, Chennai - 600 017","Saidapet, Chennai - 600 017Saidapet, Chennai - 600 017"]
    var body: some View {
        NavigationView{
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
                HStack{
                    Image("Group 6")
                        .frame(width: 56, height: 56)
                        .shadow(color: Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.18), radius: 9, x: 0, y: 4)
                    VStack(alignment: .leading,spacing:7){
                        Text("Kartik Test")
                            .font(
                                Font.custom("Roboto", size: 14)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.2))
                        
                        Text("+91 93421 17731")
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
                        
                        Text("Nadanam, Chennai - 600 018")
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
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                ScrollView{
                ForEach(0..<2, id: \.self) { index in
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            //.frame( height: 46)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2).opacity(0.05))
                            .cornerRadius(4)
                        HStack{
                            Text(Addres[index])
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.2))
                                .padding(.leading,10)
                                .padding(.top,20)
                                .padding(.bottom,20)
                            Spacer()
                            Image("Group 2")
                                .frame(width: 12, height: 4)
                        }
                        .padding(.leading,10)
                        .padding(.trailing,30)
                    }
                    .padding(.leading,7)
                    .padding(.trailing,7)
                }
                    
                   
                        VStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 0.2)
                                .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                                .padding(8)
                            
                            HStack {
                                Image("Group7")
                                    .frame(width: 32, height: 32)
                                Text("About us")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                            .padding(.leading,10)
                            .padding(.trailing,20)
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 0.5)
                                .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                                .padding(8)
                            HStack {
                                Image("Group 8")
                                    .frame(width: 32, height: 32)
                                Text("Feedback")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                            .padding(.leading,10)
                            .padding(.trailing,20)
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 0.2)
                                .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                                .padding(8)
                            HStack {
                                Image("Group 9")
                                    .frame(width: 32, height: 32)
                                Text("Privacy Policy")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                            .padding(.leading,10)
                            .padding(.trailing,20)
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 0.5)
                                .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                                .padding(8)
                            HStack {
                                Image("Group 10")
                                    .frame(width: 32, height: 32)
                                Text("Refund Policy")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                
                                Spacer()
                                Image("back")
                                    
                            }
                            .padding(.leading,10)
                            .padding(.trailing,20)
                        }
            }
            Spacer()
        }
    }
        .navigationBarHidden(true)
    }
}

struct My_Profile_Previews: PreviewProvider {
    static var previews: some View {
        My_Profile()
    }
}
