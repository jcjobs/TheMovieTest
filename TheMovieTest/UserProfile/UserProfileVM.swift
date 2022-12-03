//
//  UserProfileVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import Foundation
import Combine

protocol UserProfileVMProtocol: BaseProtocol {
    var didFetchData: PassthroughSubject<Void, Never> { get }
    var processError: PassthroughSubject<CustomError, Never> { get }

    func fetchProfileData()
}

class UserProfileVM: UserProfileVMProtocol {
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var didFetchData = PassthroughSubject<Void, Never>()
    var processError = PassthroughSubject<CustomError, Never>()
    
    private let service = LoginService()
    private var cancellable: AnyCancellable?
    
    func fetchProfileData() {
        isLoading.send(true)
        cancellable = service.getUserProfileCO()
            .sink { [weak self] completion in
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
                self?.processError.send(.badRequest)
            case .finished:
                print("Finished")
            }
            self?.isLoading.send(false)
        } receiveValue: { [weak self] _ in
            self?.didFetchData.send(())
        }
    }
    
}
