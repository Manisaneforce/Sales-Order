//
//  ContentView.swift
//  Sales Order
//
//  Created by San eforce on 02/08/23.
//

import SwiftUI
//import Alamofire

struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @State private var isTextFieldHidden: Bool = false
    @State private var isTextFieldHidden2: Bool = true
    var body: some View {
        //ScrollView {
        ZStack {
            Image("logo_new")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 100)
                .offset(y: -310)
            
            Text("Welcome to ReliVet")
                .font(.title)
                .bold()
                .font(.system(size: 24))
                .foregroundColor(Color.gray)
                .frame(width: 300, height: 300)
                .offset(y: -190)
            
            Text("Sign in to continue")
                .font(.system(size: 20))
                .font(.title)
                .foregroundColor(Color.gray)
                .frame(width: 200, height: 150)
                .offset(y: -160)
            
            Image("Phonecall")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .offset(y: -60)
            
            // Show the text field conditionally based on the state variable
            Text("Enter your registered mobile number")
                .font(.system(size: 17))
                .font(.title)
                .foregroundColor(Color.gray)
                .frame(width: 400, height: 120)
                .offset(y: 50)
            if !isTextFieldHidden {
                TextField("Mobile Number", text: $phoneNumber)
                    .border(Color.blue, width: 2)
                    .cornerRadius(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 325)
                    .offset(y: 100)
            }
            
            HStack{
                if !isTextFieldHidden2{
                    ForEach(0..<6, id: \.self) {index in
                        TextField("", text: $phoneNumber2)
                            .frame(width: 42,height: 42)
                            .background(Color.blue.opacity(0.1))
                            //.background(Color.blue)
                            .cornerRadius(5)
                            .multilineTextAlignment(.center)
                            .offset(y: 95)
                        
                    }
                    
                }
            }
                
                GeometryReader { geometry in
                    Button(action: {
                        
                        
                        print("Button tapped!")
                        
                        
                        isTextFieldHidden = true
                        isTextFieldHidden2 = false
                    }) {
                        Text("Submit")
                            .frame(width: 300, height: 12)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .offset(y: 20)
                    }
                    .frame(width: geometry.size.width * 0.8)
                    
                    .frame(width: 300, height: 12)
                    .offset(x: 50, y: 500)
                }
            }
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

