//
//  Feedback.swift
//  Sales Order
//
//  Created by San eforce on 13/09/23.
//

import SwiftUI

struct Feedback: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var AddressTextInpute:String = ""
    @State private var isCheckedMarkYes = false
    @State private var isCheckedMarkNo = true
    @State private var Para:[String]=["1. Is the delivery of the material as per your order?","2. Is there any issue you would like to report?","3. is there any Material Damage / Expired?"]
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
                        Text("FEEDBACK / COMPLAINT FORM")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                        //.padding(.leading,8)
                        
                        
                        Spacer()
                    }
                    
                }
                .edgesIgnoringSafeArea(.top)
                VStack{
                ForEach(0..<3, id: \.self) { index in
                    VStack{
                        VStack{
                            HStack{
                                Text(Para[index])
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading,10)
                            
                            HStack{
                                HStack{
                                    Image(systemName: isCheckedMarkYes ? "checkmark.square.fill" : "square")
                                        .foregroundColor(isCheckedMarkYes ? .blue : .blue)
                                        .onTapGesture {
                                            isCheckedMarkYes.toggle()
                                            isCheckedMarkNo.toggle()
                                        }
                                    Text("Yes")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                }
                                HStack{
                                    Image(systemName: isCheckedMarkNo ? "checkmark.square.fill" : "square")
                                        .foregroundColor(isCheckedMarkNo ? .blue : .blue)
                                        .onTapGesture {
                                            isCheckedMarkYes.toggle()
                                            isCheckedMarkNo.toggle()
                                        }
                                    Text("No")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                            }
                            .padding(10)
                        }
                    }
                }
                HStack{
                    Text("4. For any other information/ to share Your feedback here")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                TextEditor(text: $AddressTextInpute)
                    .padding(10)
                    .frame(height:140)
                    .overlay(
                        Text("Tell something...")
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 4)
                            .opacity(AddressTextInpute.isEmpty ? 1 : 0)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ColorData.shared.HeaderColor, lineWidth: 1)
                            .padding(10)
                    )
                
                ZStack{
                    Rectangle()
                        .foregroundColor(ColorData.shared.HeaderColor)
                        .frame(height:40)
                        .cornerRadius(10)
                    VStack{
                        Text("SUBMIT")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                    }
                }
                .padding(10)
            }
                .padding(.top,-50)
                Spacer()
               
            }
        }
        .navigationBarHidden(true)
    }
}

