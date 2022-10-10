//
//  MoviesService.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

class MoviesService {
    private let service: ServiceProtocol
    private var pageIndex: Int = 1
    private var hastNextPage: Bool = false
    
    init() {
        service = ServiceConnector()
    }

    func fetchMovies(with movieType: Constants.MovieType, and fromScratch: Bool, completion: @escaping(Result<[Movie], CustomError>) -> Void ) {
        if fromScratch {
            pageIndex = 1
        } else {
            guard hastNextPage else {
                completion(.failure(.rageOutOfIndex))
                return
            }
            pageIndex += 1
        }
        
        service.makeRequest(with: .movies(type: movieType, page: pageIndex)) { [weak self] result in
            switch result {
            case .success(let dataResult):
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(Movies.self, from: dataResult)
                    self?.hastNextPage = movies.totalPages > self?.pageIndex ?? 0
                    completion(.success(movies.listOfmovies))
                } catch {
                    completion(.failure(.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDetail(with movieId: Int, completion: @escaping(Result<Movie, CustomError>) -> Void ) {
        service.makeRequest(with: .movieDetail(movieId: movieId)) { result in
            switch result {
            case .success(let dataResult):
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(Movie.self, from: dataResult)
                    completion(.success(movie))
                } catch {
                    completion(.failure(.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
