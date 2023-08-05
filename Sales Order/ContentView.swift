//
//  ContentView.swift
//  Sales Order
//
//  Created by San eforce on 02/08/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @State private var isTextFieldHidden: Bool = false
    @State private var isTextFieldHidden2: Bool = true
    @State private var OTPtext: Bool = true
    @State private var Mobilnumber:Bool = false
    @State private var Verybutton:Bool = true
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    @State private var VerifyBt: Bool = true
    @State private var SubmitBt: Bool = false
    let numberOffFields: Int
    @State var enterValue: [String]
    @State private var Value = ""
    init(numberOffFields: Int){
        self.numberOffFields = numberOffFields
        self.enterValue = Array(repeating: "", count: numberOffFields)
    }
    var body: some View {
        //ScrollView {
        NavigationView {
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
            if  !Mobilnumber{
                Text("Enter your registered mobile number")
                    .font(.system(size: 17))
                    .font(.title)
                    .foregroundColor(Color.gray)
                    .frame(width: 400, height: 120)
                    .offset(y: 50)
            }
            if !isTextFieldHidden {
                TextField("Mobile Number", text: $phoneNumber)
                    .border(Color.blue, width: 2)
                    .cornerRadius(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 325)
                    .offset(y: 100)
            }
            
            NavigationLink(destination: OTPVerify(numberOffFields: 6)) {
                           Text("Submit")
                              .frame(width: 300, height: 12)
                               .font(.title)
                              .foregroundColor(.white)
                               .padding()
                               .background(Color.blue)
                              
                
                              
                       }
            .offset(y:145)
            

        }
    }
        .navigationBarHidden(true)
        
            }
            
        }

    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            if #available(iOS 15.0, *) {
                ContentView(numberOffFields: 6)
            } else {
                
            }
        }
    }

