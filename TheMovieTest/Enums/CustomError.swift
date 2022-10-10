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
    
    var message: String {
        switch self {
        case .custom(let code, let message):
            return  "\(message) \nError code: \(code)"
            
        case .badUrl:
            return "Bad URL"
            
        case .rageOutOfIndex:
            return "No more items to fetch"
            
        case .parsing:
           return "Bad result"
            
        case .internetConnection:
            return "The internet connection appears to be offline"
            
        default:
            return "Unknown error"

        }
    }
}
