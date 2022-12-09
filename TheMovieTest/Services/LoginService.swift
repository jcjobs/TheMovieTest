//
//  LoginService.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine
import CoreComponents

class LoginService {
    private let service: ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service = ServiceConnector()
    }
    
    func makeLoginCO(with username: String, and password: String) -> AnyPublisher<Void, CustomError> {
        return Future<Void, CustomError> { promise in
            self.requestTokenCO()
                .flatMap { _ in self.loginRequest(with: username, and: password) }
                .flatMap { _ in self.createSesionCO() }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        debugPrint("makeLogin Error is \(error.localizedDescription)")
                        promise(.failure(.loginFailed(message: error.localizedDescription)))
                    case .finished:
                        debugPrint("makeLogin Finished")
                    }
                },receiveValue: { _ in
                    promise(.success(()))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    private func requestTokenCO2() -> AnyCancellable {
        return self.service.makeRequest(request: .requestToken, type: LoginData.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("Error is \(err.localizedDescription)")
                case .finished:
                    debugPrint("Finished")
                }
            }
            receiveValue: { loginData in
                CoreSession.shared.requestToken = loginData.requestToken
            }
    }
    
    //1.-
    private func requestTokenCO() -> AnyPublisher<Bool, CustomError>{
        debugPrint("requestTokenCO...")
        return Future<Bool, CustomError> { promise in
            self.service.makeRequest(request: .requestToken, type: LoginData.self)
                .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("requestTokenCO: Error is \(error.localizedDescription)")
                    promise(.failure(.responseError(message: error.localizedDescription)))
                case .finished:
                    debugPrint("requestTokenCO: finished")
                }
            }
            receiveValue: { loginData in
                CoreSession.shared.requestToken = loginData.requestToken
                promise(.success(true))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    //2.-
    private func loginRequest(with username: String, and password: String) -> AnyPublisher<Bool, CustomError> {
        debugPrint("loginRequest...")
        return Future<Bool, CustomError> { promise in
            self.service.makeRequest(request: .login(username: username, pass: password), type: LoginData.self)
                .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("loginRequest: Error is \(error.localizedDescription)")
                    promise(.failure(.responseError(message: error.localizedDescription)))
                case .finished:
                    debugPrint("loginRequest: Finished")
                }
            }
            receiveValue: { loginData in
                promise(.success(true))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    //3.-
    //func createSesionCO() -> Future<Bool, Error> {
    private func createSesionCO() -> AnyPublisher<Bool, CustomError> {
        debugPrint("createSesionCO...")
        return Future<Bool, CustomError> { promise in
            self.service.makeRequest(request: .sesion, type: SessionData.self)
                .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("createSesionCO: Error is \(error.localizedDescription)")
                    promise(.failure(.responseError(message: error.localizedDescription)))
                case .finished:
                    debugPrint("createSesionCO: Finished")
                }
            }
            receiveValue: { loginData in
                //Session.shared.sessionId = loginData.sessionId
                CoreSession.shared.sessionId = loginData.sessionId
                promise(.success(true))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }

    func getUserProfileCO() -> AnyPublisher<Void, CustomError> {
        debugPrint("getUserProfileCO...")
        return Future<Void, CustomError> { promise in
            self.service.makeRequest(request: .profile, type: UserData.self)
                .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("getUserProfileCO: Error is \(error.localizedDescription)")
                    promise(.failure(.responseError(message: error.localizedDescription)))
                case .finished:
                    debugPrint("getUserProfileCO: Finished")
                }
            }
            receiveValue: { userData in
                Session.shared.user = userData
                promise(.success(()))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func getUserProfile() async throws -> Void {
        debugPrint("getUserProfile...")
        return try await withCheckedThrowingContinuation { continuation in
            self.service.makeRequest(request: .profile, type: UserData.self)
                .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("getUserProfile: Error is \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    
                case .finished:
                    debugPrint("getUserProfile: Finished")
                }
            }
            receiveValue: { userData in
                Session.shared.user = userData
                continuation.resume(returning: ())
            }.store(in: &self.cancellables)
        }
    }
}
