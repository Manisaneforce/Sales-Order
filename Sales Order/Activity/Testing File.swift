//
//  Testing File.swift
//  Sales Order
//
//  Created by San eforce on 09/08/23.
//

import SwiftUI

struct Testing_File: View {
    @State private var number = 0
    var body: some View {
        VStack {
                    
                    
                    HStack {
                        Button(action: {
                            self.number -= 1
                        }) {
                            Text("-")
                        }
                        Text("\(number)")
                        Button(action: {
                            self.number += 1
                        }) {
                            Text("+")
                        }
                    }
                }
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}

//struct ContentView: View {
//    @State private var viewModels: [ItemViewModel] = (0 ..< 5).map { _ in ItemViewModel() }
//    
//    var body: some View {
//        List(0 ..< 5) { index in
//            HStack {
//                Image("logo_new")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 70)
//                    .cornerRadius(4)
//                
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("FIPOREL_ S DOG 0.67 ML")
//                        .fontWeight(.semibold)
//                        .lineLimit(2)
//                        .minimumScaleFactor(0.5)
//                    
//                    // ... other view components ...
//                    
//                    HStack {
//                        Text("Pipette")
//                        Spacer()
//                        HStack {
//                            Button(action: {
//                                self.viewModels[index].decreaseNumber()
//                            }) {
//                                Text("-")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//                                    .multilineTextAlignment(.leading)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            Text("\(viewModels[index].number)")
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.black)
//                            Button(action: {
//                                self.viewModels[index].increaseNumber()
//                            }) {
//                                Text("+")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//                                    .multilineTextAlignment(.leading)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 20)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 2)
//                        )
//                        .foregroundColor(Color.blue)
//                    }
//                    
//                    // ... other view components ...
//                    
//                }
//                .padding(.vertical, 5)
//            }
//            .background(Color.white)
//        }
//    }
//}
//
//class ItemViewModel: ObservableObject {
//    @Published var number: Int = 0
//    
//    func increaseNumber() {
//        number += 1
//    }
//    
//    func decreaseNumber() {
//        if number > 0 {
//            number -= 1
//        }
//    }
//}
