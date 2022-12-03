//
//  DyamicScreenVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine

protocol DyamicScreenProtocol: BaseProtocol {
    var didFetchData: PassthroughSubject<[Movie]?, Never> { get }
    var processError: PassthroughSubject<CustomError, Never> { get }
    
    init(with key: Constants.MovieType)
    func fetchMovies()
    func fetchMoviewPagination()
}

class DyamicScreenVM: DyamicScreenProtocol {
    private let service = MoviesService()
    private var pageKey: Constants.MovieType
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var didFetchData = PassthroughSubject<[Movie]?, Never>()
    var processError = PassthroughSubject<CustomError, Never>()
    private var cancellable: AnyCancellable?

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
        isLoading.send(true)
        cancellable = service.fetchMoviesCO(with: pageKey, and: fromScratch)
            .sink { [weak self] completion in
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
                self?.processError.send(.badRequest)
            case .finished:
                print("Finished")
            }
            self?.isLoading.send(false)
        } receiveValue: { [weak self] movies in
            self?.didFetchData.send(movies)
        }
    }
    
}
