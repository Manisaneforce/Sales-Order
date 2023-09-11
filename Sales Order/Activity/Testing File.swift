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
        ShareFile()
       //OrderScreen()
    }
}

//struct OrderScreen: View {
//    @State private var selectedCategory: Category? = nil
//    var body: some View {
//        NavigationView {
//                   VStack {
//                       ScrollView(.horizontal, showsIndicators: false) {
//                           HStack(spacing: 20) {
//                               ForEach(Category.allCases, id: \.self) { category in
//                                   CategoryButton(category: category, isSelected: selectedCategory == category) {
//                                       selectedCategory = category
//                                   }
//                               }
//                           }
//                           .padding()
//                       }
//
//                       if let selectedCategory = selectedCategory {
//                           switch selectedCategory {
//                           case .biscuit:
//                               ProductListView(products: .biscuitProducts)
//                           case .cake:
//                               ProductListView(products: .cakeProducts)
//                           case .chocolate:
//                               ProductListView(products: .chocolateProducts)
//                           }
//                       }
//
//                       Spacer()
//                   }
//                   .navigationTitle("Products")
//               }
//    }
//}
//
//struct ProductListView: View {
//    let products: [Product]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Products")
//                .font(.headline)
//                .padding(.horizontal)
//
//            List(products, id: \.id) { product in
//                Text(product.name)
//            }
//        }
//    }
//}
//
//struct CategoryButton: View {
//    let category: Category
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: {
//            action()
//        }) {
//            Text(category.rawValue)
//                .foregroundColor(isSelected ? .white : .black)
//                .padding()
//                .background(isSelected ? Color.blue : Color.gray.opacity(0.5))
//                .cornerRadius(10)
//        }
//    }
//}
//
//enum Category: String, CaseIterable {
//    case biscuit = "Biscuit"
//    case cake = "Cake"
//    case chocolate = "Chocolate"
//}
//
//struct Product: Identifiable {
//    let id = UUID()
//    let name: String
//}
//
//extension Array where Element == Product {
//    static let biscuitProducts: [Product] = [
//        Product(name: "Biscuit 1"),
//        Product(name: "Biscuit 2"),
//        Product(name: "Biscuit 3"),
//        Product(name: "Biscuit 4"),
//        Product(name: "Biscuit 5")
//    ]
//
//    static let cakeProducts: [Product] = [
//        Product(name: "Cake 1"),
//        Product(name: "Cake 2"),
//        Product(name: "Cake 3"),
//        Product(name: "Cake 4")
//    ]
//
//    static let chocolateProducts: [Product] = [
//        Product(name: "Chocolate 1"),
//        Product(name: "Chocolate 2"),
//        Product(name: "Chocolate 3")
//    ]
//}



struct ShareFile: View{
    @State private var isShowingShareSheet = false
    var body: some View{
        VStack {
            Text("Hello, World!")
                .padding()
            
            Button("Share") {
                isShowingShareSheet.toggle()
            }
            .padding()
            .sheet(isPresented: $isShowingShareSheet, onDismiss: {
                isShowingShareSheet = false
            }) {
                ShareSheet()
            }
        }
    }
}



struct ShareSheet: View {
    @State private var isShowingActivityView = false
    
    var body: some View {
        VStack {
            Text("Share As Image")
                .font(.headline)
                .padding()
            
            Button("Share") {
                isShowingActivityView.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isShowingActivityView, onDismiss: {
                isShowingActivityView = false
            }) {
                ActivityViewController(activityItems: [snapshot()])
            }
        }
    }
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: ContentView())
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .white

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to do here
    }
}


