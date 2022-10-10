//
//  Constants.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

struct Constants {
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "?api_key=6b8faabbb534b18b7280fc10901cb18c"
    static let image = "https://image.tmdb.org/t/p/w200"
    
    enum MovieType: String, CaseIterable {
        case popular
        case upcoming
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
       
        var title: String {
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

    enum Request {
        case requestToken
        case login(username: String, pass: String)
        case sesion
        case profile
        case movies(type: MovieType, page: Int)
        case movieDetail(movieId: Int)

        var urlString: String {
            switch self {
            case .requestToken:
                return baseUrl + "authentication/token/new" + apiKey
    
            case .login:
                return baseUrl + "authentication/token/validate_with_login" + apiKey
                
            case .sesion:
                return baseUrl + "authentication/session/new" + apiKey
                
            case .profile:
                return baseUrl + "account" + apiKey + "&session_id=\(Session.shared.sessionId)"
                
            case .movieDetail(let movieId):
                return baseUrl + "movie/\(movieId)" + apiKey
                
            case .movies(let type, let page):
                return baseUrl + "movie/\(type.rawValue)" + apiKey + "&page=\(page)"
                
            }
        }

        var requestType: String {
            switch self {
            case .login, .sesion:
                return "POST"
                
            default:
                return "GET"
            }
        }
        
        var params: [String: Any] {
            switch self {
            case .login(let userName, let password):
                return ["username": userName, "password": password, "request_token": Session.shared.requestToken]
                
            case .sesion:
                return ["request_token": Session.shared.requestToken]
                
            default:
                return [:]
            }
        }
    }
}
