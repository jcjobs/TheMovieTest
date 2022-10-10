//
//  Movie.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import Foundation

struct Movie: Codable {
    let title: String
    let popularity: Double
    let movieID: Int
    let voteCount: Int
    let originalTitle: String
    let voteAverage: Double
    let sinopsis: String
    let releaseDate: String?
    let image: String?
    let productionCompanies: [Company]?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case title, popularity, genres
        case movieID = "id"
        case voteCount = "vote_count"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case sinopsis = "overview"
        case releaseDate = "release_date"
        case image = "poster_path"
        case productionCompanies = "production_companies"
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
}
