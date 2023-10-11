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
    @State private var isCheckedMarks: [Bool] = [false, false, false]
    @State private var scrollOffset: CGFloat = 0.0
    @State private var Para:[String]=["1. How satisfied are you with the ReliVet App?","2. Is there any issue you would like to report?","3. is there any Material Damage / Expired?"]
    @Binding var FeedbackSc:Bool
    @Binding var CurrentSc:Bool

    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(ColorData.shared.HeaderColor)
                        .frame(height: 80)
                    HStack {
                        Button(action: {
                            FeedbackSc.toggle()
                            CurrentSc.toggle()
                        }) {
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
                ScrollView(showsIndicators: false){
                    ForEach(0..<3, id: \.self) { index in
                        ZStack{
                            
                            GeometryReader { proxy in
                                            Color.clear
                                                .preference(
                                                    key: ViewOffsetKey.self,
                                                    value: proxy.frame(in: .global).minY
                                                )
                                                 
                                        }
                                    .onPreferenceChange(ViewOffsetKey.self) { value in
                                        self.scrollOffset = value
                                        print(scrollOffset)
                                        
                                    }
                                    
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
                                        Image(systemName: isCheckedMarks[index] ? "checkmark.square.fill" : "square")
                                            .foregroundColor(isCheckedMarks[index] ? .blue : .blue)
                                            .onTapGesture {
                                                isCheckedMarks[index].toggle()
                                            }
                                        Text("Yes")
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                    }
                                    HStack{
                                        Image(systemName: isCheckedMarks[index] ? "square" : "checkmark.square.fill")
                                            .foregroundColor(isCheckedMarks[index] ? .blue : .blue)
                                            .onTapGesture {
                                                isCheckedMarks[index].toggle()
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
              

                
                Button(action: {
                    // Add your submit action here
                }) {
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
                        .onTapGesture {
                           
                        }
                    }
                    .padding(10)
                }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
              
                
                Spacer()
            }
           
        }
        .navigationBarHidden(true)
    }
}
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct ReachOut:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var FeedbackSc:Bool = false
    @State private var CurrentSc:Bool = true
    var body: some View{
        if CurrentSc{
        NavigationView{
            ZStack{
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 80)
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("backsmall")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .padding(.top,50)
                                    .frame(width: 50)
                            }
                            Text("Reach Out")
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
                    VStack {
                        //                    Rectangle()
                        //                        .foregroundColor(.clear)
                        //                        .frame(height: 0.3)
                        //                        .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                        //                        .padding(8)
                        
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
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                        Button(action:{
                            FeedbackSc.toggle()
                            CurrentSc.toggle()
                        })
                        {
                            HStack {
                                Image("Group 8")
                                    .frame(width: 32, height: 32)
                                Text("Feedback")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
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
                            .frame(height: 0.3)
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
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
        if FeedbackSc{
            Feedback(FeedbackSc: $FeedbackSc, CurrentSc: $CurrentSc)
        }
    }
}
