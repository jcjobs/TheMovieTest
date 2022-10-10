//
//  DequeableCell.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import UIKit

protocol DequeableCell {
    static var reuseIdentifier: String { get }
}

extension DequeableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
