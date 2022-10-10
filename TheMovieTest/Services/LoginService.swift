//
//  LoginService.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

class LoginService {
    private let service: ServiceProtocol
    
    init() {
        service = ServiceConnector()
    }

    func makeLogin(with username: String, password: String, completion: @escaping(Result<Bool, CustomError>) -> Void ) {
        requestToken { [weak self] result in
            switch result {
            case .success(_):
                self?.completeLogin(with: username, password: password, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func completeLogin(with username: String, password: String, completion: @escaping(Result<Bool, CustomError>) -> Void ) {
        service.makeRequest(with: .login(username: username, pass: password)) { [weak self] result in
            switch result {
            case .success(let loginResult):
                do {
                    let decoder = JSONDecoder()
                    let loginData = try decoder.decode(LoginData.self, from: loginResult)
                    if loginData.success {
                        self?.createSession(completion: completion)
                    } else {
                        completion(.failure(.loginFailed(message: "Bad request")))
                    }
    
                } catch {
                    completion(.failure(.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestToken(completion: @escaping(Result<Bool, CustomError>) -> Void ) {
        service.makeRequest(with: .requestToken) { result in
            switch result {
            case .success(let tokenResponse):
                do {
                    let decoder = JSONDecoder()
                    let loginData = try decoder.decode(LoginData.self, from: tokenResponse)
                    Session.shared.requestToken = loginData.requestToken
                    completion(.success(true))
                    
                } catch {
                    completion(.failure(.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createSession(completion: @escaping(Result<Bool, CustomError>) -> Void ) {
        service.makeRequest(with: .sesion) { result in
            switch result {
            case .success(let tokenResponse):
                do {
                    let decoder = JSONDecoder()
                    let loginData = try decoder.decode(SessionData.self, from: tokenResponse)
                    Session.shared.sessionId = loginData.sessionId
                    completion(.success(loginData.success))
                    
                } catch {
                    completion(.failure(.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserProfile(completion: @escaping(Result<Bool, CustomError>) -> Void ) {
        service.makeRequest(with: .profile) { result in
            switch result {
            case .success(let profileResult):
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UserData.self, from: profileResult)
                    Session.shared.user = userData
                    completion(.success(true))
                    
                } catch {
                    completion(.failure(CustomError.parsing))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
