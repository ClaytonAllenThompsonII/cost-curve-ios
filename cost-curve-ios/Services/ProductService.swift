//
//  ProductService.swift
//  cost-curve-ios
//
//  Created by Clayton Thompson on 3/9/25.
//

import Foundation

struct ProductClassification: Codable {
    let classification_id: Int
    let name: String
    // ... match your DRF serializer fields
    // Provide an 'id' property so SwiftUI knows each item's unique ID
    var id: Int { classification_id }
}

class ProductService {
    static let shared = ProductService()

    func fetchProductClassifications(completion: @escaping ([ProductClassification]) -> Void) {
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            completion([])
            return
        }
        guard let url = URL(string: "http://127.0.0.1:8000/api/productclassifications/") else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching product classifications: \(error)")
                completion([])
                return
            }
            guard let data = data else {
                print("No data")
                completion([])
                return
            }
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([ProductClassification].self, from: data)
                completion(products)
            } catch {
                print("JSON decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
}
