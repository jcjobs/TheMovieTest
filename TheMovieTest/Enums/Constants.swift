//
//  Constants.swift
//  TheMovieTest
//
//  Created by Juan Carlos Pérez Delgadillo on 08/12/22.
//

import Foundation

struct Constants {
    enum MovieType: String, CaseIterable {
        case popular
        case upcoming
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
       
        public var title: String {
            switch self {
            case .topRated:
                return "Top rated"
                
            case .popular:
                return "Popular"
                
            case .nowPlaying:
                return "Now Playing"
                
            case .upcoming:
                return "Upcoming"
            }
        }
    }
}
