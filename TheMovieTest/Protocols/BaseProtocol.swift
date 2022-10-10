//
//  BaseProtocol.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

protocol BaseProtocol {
    var isLoading: ((Bool) -> ())? { get set }
}
