*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

At the end of every session, edit this file in place — add, remove, or reword lines as needed to keep it accurate and current. Do not append new dated sections. Do not create versioned copies.

---

# Hicks Creations iOS App — Dev Log

## Project Overview
E-commerce iOS app for Hicks Creations candy shop, integrated with Shopify Storefront API.

---

## Current State (Apr 20, 2026)

### Completed Features
- Tab-based navigation (Home, Shop, Cart)
- Home screen with welcome banner, collection tiles, ready-to-ship carousel, about section
- Shop screen with themed product listing
- Product detail view with variant selection
- **COMPLETE candy mix builder with all options** for Gummy, Swedish, Chocolate, and Dried Fruit mixes
- Cart system with quantities, custom notes, and Checkout button
- Shopify GraphQL integration for products and collections
- **Consistent leopard/teal theme across ALL screens**
- Teal navigation bars and back buttons throughout

### Known Issues / Technical Debt
- Shopify access token is hardcoded in StoreViewModel.swift (security concern for production)
- ShopifyClient.swift is unused (template file)
- Chamoy & Tajin mix handle still needs to be found
- Limited error handling in network requests
- No offline support or caching

---

## Next Session: Priority Tasks

### 1. Chamoy & Tajin Mix Support
- Find the Shopify product handle for Chamoy & Tajin mixes
- Verify the candy options are correct for this mix type

### 2. Security Improvements
- Move Shopify access token out of hardcoded StoreViewModel.swift
- Options: backend proxy, xcconfig file, or obfuscation

### 3. Error Handling & Polish
- Add proper error states for network failures
- Consider offline caching for product data
- Remove unused ShopifyClient.swift template file

### 4. Testing
- Test checkout flow with real Shopify cart
- Verify all mix types show correct options
- Test on iOS 18 device/simulator for compatibility

---

## Shopify Product Handles Reference
- Gummy Mixes: `gummy-mix`
- Swedish Candy Mixes: `bubs-mixes`
- Chocolate Mixes: `chocolate-mixes-1`
- Dried Fruit Mixes: `dried-fruit-mixes`
- Chamoy & Tajin: (need to find handle)

---

## Notes
- Project migrated from Mac: `/Users/markhicks/Documents/AppDevelopment/Hicks Creations/`
- Shopify store: hickscreations.myshopify.com
- API version: 2024-10
- Website theme: Pink/cream with Playball font (DO NOT use in app)
- App theme: Teal + Leopard background (KEEP THIS)
