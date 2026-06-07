//
//  ProductDetailView.swift
//  Hicks Creations
//
//  Created by Mark Hicks on 1/3/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: StoreProduct

    @EnvironmentObject var cart: CartViewModel
    @EnvironmentObject var store: StoreViewModel

    @State private var detail: StoreProductDetail?
    @State private var isLoadingDetail = false
    @State private var selectedOptions: [String: String] = [:]
    @State private var selectedCandyChoices: Set<String> = []
    @State private var expandedCategories: Set<String> = []

    // MARK: - Candy Mix Options Data

    private let gummyCandyOptions: [(category: String, items: [String])] = [
        ("Animals & Bugs", [
            "Gummy Worms", "Sour Gummy Worms", "Gummy Bears", "Sour Gummy Bears",
            "Mango Gummy Bears", "Sour Watermelon Gummy Bears", "Sour Cherry Gummy Bears",
            "Sour Blue Raspberry Gummy Bears", "Green Apple Gummy Bears", "Strawberry Banana Gummy Bears",
            "Grape Gummy Bears", "Grapefruit Gummy Bears", "Pineapple Gummy Bears", "Crunchy Gummy Bears",
            "Cinnamon Bears", "Cherry Gummy Bears", "Patriotic Gummy Bears",
            "Chicken Feet", "Twin Snakes", "Sharks", "Sour Sharks",
            "Tropical Filled Frogs", "Jelly Filled Turtles", "Jelly Filled Sour Turtles", "Jelly Filled Whales",
            "Dinosaurs", "Butterflies", "Giant Butterflies", "Sour Piglets", "Piglets", "Giant Piglets",
            "Pink Flamingos", "Tropical Starfish", "Crocodiles", "Giant Bullfrogs", "Rainforest Frogs",
            "GIANT Snake", "Cows", "Ocean Animals", "Octopus", "Dolphins", "Swirly Fish", "Swedish Fish"
        ]),
        ("Foods", [
            "Apple Orchard", "Giant Fried Eggs", "Mini Fried Eggs", "Spicy Filled Mangos",
            "Strawberries", "Sour Strawberries", "Watermelon Slices", "Sour Blue Raspberries",
            "Red Raspberries", "Mixed Berries", "Gummy Pizza", "Cherries", "Sour Cherries", "Sour Kiwi",
            "Chili Peppers", "Giant Bananas", "Bananas", "Cola Bottles", "Sour Cherry Cola Bottles",
            "Sour Cola Bottles", "Ice Cream Cones", "Sour Green Apples", "Peach Hearts",
            "Strawberries & Cream", "Cupcakes", "Sour Pineapples", "Soda Pop Bottles",
            "Bubble Gum Bottles", "Fast Food", "3D Apples", "3D Filled Peaches",
            "3D Filled Oranges", "3D Pineapples", "3D Strawberries"
        ]),
        ("Rings", [
            "Peach Rings", "Apple Rings", "Blue Raspberry Rings", "Cherry Rings",
            "Watermelon Rings", "Pineapple Rings", "Neon Rainbow Rings", "Sour Rainbow Rings",
            "Crunchy Gummy Rings", "Sour Crunchy Gummy Rings", "Strawberry Banana Rings"
        ]),
        ("Drops", [
            "Blue Raspberry Drops", "Strawberry Drops", "Tropical Drops", "Candy Corn Drops"
        ]),
        ("Saltwater Taffy", [
            "Cinnamon Roll", "Caramel Apple", "S'mores", "Candy Apple", "Peanut Butter & Jelly",
            "Banana Split", "Caramel Swirls", "Root Beer Float", "Pina Colada", "Peaches N Cream",
            "Chocolate Chip Cookie", "Cotton Candy", "Strawberry Cheesecake", "Butterscotch",
            "Chocolate Caramel Mocha", "Fruity Cereal", "Candy Corn", "Peppermint",
            "Glazed Donut", "Strawberry Banana", "Dill Pickle", "Cinnamon"
        ]),
        ("Belts & Straws", [
            "Sour Rainbow Belts", "Sour Strawberry Banana Belts", "Sour Cotton Candy Belts",
            "Sour Green Apple Belts", "Sour Mango Belts"
        ]),
        ("Miscellaneous", [
            "Pink Berries", "Strawberry Filled Lips", "Jelly Belly Sour Lips", "Gumballs",
            "Teeth", "Licorice Logs", "Confetti Drops", "Jawbreakers", "Army Men",
            "Cinnamon Hearts", "Easter Eggs", "Wax Bottles"
        ])
    ]

    private let chocolateOptions: [(category: String, items: [String])] = [
        ("Milk Chocolate", [
            "Milk Choc Peanut Butter Buckeyes", "Milk Choc Pecan Caramel Patties",
            "Milk Choc Gummy Bears", "Milk Choc Peanut Butter Cups", "Milk Choc Cashews",
            "Milk Choc Peanuts", "Milk Choc Toffee Crunch", "Milk Choc Pecans", "Smores Bites",
            "Choc Rocks", "Milk Choc Peanut Butter Crisps", "Milk Choc Cake Batter Bites",
            "Milk Choc Almonds", "Milk Choc Raisins", "Milk & Dark Choc Sea Salt Caramels",
            "Milk Choc Pretzels", "Milk Choc Graham Crackers", "Milk Choc Caramels",
            "Milk Choc Peanut Butter Cookie Dough Bites", "Milk Choc Banana Chips",
            "Mini M&M's", "Milk Choc Mini Caramel Cups", "Milk Choc Gold Coins",
            "Milk Choc Sandwich Cookies", "Milk Choc Mini Peanut Butter Cups", "Milk Choc Snickers Clusters"
        ]),
        ("Dark Chocolate", [
            "Dark Choc Peanut Butter Buckeyes", "Dark Choc Pretzels",
            "Dark Choc Raspberry Jelly Rings", "Dark Choc Cashews",
            "Dark Choc Almonds", "Dark Choc Pecans"
        ]),
        ("Miscellaneous", [
            "Pumpkin Pie Almonds", "Birthday Cake Dough Bites", "Vanilla Almond & Toffee Clusters",
            "White Yogurt Pretzels", "Peanut Brittle", "Peanut Butter & Jelly Mini Cups",
            "Old Fashioned Christmas Candy", "Dill Pickle Chocolate Pretzels", "Peanut Butter Monkey Crunch"
        ])
    ]

    private let driedFruitOptions: [String] = [
        "Dried Mango", "Dried Apricot", "Dried Banana Chips", "Dried Cranberries",
        "Dried Raisins", "Crystalized Dried Ginger", "Dried Papaya"
    ]

    // MARK: - Mix Type Detection

    private var mixType: MixType {
        let title = product.title.lowercased()
        if title.contains("gummy mix") || title.contains("gummy mixes") {
            return .gummy
        } else if title.contains("swedish") || title.contains("bubs") {
            return .swedish
        } else if title.contains("chocolate mix") {
            return .chocolate
        } else if title.contains("dried fruit") {
            return .driedFruit
        } else if title.contains("chamoy") || title.contains("tajin") {
            return .chamoy
        }
        return .none
    }

    private enum MixType {
        case gummy, swedish, chocolate, driedFruit, chamoy, none
    }

    private var currentCandyOptions: [(category: String, items: [String])] {
        switch mixType {
        case .gummy, .swedish, .chamoy:
            return gummyCandyOptions
        case .chocolate:
            return chocolateOptions
        case .driedFruit:
            return [("Dried Fruits", driedFruitOptions)]
        case .none:
            return []
        }
    }

    private var isMixProduct: Bool {
        mixType != .none
    }

    var body: some View {
        ZStack {
            // Leopard background fills entire screen
            Image(AppTheme.leopardBackgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Product image
                    if let url = currentImageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .tint(.white)
                                    .frame(height: 250)
                                    .frame(maxWidth: .infinity)
                                    .background(AppTheme.cardBackgroundDark)
                                    .cornerRadius(12)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                            case .failure:
                                Rectangle()
                                    .fill(AppTheme.cardBackgroundDark)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.white.opacity(0.7))
                                    )
                            @unknown default:
                                Rectangle()
                                    .fill(AppTheme.cardBackgroundDark)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                            }
                        }
                    }

                // Product info card
                VStack(alignment: .leading, spacing: 12) {
                    Text(detail?.title ?? product.title)
                        .font(.title2.weight(.bold))
                        .foregroundColor(AppTheme.textOnCard)

                    Text(currentPrice)
                        .font(.title3.weight(.bold))
                        .foregroundColor(AppTheme.primaryTeal)

                    if isLoadingDetail {
                        HStack {
                            ProgressView()
                                .tint(AppTheme.primaryTeal)
                            Text("Loading options...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else if let detail = detail {
                        // Shopify variant options (e.g. Size)
                        ForEach(detail.options, id: \.name) { option in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(AppTheme.textOnCard)

                                Picker(option.name, selection: Binding(
                                    get: { selectedOptions[option.name] ?? option.values.first ?? "" },
                                    set: { selectedOptions[option.name] = $0 }
                                )) {
                                    ForEach(option.values, id: \.self) { value in
                                        Text(value).tag(value)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.primaryTeal)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6))
                                )
                            }
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .cornerRadius(12)

                // Candy options for mix products
                if isMixProduct {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Your Candy")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppTheme.primaryTeal)
                            .cornerRadius(8)

                        ForEach(currentCandyOptions, id: \.category) { categoryData in
                            CandyCategorySection(
                                category: categoryData.category,
                                items: categoryData.items,
                                selectedItems: $selectedCandyChoices,
                                isExpanded: expandedCategories.contains(categoryData.category),
                                onToggleExpand: {
                                    if expandedCategories.contains(categoryData.category) {
                                        expandedCategories.remove(categoryData.category)
                                    } else {
                                        expandedCategories.insert(categoryData.category)
                                    }
                                }
                            )
                        }

                        if !selectedCandyChoices.isEmpty {
                            Text("\(selectedCandyChoices.count) items selected")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppTheme.primaryTeal.opacity(0.8))
                                .cornerRadius(12)
                        }
                    }
                    .padding(16)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(12)
                }

                // Add to Cart button
                Button {
                    addToCart()
                } label: {
                    Text("Add to Cart")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.primaryTeal)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
                }
                .padding(16)
            }
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            loadDetailIfNeeded()
            // Start with all categories expanded
            expandedCategories = Set(currentCandyOptions.map { $0.category })
        }
    }

    // MARK: - Derived Values

    private var currentVariant: StoreProductDetail.Variant? {
        guard let detail else { return nil }
        return detail.variants.first { variant in
            for sel in variant.selectedOptions {
                if let chosen = selectedOptions[sel.name], chosen != sel.value {
                    return false
                }
            }
            return true
        }
    }

    private var currentImageURL: URL? {
        if let vImg = currentVariant?.imageURL {
            return vImg
        }
        if let firstDetailImg = detail?.images.first {
            return firstDetailImg
        }
        return product.imageURL
    }

    private var currentPrice: String {
        currentVariant?.price ?? product.price
    }

    // MARK: - Actions

    private func addToCart() {
        let variantProduct: StoreProduct
        if let variant = currentVariant {
            variantProduct = StoreProduct(
                id: variant.id,
                title: "\(product.title) (\(variant.title))",
                price: variant.price,
                imageURL: variant.imageURL ?? product.imageURL
            )
        } else {
            variantProduct = product
        }

        let notes = buildNotes()
        cart.add(variantProduct, notes: notes)
    }

    private func buildNotes() -> String? {
        guard isMixProduct, !selectedCandyChoices.isEmpty else { return nil }

        // Group by category
        var grouped: [String: [String]] = [:]
        for option in currentCandyOptions {
            let selected = option.items.filter { selectedCandyChoices.contains($0) }
            if !selected.isEmpty {
                grouped[option.category] = selected
            }
        }

        let parts: [String] = grouped.map { category, choices in
            "\(category): \(choices.joined(separator: ", "))"
        }

        return parts.sorted().joined(separator: " | ")
    }

    private func loadDetailIfNeeded() {
        guard detail == nil else { return }

        // Determine the correct handle based on mix type
        let handle: String?
        switch mixType {
        case .gummy:
            handle = "gummy-mix"
        case .swedish:
            handle = "bubs-mixes"
        case .chocolate:
            handle = "chocolate-mixes-1"
        case .driedFruit:
            handle = "dried-fruit-mixes"
        case .chamoy:
            handle = "gummy-mix" // Use gummy-mix as fallback
        case .none:
            handle = nil
        }

        guard let productHandle = handle else { return }

        isLoadingDetail = true
        store.fetchProductDetail(handle: productHandle) { loaded in
            self.detail = loaded
            self.isLoadingDetail = false

            if let loaded = loaded {
                var initial: [String: String] = [:]
                for opt in loaded.options {
                    if let first = opt.values.first {
                        initial[opt.name] = first
                    }
                }
                self.selectedOptions = initial
            }
        }
    }
}

// MARK: - Candy Category Section

struct CandyCategorySection: View {
    let category: String
    let items: [String]
    @Binding var selectedItems: Set<String>
    let isExpanded: Bool
    let onToggleExpand: () -> Void

    private var selectedCount: Int {
        items.filter { selectedItems.contains($0) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category header
            Button {
                onToggleExpand()
            } label: {
                HStack {
                    Text(category)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.textOnCard)

                    if selectedCount > 0 {
                        Text("(\(selectedCount))")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppTheme.primaryTeal)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppTheme.primaryTeal)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(AppTheme.primaryTeal.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)

            // Items (when expanded)
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        Button {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: selectedItems.contains(item) ? "checkmark.square.fill" : "square")
                                    .font(.body)
                                    .foregroundColor(AppTheme.primaryTeal)

                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textOnCard)

                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)

                        if item != items.last {
                            Divider()
                                .padding(.leading, 40)
                        }
                    }
                }
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.top, 4)
            }
        }
    }
}
