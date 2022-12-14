//
//  Session.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

final class Session {
    static let shared = Session()
    var user: UserData? = nil
    
    func clearSession() {
        user = nil
    }
}
