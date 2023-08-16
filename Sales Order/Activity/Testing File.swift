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
        LottieUIView(filename: "Call").frame(width: 150,height: 150)
        
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}



