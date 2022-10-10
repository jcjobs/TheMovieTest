//
//  MovieDetailVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import Foundation

protocol MovieDetailVMProtocol: BaseProtocol {
    var didFetchData: ((Movie) -> Void)? { get set }
    var processError: ((CustomError) -> ())? { get set }

    func getDetail(with movieId: Int)
}

class MovieDetailVM: MovieDetailVMProtocol {
    var isLoading: ((Bool) -> ())?
    var didFetchData: ((Movie) -> Void)?
    var processError: ((CustomError) -> ())?

    func getDetail(with movieId: Int) {
        isLoading?(true)
        MoviesService().getDetail(with: movieId) { [weak self] result in
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


