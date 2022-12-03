//
//  CustomError.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

enum CustomError: Error {
    case internetConnection
    case badUrl
    case badRequest
    case custom(code: Int, message: String)
    case loginFailed(message: String)
    case parsing
    case rageOutOfIndex
    
    case invalidURL
    case responseError
    case unknown

    var errorDescription: String? {
        switch self {
        case .custom(let code, let message):
            return NSLocalizedString("\(message) \nError code: \(code)", comment: "\(message) \nError code: \(code)")
            
        case .badUrl:
            return NSLocalizedString("Bad URL", comment: "Bad URL")
            
        case .rageOutOfIndex:
            return NSLocalizedString("No more items to fetch", comment: "No more items to fetch")
            
        case .parsing:
            return NSLocalizedString("Bad result", comment: "Bad result")
            
        case .internetConnection:
            return NSLocalizedString("The internet connection appears to be offline", comment: "The internet connection appears to be offline")
            
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
            
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
            
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
            
        case .badRequest:
            return NSLocalizedString("Unexpected status code", comment: "Invalid request")
            
        case .loginFailed(message: let message):
            return NSLocalizedString(message, comment: message)
        }
    }
}
