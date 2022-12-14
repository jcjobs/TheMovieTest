//
//  BaseProtocol.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation
import Combine

protocol BaseProtocol {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
}
