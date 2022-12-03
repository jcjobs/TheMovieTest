//
//  ServiceConnector.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation
import Combine

protocol ServiceProtocol {
    func makeRequest<T: Decodable>(request: Constants.Request, type: T.Type) -> AnyPublisher<T, Error>
}

class ServiceConnector: ServiceProtocol {
    private var cancellable: AnyCancellable?
    private var isConnectedToNetwork: Bool {
        Reachability.isConnectedToNetwork()
    }
    
    func makeRequest<T: Decodable>(request: Constants.Request, type: T.Type) -> AnyPublisher<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self, let finalRequest = URL(string: request.urlString) else {
                return promise(.failure(CustomError.invalidURL))
            }
            
            guard self.isConnectedToNetwork else {
                promise(.failure(CustomError.internetConnection))
                return
            }
            
            var urlRequest = URLRequest(url: finalRequest)
            if request.requestType == "POST" {
                guard let httpBody = try? JSONSerialization.data(withJSONObject: request.params, options: []) else {
                    return promise(.failure(CustomError.invalidURL))
                }
                
                urlRequest.httpBody = httpBody
            }
            
            urlRequest.httpMethod = request.requestType
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            debugPrint("URL is \(finalRequest.absoluteString)")
            self.cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw CustomError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as CustomError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(CustomError.unknown))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
        }
        .eraseToAnyPublisher()
    }
}
