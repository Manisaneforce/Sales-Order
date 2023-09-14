//
//  Feedback.swift
//  Sales Order
//
//  Created by San eforce on 13/09/23.
//

import SwiftUI

struct Feedback: View {
    var body: some View {
        Text("Under Development")
    }
}

struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        Feedback()
        NavigtionView()
    }
}

struct NavigtionView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("First View")
                NavigationLink(destination: SecondView()) {
                    Text("Go to Second View")
                }
            }
        }
    }
}

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Second View")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.blue)
        })
    }
}
