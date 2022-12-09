//
//  MovieDetailVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import Foundation
import Combine
import CoreComponents

protocol MovieDetailVMProtocol: BaseProtocol {
    var didFetchData: PassthroughSubject<Movie, Never> { get }
    var processError: PassthroughSubject<CustomError, Never> { get }
    
    func getDetail(with movieId: Int)
}

class MovieDetailVM: MovieDetailVMProtocol {
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var didFetchData = PassthroughSubject<Movie, Never>()
    var processError = PassthroughSubject<CustomError, Never>()
    private var service = MoviesService()
    private var cancellable: AnyCancellable?

    func getDetail(with movieId: Int) {
        isLoading.send(true)
        cancellable = service.getDetailCO(with: movieId)
            .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                print("Error is \(error.localizedDescription)")
                self?.processError.send(error)
            case .finished:
                print("Finished")
            }
            self?.isLoading.send(false)
        } receiveValue: { [weak self] movies in
            self?.didFetchData.send(movies)
        }
    }
}
