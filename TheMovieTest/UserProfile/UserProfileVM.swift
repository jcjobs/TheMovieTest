//
//  UserProfileVM.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import Foundation
import Combine
import CoreComponents

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

    func fetchProfileData() {
        isLoading.send(true)
        Task {
            do {
                let getUserProfile: Void = try await service.getUserProfile()
                print("getUserProfile result: \(getUserProfile)")
                didFetchData.send(getUserProfile)
            } catch {
                print("getUserProfile failed with error \(error)")
                processError.send(.badRequest)
            }
            print("getUserProfile isLoading false")
            isLoading.send(false)
        }
    }
    
}
