//
//  TokenManager.swift
//  cost-curve-ios
//
//  Created by Clayton Thompson on 3/9/25.
//
import SwiftUI

class TokenManager {
    static let shared = TokenManager()

    private let tokenKey = "authToken"

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
}
