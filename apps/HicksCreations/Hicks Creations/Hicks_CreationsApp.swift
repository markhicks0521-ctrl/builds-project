import SwiftUI

@main
struct Hicks_CreationsApp: App {
    @StateObject private var storeViewModel = StoreViewModel()
    @StateObject private var cartViewModel = CartViewModel()

    init() {
        // Teal color for UI elements
        let tealColor = UIColor(red: 0, green: 0.537, blue: 0.482, alpha: 1)

        // Navigation bar - transparent to show leopard background
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        navAppearance.titleTextAttributes = [.foregroundColor: tealColor]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: tealColor]

        UINavigationBar.appearance().tintColor = tealColor
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance

        // Tab bar - solid teal background, white icons
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = tealColor

        // Normal state - white with some transparency
        let normalColor = UIColor.white.withAlphaComponent(0.7)
        tabAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]

        // Selected state - bright white
        tabAppearance.stackedLayoutAppearance.selected.iconColor = .white
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeViewModel)
                .environmentObject(cartViewModel)
                .tint(AppTheme.primaryTeal)
        }
    }
}
