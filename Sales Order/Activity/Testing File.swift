import SwiftUI

struct Product: Identifiable, Equatable {
    let id: Int
    let name: String
    let rate: Double
}

struct Category: Identifiable, Equatable {
    let id: Int
    let name: String
    let products: [Product]
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Testing_File: View {
    @State private var categories: [Category] = [
        Category(id: 0, name: "A", products: [
            Product(id: 0, name: "Product A1", rate: 10.0),
            Product(id: 1, name: "Product A2", rate: 20.0),
            Product(id: 2, name: "Product A3", rate: 15.0)
        ]),
        Category(id: 1, name: "B", products: [
            Product(id: 3, name: "Product B1", rate: 25.0),
            Product(id: 4, name: "Product B2", rate: 30.0),
            Product(id: 5, name: "Product B3", rate: 22.0),
            Product(id: 6, name: "Product B4", rate: 18.0)
        ]),
        Category(id: 2, name: "C", products: [
            Product(id: 7, name: "Product C1", rate: 12.0),
            Product(id: 8, name: "Product C2", rate: 17.0)
        ])
    ]
    @State private var selectedCategories: [Category] = []
    @State private var selectedProducts: [Product] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(categories, id: \.id) { category in
                    Button(action: {
                        toggleCategorySelection(for: category)
                    }) {
                        Text(category.name)
                            .foregroundColor(selectedCategories.contains(category) ? .blue : .primary)
                    }
                }
                .navigationBarTitle("Categories")
                
                List(selectedProducts) { product in
                    HStack {
                        Text(product.name)
                        Spacer()
                        Text("₹\(product.rate)")
                        Button(action: {
                            toggleProductSelection(for: product)
                        }) {
                            if selectedProducts.contains(product) {
                                Text("Selected")
                                    .foregroundColor(.blue)
                            } else {
                                Text("Select")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                
                if selectedProducts.isEmpty == false {
                    NavigationLink(destination: SelectedProductsView(selectedCategories: selectedCategories, selectedProducts: selectedProducts)) {
                        Text("Proceed")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
    }
    
    private func toggleCategorySelection(for category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
            selectedProducts.removeAll { selectedCategories.flatMap { $0.products }.contains($0) }
        } else {
            selectedCategories.append(category)
            selectedProducts.append(contentsOf: category.products)
        }
    }
    
    private func toggleProductSelection(for product: Product) {
        if selectedProducts.contains(product) {
            selectedProducts.removeAll { $0 == product }
            selectedCategories.removeAll { $0.products.contains(product) }
        } else {
            selectedProducts.append(product)
            if let category = categories.first(where: { $0.products.contains(product) }) {
                selectedCategories.append(category)
            }
        }
    }
}

struct SelectedProductsView: View {
    let selectedCategories: [Category]
    let selectedProducts: [Product]
    
    var body: some View {
        VStack {
            Text("Selected Products:")
                .font(.title)
                .padding()
            
            List(selectedProducts) { product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Text("₹\(product.rate)")
                }
            }
            
            Text("Selected Categories:")
                .font(.title)
                .padding(.top)
            
            List(selectedCategories) { category in
                Text(category.name)
                    .font(.headline)
                    .padding()
            }
        }
        .navigationBarTitle("Selected Products and Categories")
    }
}
struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}

