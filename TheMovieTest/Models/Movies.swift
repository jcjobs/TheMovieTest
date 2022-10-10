//
//  Movies.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

struct Movies: Codable {
    let listOfmovies: [Movie]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case listOfmovies = "results"
    }
}
