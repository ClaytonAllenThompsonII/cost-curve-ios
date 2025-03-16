//
//  AuthService.swift
//  cost-curve-ios
//
//  Created by Clayton Thompson on 3/9/25.
//

import Foundation

class AuthService {
    static let shared = AuthService()

    private init() {}

    /// Logs in with username/password, returns token if successful
    func login(username: String, password: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api-token-auth/") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login error: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }

            do {
                // Parse JSON: e.g. {"token": "abcd1234"}
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(token)
                } else {
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
