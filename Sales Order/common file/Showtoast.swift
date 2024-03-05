//
//  Showtoast.swift
//  Sales Order
//
//  Created by San eforce on 11/08/23.
//
import Foundation
import SwiftUI
import CoreLocation

struct Showtoast: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut)
    }
}

struct Toast: View {
    @State private var showToast = false
    
    var body: some View {
        VStack {
            Button("Show Toast") {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
            .padding()
            
            Spacer()
        }
        .toast(isPresented: $showToast, message: "This is a toast message!")
        .padding()
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isPresented {
                Showtoast(message: message)
            }
        }
    }
}

struct Showtoast_Previews: PreviewProvider {
    static var previews: some View {
        Toast()
    }
}
class ShowToastMes{
    static var shared = ShowToastMes()
    var tost:String = ""
}
