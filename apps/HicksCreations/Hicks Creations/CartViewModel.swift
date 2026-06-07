import Foundation
import Combine

struct CartItem: Identifiable {
    let id = UUID()
    let product: StoreProduct
    var quantity: Int
    var notes: String?          //New: line-item notes (candy picks, etc.)
}

final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []

    var total: Double {
        items.reduce(0) { partial, item in
            let components = item.product.price.split(separator: " ")
            let amount = Double(components.first ?? "0") ?? 0
            return partial + amount * Double(item.quantity)
        }
    }

    // Default add (no extra notes)
        func add(_ product: StoreProduct) {
            add(product, notes: nil)
        }

        // NEW: add with notes (for mixes with candy selections)
        func add(_ product: StoreProduct, notes: String?) {
            if let index = items.firstIndex(where: { $0.product.id == product.id && $0.notes == notes }) {
                items[index].quantity += 1
            } else {
                items.append(CartItem(product: product, quantity: 1, notes: notes))
            }
        }

        func remove(_ item: CartItem) {
            items.removeAll { $0.id == item.id }
        }

        func clear() {
            items.removeAll()
        }
    }


