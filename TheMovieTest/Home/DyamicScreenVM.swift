//
//  DyamicScreenVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

protocol DyamicScreenProtocol: BaseProtocol {
    var didFetchData: (([Movie]?) -> Void)? { get set }
    var processError: ((CustomError) -> ())? { get set }

    
    init(with key: Constants.MovieType)
    func fetchMovies()
    func fetchMoviewPagination()
}

class DyamicScreenVM: DyamicScreenProtocol {
    private let service = MoviesService()
    private var pageKey: Constants.MovieType
    var isLoading: ((Bool) -> ())?
    var didFetchData: (([Movie]?) -> Void)?
    var processError: ((CustomError) -> ())?

    required init(with key: Constants.MovieType) {
        pageKey = key
    }
    
    func fetchMovies() {
        getMovieList(fromScratch: true)
    }
    
    func fetchMoviewPagination() {
        getMovieList(fromScratch: false)
    }
    
    private func getMovieList(fromScratch: Bool) {
        isLoading?(true)
        service.fetchMovies(with: pageKey, and: fromScratch) { [weak self] result in
            self?.isLoading?(false)
            switch result {
            case .success(let movies):
                self?.didFetchData?(movies)
                
            case .failure(let error):
                self?.processError?(error)
            }
        }
    }
    
}
