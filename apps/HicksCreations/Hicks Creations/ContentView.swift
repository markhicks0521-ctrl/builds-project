import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var cart: CartViewModel

    var body: some View {
        TabView(selection: $selectedTab) {

            // HOME TAB
            NavigationStack {
                HomeView(selectedTab: $selectedTab)
                    .onAppear {
                        store.fetchReadyToShip()
                        store.fetchAllProducts()
                    }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)

            // SHOP TAB
            NavigationStack {
                ShopView()
            }
            .tabItem {
                Image(systemName: "bag")
                Text("Shop")
            }
            .tag(1)

            // CART TAB
            NavigationStack {
                CartView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }
            .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StoreViewModel())
        .environmentObject(CartViewModel())
}
