import SwiftUI

enum AppTheme {
    // Primary teal color - #00897B
    static let primaryTeal = Color(red: 0, green: 0.537, blue: 0.482)

    // Darker teal for backgrounds
    static let tealDark = Color(red: 0, green: 0.4, blue: 0.36)

    // Semi-transparent card backgrounds
    static let cardBackground = Color.white.opacity(0.92)
    static let cardBackgroundDark = Color.black.opacity(0.6)
    static let cardBackgroundTeal = AppTheme.primaryTeal.opacity(0.85)

    // Text colors
    static let textPrimary = Color.white
    static let textOnCard = Color.black.opacity(0.9)
    static let textOnDark = Color.white

    // Leopard background image name
    static let leopardBackgroundName = "LeopardBackground"
}

// Reusable leopard background modifier - fills entire screen
struct LeopardBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            // Background image that fills the entire screen
            Image(AppTheme.leopardBackgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            // Content on top
            content
        }
    }
}

extension View {
    func leopardBackground() -> some View {
        modifier(LeopardBackground())
    }
}

// Styled product row for lists
struct ThemedProductRow: View {
    let product: StoreProduct

    var body: some View {
        HStack(spacing: 12) {
            // Product image
            if let url = product.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 70, height: 70)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70, height: 70)
                    @unknown default:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70, height: 70)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textOnCard)
                Text(product.price)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppTheme.primaryTeal)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(AppTheme.primaryTeal)
        }
        .padding(12)
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
    }
}
