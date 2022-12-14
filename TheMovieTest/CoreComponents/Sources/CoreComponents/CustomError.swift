//
//  CustomError.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

public enum CustomError: Error {
    case internetConnection
    case badUrl
    case badRequest
    case custom(code: Int, message: String)
    case loginFailed(message: String)
    case parsing
    case rageOutOfIndex
    
    case invalidURL
    case responseError(message: String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .custom(let code, let message):
            return NSLocalizedString("CustomError_Custom", comment: "\(message) \nError code: \(code)")
            
        case .badUrl:
            return NSLocalizedString("CustomError_BadUrl", comment: "Bad URL")
            
        case .rageOutOfIndex:
            return NSLocalizedString("CustomError_RageOutOfIndex", comment: "No more items to fetch")
            
        case .parsing:
            return NSLocalizedString("CustomError_Parsing", comment: "Bad result")
            
        case .internetConnection:
            return NSLocalizedString("CustomError_InternetConnection", comment: "The internet connection appears to be offline")
            
        case .invalidURL:
            return NSLocalizedString("CustomError_InvalidURL", comment: "Invalid URL")
            
        case .responseError(let message):
            return NSLocalizedString("CustomError_ResponseError", comment: "Invalid response: \(message)")
            
        case .unknown:
            return NSLocalizedString("CustomError_Unknown", comment: "Unknown error")
            
        case .badRequest:
            return NSLocalizedString("CustomError_BadRequest", comment: "Invalid request")
            
        case .loginFailed(message: let message):
            return NSLocalizedString("CustomError_LoginFailed", comment: message)
        }
    }
}
