//
//  ImageURL.swift
//  Sales Order
//
//  Created by San eforce on 21/08/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct ImageURL: View {
    @State private var url = URL(string: "https://rad.salesjump.in/MasterFiles/PImage/FiproRel-S%201.34%20mL%20Outer%20carton.png")
    var URL :
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "exclamationmark.icloud.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            // Fallback on earlier versions
            Text("Image URL not valid.")
        }
    }
}

@available(iOS 15.0, *)
struct ImageURL_Previews: PreviewProvider {
    static var previews: some View {
        ImageURL()
    }
}
