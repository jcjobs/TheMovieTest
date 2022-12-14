//
//  CoreSession.swift
//  TheMovieTest
//
//  Created by Juan Carlos Pérez Delgadillo on 13/12/22.
//

import Foundation

public final class CoreSession {
    public static let shared = CoreSession()
    public var requestToken: String = ""
    public var sessionId: String = ""
    
    public func clearSession() {
        requestToken = ""
        sessionId = ""
    }
}
