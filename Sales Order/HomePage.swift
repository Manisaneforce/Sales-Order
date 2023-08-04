//
//  HomePage.swift
//  Sales Order
//
//  Created by San eforce on 04/08/23.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        Text("ReliVet Dashboard ")
            .frame(width: 300, height: 12)
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .offset(y: 20)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}



