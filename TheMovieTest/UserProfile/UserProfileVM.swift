//
//  UserProfileVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import Foundation


protocol UserProfileVMProtocol: BaseProtocol {
    var didFetchData: (() -> Void)? { get set }
    var processError: ((CustomError) -> ())? { get set }

    func fetchProfileData()
}

class UserProfileVM: UserProfileVMProtocol {
    var isLoading: ((Bool) -> ())?
    var didFetchData: (() -> Void)?
    var processError: ((CustomError) -> ())?
    
    func fetchProfileData() {
        isLoading?(true)
        LoginService().getUserProfile() { [weak self] result in
            self?.isLoading?(false)
            switch result {
            case .success(let sucess):
                self?.didFetchData?()
                
            case .failure(let error):
                self?.processError?(error)
            }
        }
    }
    
}
