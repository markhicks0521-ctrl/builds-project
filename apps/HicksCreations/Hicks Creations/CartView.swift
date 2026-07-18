import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartViewModel

    var body: some View {
        ZStack {
            // Leopard background fills entire screen
            Image(AppTheme.leopardBackgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            VStack(spacing: 0) {
                if cart.items.isEmpty {
                    // Empty cart state
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.white)

                        Text("Your cart is empty")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)

                        Text("Add some sweet treats!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(24)
                    .background(AppTheme.cardBackgroundDark)
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Cart items list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(cart.items) { item in
                                CartItemRow(item: item) {
                                    cart.remove(item)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }

                    // Bottom checkout section
                    VStack(spacing: 12) {
                        // Total
                        HStack {
                            Text("Total:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "$%.2f", cart.total))
                                .font(.title2.weight(.bold))
                                .foregroundColor(.white)
                        }

                        // Checkout button
                        Button {
                            openCheckout()
                        } label: {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Checkout")
                                    .font(.headline.weight(.bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryTeal)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(16)
                    .background(AppTheme.cardBackgroundDark)
                }
            }
        }
        .navigationTitle("Cart")
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private func openCheckout() {
        let store = "hickscreations.myshopify.com"

        let cartItems = cart.items.map { item in
            let variantId = extractShopifyId(from: item.product.id)
            return "\(variantId):\(item.quantity)"
        }.joined(separator: ",")

        let checkoutURLString = "https://\(store)/cart/\(cartItems)"

        if let url = URL(string: checkoutURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func extractShopifyId(from gid: String) -> String {
        if let lastComponent = gid.split(separator: "/").last {
            return String(lastComponent)
        }
        return gid
    }
}

// Themed cart item row with semi-transparent background
struct CartItemRow: View {
    let item: CartItem
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Product image
            if let url = item.product.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.white)
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 60, height: 60)
                    @unknown default:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 60, height: 60)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(item.product.price)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppTheme.primaryTeal)

                if let notes = item.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text("Qty: \(item.quantity)")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)

                Button {
                    onRemove()
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .cornerRadius(6)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
