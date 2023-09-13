//
//  Nedata.swift
//  Sales Order
//
//  Created by San eforce on 22/08/23.
//

import SwiftUI


struct Nedata: View {
    enum Category: String, CaseIterable, Identifiable {
        case A, B, C
        var id: String { self.rawValue }
        
        var products: [String] {
            switch self {
                case .A: return ["Product A1", "Product A2", "Product A3", "Product A4", "Product A5"]
                case .B: return ["Product B6", "Product B7", "Product B8", "Product B9"]
                case .C: return ["Product C10", "Product C11", "Product C12"]
            }
        }
    }
    
    @State private var selectedCategory: Category? = nil
    @State private var selectedProducts: Set<String> = []

    var body: some View {
        VStack {
            Text("Select a Category")
            
            ForEach(Category.allCases) { category in
                Button(category.rawValue) {
                    self.selectedCategory = category
                }
            }
            
            if let selectedCategory = selectedCategory {
                VStack {
                    Text("Select Products in \(selectedCategory.rawValue)")
                    
                    ForEach(selectedCategory.products, id: \.self) { product in
                        Button(action: {
                            toggleProductSelection(product)
                            print(selectedProducts)
                            print(selectedCategory)
                        }) {
                            Text(product)
                                .foregroundColor(selectedProducts.contains(product) ? .blue : .black)
                           
                        }
                    }
                    
                    Button("Submit") {
                        // Handle submission and navigation here
                    }
                }
            }
        }
    }
    
    private func toggleProductSelection(_ product: String) {
        if selectedProducts.contains(product) {
            selectedProducts.remove(product)
        } else {
            selectedProducts.insert(product)
        }
    }
}

struct Nedata_Previews: PreviewProvider {
    static var previews: some View {
        Nedata()
        ShowPopup()
        dateFilter()
    }
}



struct PopUpView: View {
    @Binding var isShowingPopUp: Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
                LottieUIView(filename: "mobile_number").frame(width: 180,height: 180)
                
                Text("Select ITEM")
                
            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .background(Color.gray)
            .cornerRadius(25)
        }
    }
}

struct ShowPopup: View {
    @State private var isShowingPopUp = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10, id: \.self) { index in
                    Text("Row \(index)")
                        .onTapGesture {
                            isShowingPopUp.toggle()
                        }
                }
            }
            .navigationBarTitle("List with Pop-up")
        }
        .sheet(isPresented: $isShowingPopUp, content: {
            PopUpView(isShowingPopUp: $isShowingPopUp)
        })
        
    }
}


struct dateFilter: View{
    @State private var showLast7Days = false
       @State private var showLast30Days = false
    let currentDate = Date()
      let calendar = Calendar.current
    var body: some View{
        VStack {
            Text("Current Date: \(formattedDate(date: currentDate))")
                .padding()
            
            Divider()
            
            Button("Last 7 Days") {
                showLast7Days.toggle()
                showLast30Days = false
            }
            .padding()
            
            Button("Last 30 Days") {
                showLast30Days.toggle()
                showLast7Days = false
            }
            .padding()
            
            if showLast7Days {
                Text("From: \(formattedDate(date: calculateStartDate(for: 7)))")
                Text("To: \(formattedDate(date: currentDate))")
            }
            
            if showLast30Days {
                Text("From: \(formattedDate(date: calculateStartDate(for: 30)))")
                Text("To: \(formattedDate(date: currentDate))")
            }
            
            Spacer()
        }
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func calculateStartDate(for days: Int) -> Date {
        let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
        return startDate ?? currentDate
    }
}

