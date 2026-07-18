import SwiftUI

struct ShopView: View {
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var cart: CartViewModel

    var body: some View {
        ZStack {
            // Leopard background fills entire screen
            Image(AppTheme.leopardBackgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(store.allProducts) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ThemedProductRow(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Shop")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
