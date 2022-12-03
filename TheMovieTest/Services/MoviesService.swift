//
//  MoviesService.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine

class MoviesService {
    private let service: ServiceProtocol
    private var pageIndex: Int = 1
    private var hastNextPage: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service = ServiceConnector()
    }

    func fetchMoviesCO(with movieType: Constants.MovieType, and fromScratch: Bool) -> AnyPublisher<[Movie], Error> {
        return Future<[Movie], Error> { promise in
            if fromScratch {
                self.pageIndex = 1
            } else {
                guard self.hastNextPage else {
                    promise(.failure(CustomError.rageOutOfIndex))
                    return
                }
                self.pageIndex += 1
            }
            
            self.service.makeRequest(request: .movies(type: movieType, page: self.pageIndex), type: Movies.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("fetchMoviesCO: Error is \(err.localizedDescription)")
                    promise(.failure(err))
                case .finished:
                    debugPrint("fetchMoviesCO: finished")
                }
            }
            receiveValue: { movies in
                self.hastNextPage = movies.totalPages > self.pageIndex
                promise(.success(movies.listOfmovies))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func getDetailCO(with movieId: Int) ->  AnyPublisher<Movie, Error> {
        return Future<Movie, Error> { promise in
            self.service.makeRequest(request: .movieDetail(movieId: movieId), type: Movie.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("getDetailCO: Error is \(err.localizedDescription)")
                    promise(.failure(err))
                case .finished:
                    debugPrint("getDetailCO: finished")
                }
            }
            receiveValue: { movie in
                promise(.success(movie))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}
