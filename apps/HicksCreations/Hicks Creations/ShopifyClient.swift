import Foundation

final class ShopifyClient {
    static let shared = ShopifyClient()

    private let storeDomain = "hickscreations.myshopify.com"
    private let accessToken = "581b67b712281074065061bb48ff2d03" // replace

    private var endpoint: URL {
        URL(string: "https://\(storeDomain)/api/2024-10/graphql.json")!
    }

    func perform<QueryResponse: Decodable>(
        query: String,
        variables: [String: Any]? = nil,
        completion: @escaping (Result<QueryResponse, Error>) -> Void
    ) {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(accessToken, forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")

        var body: [String: Any] = ["query": query]
        if let variables {
            body["variables"] = variables
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                return DispatchQueue.main.async { completion(.failure(error)) }
            }
            guard let data else {
                return DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: 0)))
                }
            }
            do {
                let decoded = try JSONDecoder().decode(QueryResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}

