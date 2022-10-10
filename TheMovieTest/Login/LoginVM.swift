//
//  LoginVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

protocol LoginProtocol: BaseProtocol {
    var loginSucced: ((Bool) -> ())? { get set }
    var processError: ((CustomError) -> ())? { get set }

    func makeLogin(with user: String, and password: String)
}

class LoginVM: LoginProtocol {
    var isLoading: ((Bool) -> ())?
    var loginSucced: ((Bool) -> ())?
    var processError: ((CustomError) -> ())?
    private var service = LoginService()
    
    func makeLogin(with user: String, and password: String) {
        isLoading?(true)
        service.makeLogin(with: user, password: password) { [weak self] result in
            self?.isLoading?(false)
            switch result {
            case .success(let succed):
                self?.loginSucced?(succed)
                
            case .failure(let error):
                self?.processError?(error)
            }
        }
    }
}
