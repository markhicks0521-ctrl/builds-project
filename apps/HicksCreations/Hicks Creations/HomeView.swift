import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var cart: CartViewModel

    // Map tile name -> Shopify collection handle
    private func handle(for collectionName: String) -> String {
        switch collectionName {
        case "Candy":
            return "gummy-mixes"
        case "Freeze Dried Candy":
            return "candy"
        case "Hydro Dips":
            return "hydro-dips"
        case "Live Cups":
            return "live-cups"
        default:
            return "all"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Welcome banner
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome to Hicks Creations")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    Text("Thanks for supporting my small business!")
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.primaryTeal.opacity(0.98))
                .cornerRadius(16)

                // Announcement bar
                Text("Ice packs now available to help prevent candy melting. Not liable for melted candy in orders.")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.primaryTeal.opacity(0.9))
                    .cornerRadius(12)

                // SHOP BY COLLECTION header
                Text("SHOP BY COLLECTION")
                    .font(.caption.weight(.bold))
                    .kerning(1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.cardBackgroundDark)
                    .foregroundColor(.white)
                    .cornerRadius(999)
                    .padding(.top, 4)

                // Collection tiles
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(["Candy", "Freeze Dried Candy", "Hydro Dips", "Live Cups"], id: \.self) { name in
                        let h = handle(for: name)

                        NavigationLink {
                            CollectionProductsView(title: name, handle: h)
                        } label: {
                            VStack {
                                Spacer()
                                Text(name)
                                    .font(.headline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 8)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.primaryTeal.opacity(0.95))
                            .cornerRadius(16)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // READY TO SHIP header
                Text("READY TO SHIP")
                    .font(.caption.weight(.bold))
                    .kerning(1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.cardBackgroundDark)
                    .foregroundColor(.white)
                    .cornerRadius(999)
                    .padding(.top, 12)

                // Ready to Ship carousel - dark/teal themed cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(store.readyToShipProducts) { product in
                            Button {
                                cart.add(product)
                                selectedTab = 2
                            } label: {
                                VStack(spacing: 0) {
                                    // Product image - fills the top of card
                                    if let url = product.imageURL {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .tint(.white)
                                                    .frame(width: 140, height: 120)
                                                    .background(AppTheme.primaryTeal.opacity(0.3))
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 140, height: 120)
                                                    .clipped()
                                            case .failure:
                                                Rectangle()
                                                    .fill(AppTheme.primaryTeal.opacity(0.3))
                                                    .frame(width: 140, height: 120)
                                                    .overlay(
                                                        Image(systemName: "photo")
                                                            .foregroundColor(.white.opacity(0.7))
                                                    )
                                            @unknown default:
                                                Rectangle()
                                                    .fill(AppTheme.primaryTeal.opacity(0.3))
                                                    .frame(width: 140, height: 120)
                                            }
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(AppTheme.primaryTeal.opacity(0.3))
                                            .frame(width: 140, height: 120)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.white.opacity(0.7))
                                            )
                                    }

                                    // Product info section - dark semi-transparent background
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(product.title)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)

                                        Text(product.price)
                                            .font(.subheadline.weight(.bold))
                                            .foregroundColor(AppTheme.primaryTeal)
                                    }
                                    .frame(width: 124, alignment: .leading)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(AppTheme.cardBackgroundDark)
                                }
                                .frame(width: 140)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.primaryTeal.opacity(0.5), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // ABOUT HICKS CREATIONS card
                VStack(alignment: .leading, spacing: 8) {
                    Text("ABOUT HICKS CREATIONS")
                        .font(.caption.weight(.bold))
                        .kerning(1)
                        .foregroundColor(.white)

                    Text("Sweet treats and creations made with love in Texas.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("Shop All")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryTeal)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackgroundDark)
                .cornerRadius(16)
            }
            .frame(maxWidth: 340)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .leopardBackground()
    }
}
