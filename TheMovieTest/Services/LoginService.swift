//
//  LoginService.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine

class LoginService {
    private let service: ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service = ServiceConnector()
    }
    
    func makeLoginCO(with username: String, and password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.requestTokenCO()
                .flatMap { _ in self.loginRequest(with: username, and: password) }
                .flatMap { _ in self.createSesionCO() }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let err):
                        debugPrint("makeLogin Error is \(err.localizedDescription)")
                        promise(.failure(err))
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
                Session.shared.requestToken = loginData.requestToken
            }
    }
    
    //1.-
    private func requestTokenCO() -> AnyPublisher<Bool, Error>{
        debugPrint("requestTokenCO...")
        return Future<Bool, Error> { promise in
            self.service.makeRequest(request: .requestToken, type: LoginData.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("requestTokenCO: Error is \(err.localizedDescription)")
                    promise(.failure(err))
                case .finished:
                    debugPrint("requestTokenCO: finished")
                }
            }
            receiveValue: { loginData in
                Session.shared.requestToken = loginData.requestToken
                promise(.success(true))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    //2.-
    private func loginRequest(with username: String, and password: String) -> AnyPublisher<Bool, Error> {
        debugPrint("loginRequest...")
        return Future<Bool, Error> { promise in
            self.service.makeRequest(request: .login(username: username, pass: password), type: LoginData.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("loginRequest: Error is \(err.localizedDescription)")
                    promise(.failure(err))
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
    private func createSesionCO() -> AnyPublisher<Bool, Error> {
        debugPrint("createSesionCO...")
        return Future<Bool, Error> { promise in
            self.service.makeRequest(request: .sesion, type: SessionData.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("createSesionCO: Error is \(err.localizedDescription)")
                    promise(.failure(err))
                case .finished:
                    debugPrint("createSesionCO: Finished")
                }
            }
            receiveValue: { loginData in
                Session.shared.sessionId = loginData.sessionId
                promise(.success(true))
            }.store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }

    private func getUserProfileCO() -> AnyPublisher<Void, Error> {
        debugPrint("getUserProfileCO...")
        return Future<Void, Error> { promise in
            self.service.makeRequest(request: .profile, type: UserData.self)
                .sink { completion in
                switch completion {
                case .failure(let err):
                    debugPrint("getUserProfileCO: Error is \(err.localizedDescription)")
                    promise(.failure(err))
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
}
