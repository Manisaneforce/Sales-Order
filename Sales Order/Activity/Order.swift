//
//  Order.swift
//  Sales Order
//
//  Created by San eforce on 07/08/23.
//

import SwiftUI

struct Order: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(height: 100)
                
                HStack {
                    Button(action: {
                        // Add action for the back button if needed
                    }) {
                        Image("backsmall")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    .offset(x: -120, y: 20)
                    
                    Text("Order")
                        .font(.system(size: 25))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding([.top, .leading, .bottom])
                        .offset(x: -20) // Adjust the X offset if needed
                }
            }
            
            Spacer() // Add spacing between the header and the content
            
            // Add your content here within the VStack
            Text("Your content goes here")
            
            Spacer() // Add spacing between the content and the bottom edge
        }
        .padding(.top, 400) // Adjust the top padding if needed
        .edgesIgnoringSafeArea(.top) // Ignore safe area for the top edge
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
