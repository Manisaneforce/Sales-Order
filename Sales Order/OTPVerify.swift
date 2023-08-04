//
//  OTPVerify.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct OTPVerify: View {
    @State private var phoneNumber: String = ""
    @State private var phoneNumber2: String = ""
    @State private var storedValue: String = ""
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
   
    let numberOffFields: Int
    @State var enterValue: [String]
    @State private var Value = ""
    init(numberOffFields: Int){
        self.numberOffFields = numberOffFields
        self.enterValue = Array(repeating: "", count: numberOffFields)
    }
    var body: some View {
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
            
            
            
            
            Text("Enter your OTP")
                .font(.system(size: 17))
                .font(.title)
                .foregroundColor(Color.gray)
                .frame(width: 400, height: 120)
                .offset(y: 50)
            
            
            HStack{
                
                ForEach(0..<6, id: \.self) {index in
                    TextField("", text: $enterValue[index], onEditingChanged:
                                { editing in
                        if editing{
                            oldValue = enterValue[index]
                        }
                        
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 42,height: 42)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(5)
                    .multilineTextAlignment(.center)
                    .offset(y: 95)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .onChange(of: enterValue[index]) { newValue in
                        if enterValue[index].count > 1{
                            let currentvalue = Array(enterValue[index])
                            print(currentvalue)
                            
                            if currentvalue[0] == Character(oldValue){
                                enterValue[index]=String(enterValue[index].suffix(1))
                            }else{
                                enterValue[index]=String(enterValue[index].prefix(1))
                            }
                        }
                        
                        if !newValue.isEmpty {
                            if index == numberOffFields - 1{
                                fieldFocus = nil
                            }else{
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        }else{
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
                }
                
            }
            
            NavigationLink(destination: HomePage()) {
                           Text("Verify")
                              .frame(width: 300, height: 12)
                               .font(.title)
                              .foregroundColor(.white)
                               .padding()
                               .background(Color.blue)
                              .cornerRadius(10)
                              
                       }
            .offset(y:148)
            

            
        }
    }
    }
}

@available(iOS 15.0, *)
struct OTPVerify_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerify(numberOffFields: 6)
    }
}
