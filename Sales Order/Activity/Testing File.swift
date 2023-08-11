//
//  Testing File.swift
//  Sales Order
//
//  Created by San eforce on 09/08/23.
//

import SwiftUI

struct Testing_File: View {
    @State private var showToast = false
    var body: some View {
        VStack {
             Button("Show Toast on Another Screen") {
                 showToast = true
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                     showToast = false
                 }
             }
             .padding()
             
             Spacer()
         }
         .toast(isPresented: $showToast, message: "This is a toast message on another screen!")
         .padding()
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}



