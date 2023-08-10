//
//  Testing File.swift
//  Sales Order
//
//  Created by San eforce on 09/08/23.
//

import SwiftUI

struct Testing_File: View {
    @State private var isPopupVisible = false
    @State private var selectedItem: String = "Pipette"
    var body: some View {
        NavigationView {
            List {
                ForEach(1..<6) { index in
                    Text("Item \(index)")
                }
            }
            .navigationBarTitle("ListView with Popup")
            .navigationBarItems(trailing:
                Button(action: {
                    isPopupVisible = true
                }) {
                    Image(systemName: "plus.circle")
                }
            )
            .alert(isPresented: $isPopupVisible) {
                Alert(
                    title: Text("Popup Content"),
                    message: nil,
                    primaryButton: .default(Text("Close Popup")) {
                        isPopupVisible = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}


struct PopupContent: View {
    @Binding var isPopupVisible: Bool

    var body: some View {
        VStack {
            Text("Popup Content")
                .font(.headline)
            Button("Close Popup") {
                isPopupVisible = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}


