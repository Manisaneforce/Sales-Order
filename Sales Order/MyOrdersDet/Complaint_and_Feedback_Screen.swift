//
//  Complaint_and_Feedback_Screen.swift
//  Sales Order
//
//  Created by San eforce on 08/09/23.
//

import SwiftUI

struct Complaint_and_Feedback_Screen: View {
    @State private var isChecked = false
    @State private var NoCheckeMark = false
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle()
                Color(red: 0.93, green: 0.94, blue: 0.95,opacity: 1.00)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color(red: 0.10, green: 0.59, blue: 0.81, opacity: 1.00))
                            .frame(height: 80)
                        
                        HStack {
                            
                            Button(action: {
                                
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
                            Spacer()
                        }
                        
                        
                    }
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                    
                    VStack{
                        VStack(spacing:10){
                            HStack{
                                Text("1. is the delivery of the material as per your order?")
                                    .font(.system(size: 13))
                                Spacer()
                            }
                            HStack{
                                HStack{
                                    Image(systemName: isChecked ? "square" : "checkmark.square.fill")
                                        .foregroundColor(isChecked ? .blue : .blue)
                                        .onTapGesture {
                                            isChecked.toggle()
                                        }
                                    Text("Yes")
                                }
                                HStack{
                                    Image(systemName: NoCheckeMark ? "square" : "checkmark.square.fill")
                                        .foregroundColor(NoCheckeMark ? .blue : .blue)
                                        .onTapGesture {
                                            NoCheckeMark.toggle()
                                        }
                                    Text("NO")
                                }
                                Spacer()
                            }
                            .padding(10)
                        }
                        .padding(10)
                    }
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Complaint_and_Feedback_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Complaint_and_Feedback_Screen()
    }
}
