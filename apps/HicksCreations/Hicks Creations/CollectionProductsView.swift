//
//  CollectionProductsView.swift
//  Hicks Creations
//
//  Created by Mark Hicks on 1/3/26.
//

import SwiftUI

struct CollectionProductsView: View {
    let title: String
    let handle: String

    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var cart: CartViewModel

    @State private var products: [StoreProduct] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Leopard background fills entire screen
            Image(AppTheme.leopardBackgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Loading \(title) products...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(8)
                        .background(AppTheme.cardBackgroundDark)
                        .cornerRadius(8)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(products) { product in
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
        }
        .navigationTitle(title)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            isLoading = true
            store.fetchProductsForCollection(handle: handle) { loaded in
                self.products = loaded
                self.isLoading = false
            }
        }
    }
}
