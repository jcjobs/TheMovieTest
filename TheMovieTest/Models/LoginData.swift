//
//  LoginData.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

struct LoginData: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
