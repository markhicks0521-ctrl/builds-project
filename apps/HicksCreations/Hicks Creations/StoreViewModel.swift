import Foundation
import Combine

struct StoreProduct: Identifiable {
    let id: String
    let title: String
    let price: String
    let imageURL: URL?
}

struct StoreProductDetail {
    struct Option {
        let name: String
        let values: [String]
    }

    struct Variant {
        let id: String
        let title: String
        let price: String
        let selectedOptions: [SelectedOption]
        let imageURL: URL?
    }

    struct SelectedOption {
        let name: String
        let value: String
    }

    let id: String
    let title: String
    let description: String
    let options: [Option]
    let variants: [Variant]
    let images: [URL?]
}

extension StoreProductDetail {
    static func from(json: [String: Any]) -> StoreProductDetail? {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String
        else {
            return nil
        }

        let description = json["description"] as? String ?? ""

        // images array (just URLs)
        var images: [URL?] = []
        if
            let imagesDict = json["images"] as? [String: Any],
            let imgEdges = imagesDict["edges"] as? [[String: Any]]
        {
            images = imgEdges.compactMap { edge in
                guard
                    let node = edge["node"] as? [String: Any],
                    let urlString = node["url"] as? String
                else { return nil }
                return URL(string: urlString)
            }
        }

        // options
        var options: [Option] = []
        if let optionsArray = json["options"] as? [[String: Any]] {
            options = optionsArray.compactMap { opt in
                guard let name = opt["name"] as? String else { return nil }
                let values = opt["values"] as? [String] ?? []
                return Option(name: name, values: values)
            }
        }

        // variants
        var variants: [Variant] = []
        if
            let variantsDict = json["variants"] as? [String: Any],
            let varEdges = variantsDict["edges"] as? [[String: Any]]
        {
            variants = varEdges.compactMap { edge in
                guard
                    let node = edge["node"] as? [String: Any],
                    let id = node["id"] as? String,
                    let title = node["title"] as? String,
                    let priceDict = node["price"] as? [String: Any],
                    let amountString = priceDict["amount"] as? String,
                    let currency = priceDict["currencyCode"] as? String
                else { return nil }

                let amount = Double(amountString) ?? 0
                let formattedAmount = String(format: "%.2f", amount)
                let priceString = "\(formattedAmount) \(currency)"

                var selectedOptions: [SelectedOption] = []
                if let selOpts = node["selectedOptions"] as? [[String: Any]] {
                    selectedOptions = selOpts.compactMap { so in
                        guard
                            let n = so["name"] as? String,
                            let v = so["value"] as? String
                        else { return nil }
                        return SelectedOption(name: n, value: v)
                    }
                }

                var imageURL: URL? = nil
                if
                    let imageDict = node["image"] as? [String: Any],
                    let urlString = imageDict["url"] as? String
                {
                    imageURL = URL(string: urlString)
                }

                return Variant(
                    id: id,
                    title: title,
                    price: priceString,
                    selectedOptions: selectedOptions,
                    imageURL: imageURL
                )
            }
        }

        return StoreProductDetail(
            id: id,
            title: title,
            description: description,
            options: options,
            variants: variants,
            images: images
        )
    }
}


@MainActor
final class StoreViewModel: ObservableObject {
    @Published var readyToShipProducts: [StoreProduct] = []
    @Published var allProducts: [StoreProduct] = []
    @Published var collectionProducts: [StoreProduct] = []   // products for the currently opened collection

