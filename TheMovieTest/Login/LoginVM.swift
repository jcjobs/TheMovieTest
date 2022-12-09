//
//  LoginVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine
import CoreComponents

protocol LoginProtocol: BaseProtocol {
    var loginSucced: PassthroughSubject<Void, Never> { get }
    var processError: PassthroughSubject<CustomError, Never> { get }

    func makeLogin(with user: String, and password: String)
}

class LoginVM: LoginProtocol {
    var loginSucced = PassthroughSubject<Void, Never>()
    var processError = PassthroughSubject<CustomError, Never>()
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    private var service = LoginService()
    private var cancellable: AnyCancellable?
    
    func makeLogin(with user: String, and password: String) {
        isLoading.send(true)
        cancellable = service.makeLoginCO(with: user, and: password)
            .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                debugPrint("Error is \(error.localizedDescription)")
                self?.processError.send(error)
                
            case .finished:
                debugPrint("makeLogin finished...")
            }
            self?.isLoading.send(false)
                
        } receiveValue: { [weak self] _ in
            self?.loginSucced.send(())
        }
    }
}