    func fetchProductDetail(handle: String,
                            completion: @escaping (StoreProductDetail?) -> Void) {
        guard let url = URL(string: "https://hickscreations.myshopify.com/api/2024-10/graphql.json") else {
            completion(nil)
            return
        }

        let query = """
        {
          product(handle: "\(handle)") {
            id
            title
            description
            priceRange {
              minVariantPrice {
                amount
                currencyCode
              }
            }
            images(first: 5) {
              edges {
                node {
                  url
                }
              }
            }
            options {
              name
              values
            }
            variants(first: 50) {
              edges {
                node {
                  id
                  title
                  price {
                    amount
                    currencyCode
                  }
                  selectedOptions {
                    name
                    value
                  }
                  image {
                    url
                  }
                }
              }
            }
          }
        }
        """

        let body: [String: Any] = ["query": query]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("581b67b712281074065061bb48ff2d03",
                         forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let raw = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard
                    let dataDict = raw?["data"] as? [String: Any],
                    let product = dataDict["product"] as? [String: Any]
                else {
                    completion(nil)
                    return
                }

                // Parse into a detail model
                let detail = StoreProductDetail.from(json: product)
                DispatchQueue.main.async {
                    completion(detail)
                }
            } catch {
                print("Product detail parse error:", error)
                completion(nil)
            }
        }
        .resume()
    }

    
    func fetchReadyToShip() {
        guard let url = URL(string: "https://hickscreations.myshopify.com/api/2024-10/graphql.json") else {
            return
        }
        
        let query = """
        {
          collection(handle: "ready-to-ship") {
            products(first: 10) {
              edges {
                node {
                  id
                  title
                  priceRange {
                    minVariantPrice {
                      amount
                      currencyCode
                    }
                  }
                  images(first: 1) {
                    edges {
                      node {
                        url
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """
        
        let body: [String: Any] = ["query": query]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("581b67b712281074065061bb48ff2d03",
                         forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            
            do {
                // Decode as generic JSON instead of nested Decodable structs
                let raw = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                guard
                    let dataDict = raw?["data"] as? [String: Any],
                    let collection = dataDict["collection"] as? [String: Any],
                    let products = collection["products"] as? [String: Any],
                    let edges = products["edges"] as? [[String: Any]]
                else {
                    print("Unexpected JSON shape")
                    return
                }
                
                let mapped: [StoreProduct] = edges.compactMap { edge in
                    guard
                        let node = edge["node"] as? [String: Any],
                        let id = node["id"] as? String,
                        let title = node["title"] as? String,
                        let priceRange = node["priceRange"] as? [String: Any],
                        let minVariantPrice = priceRange["minVariantPrice"] as? [String: Any],
                        let amountString = minVariantPrice["amount"] as? String,
                        let currency = minVariantPrice["currencyCode"] as? String
                    else {
                        return nil
                    }
                    
                    let amount = Double(amountString) ?? 0
                    let formattedAmount = String(format: "%.2f", amount)
                    let priceString = "\(formattedAmount) \(currency)"
                    
                    var imageURL: URL? = nil
                    if
                        let images = node["images"] as? [String: Any],
                        let imgEdges = images["edges"] as? [[String: Any]],
                        let firstEdge = imgEdges.first,
                        let imgNode = firstEdge["node"] as? [String: Any],
                        let urlString = imgNode["url"] as? String
                    {
                        imageURL = URL(string: urlString)
                    }
                    
                    return StoreProduct(
                        id: id,
                        title: title,
                        price: priceString,
                        imageURL: imageURL
                    )
                }
                
                DispatchQueue.main.async {
                    self?.readyToShipProducts = mapped
                }
            } catch {
                print("JSON parsing error:", error)
            }
        }
        .resume()
    }
    
    func fetchAllProducts() {
        guard let url = URL(string: "https://hickscreations.myshopify.com/api/2024-10/graphql.json") else {
            return
        }

        let query = """
        {
          products(first: 50) {
            edges {
              node {
                id
                title
                priceRange {
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                }
                images(first: 1) {
                  edges {
                    node {
                      url
                    }
                  }
                }
              }
            }
          }
        }
        """

        let body: [String: Any] = ["query": query]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("581b67b712281074065061bb48ff2d03",
                         forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }

            do {
                let raw = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                guard
                    let dataDict = raw?["data"] as? [String: Any],
                    let products = dataDict["products"] as? [String: Any],
                    let edges = products["edges"] as? [[String: Any]]
                else {
                    print("Unexpected JSON shape for all products")
                    return
                }

                let mapped: [StoreProduct] = edges.compactMap { edge in
                    guard
                        let node = edge["node"] as? [String: Any],
                        let id = node["id"] as? String,
                        let title = node["title"] as? String,
                        let priceRange = node["priceRange"] as? [String: Any],
                        let minVariantPrice = priceRange["minVariantPrice"] as? [String: Any],
                        let amountString = minVariantPrice["amount"] as? String,
                        let currency = minVariantPrice["currencyCode"] as? String
                    else {
                        return nil
                    }

                    let amount = Double(amountString) ?? 0
                    let formattedAmount = String(format: "%.2f", amount)
                    let priceString = "\(formattedAmount) \(currency)"

                    var imageURL: URL? = nil
                    if
                        let images = node["images"] as? [String: Any],
                        let imgEdges = images["edges"] as? [[String: Any]],
                        let firstEdge = imgEdges.first,
                        let imgNode = firstEdge["node"] as? [String: Any],
                        let urlString = imgNode["url"] as? String
                    {
                        imageURL = URL(string: urlString)
                    }

                    return StoreProduct(
                        id: id,
                        title: title,
                        price: priceString,
                        imageURL: imageURL
                    )
                }

                DispatchQueue.main.async {
                    self?.allProducts = mapped
                }
            } catch {
                print("JSON parsing error (all products):", error)
            }
        }
        .resume()
    }
    
    func fetchProductsForCollection(handle: String,
                                    completion: @escaping ([StoreProduct]) -> Void) {
        guard let url = URL(string: "https://hickscreations.myshopify.com/api/2024-10/graphql.json") else {
            return
        }

        let query = """
        {
          collection(handle: "\(handle)") {
            products(first: 50) {
              edges {
                node {
                  id
                  title
                  priceRange {
                    minVariantPrice {
                      amount
                      currencyCode
                    }
                  }
                  images(first: 1) {
                    edges {
                      node {
                        url
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """

        let body: [String: Any] = ["query": query]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("581b67b712281074065061bb48ff2d03",
                         forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let raw = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                guard
                    let dataDict = raw?["data"] as? [String: Any],
                    let collection = dataDict["collection"] as? [String: Any],
                    let products = collection["products"] as? [String: Any],
                    let edges = products["edges"] as? [[String: Any]]
                else {
                    print("Unexpected JSON shape for collection \(handle)")
                    return
                }

                let mapped: [StoreProduct] = edges.compactMap { edge in
                    guard
                        let node = edge["node"] as? [String: Any],
                        let id = node["id"] as? String,
                        let title = node["title"] as? String,
                        let priceRange = node["priceRange"] as? [String: Any],
                        let minVariantPrice = priceRange["minVariantPrice"] as? [String: Any],
                        let amountString = minVariantPrice["amount"] as? String,
                        let currency = minVariantPrice["currencyCode"] as? String
                    else {
                        return nil
                    }

                    let amount = Double(amountString) ?? 0
                    let formattedAmount = String(format: "%.2f", amount)
                    let priceString = "\(formattedAmount) \(currency)"

                    var imageURL: URL? = nil
                    if
                        let images = node["images"] as? [String: Any],
                        let imgEdges = images["edges"] as? [[String: Any]],
                        let firstEdge = imgEdges.first,
                        let imgNode = firstEdge["node"] as? [String: Any],
                        let urlString = imgNode["url"] as? String
                    {
                        imageURL = URL(string: urlString)
                    }

                    return StoreProduct(
                        id: id,
                        title: title,
                        price: priceString,
                        imageURL: imageURL
                    )
                }

                DispatchQueue.main.async {
                    // self?.collectionProducts = mapped    //  remove or comment this line
                    completion(mapped)
                }
            } catch {
                print("JSON parsing error (collection \(handle)):", error)
            }
        }
        .resume()
    }
}


  




