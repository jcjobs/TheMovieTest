//
//  ServiceConnector.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import Foundation

protocol ServiceProtocol {
    func makeRequest(with request: Constants.Request, completion: @escaping(Result<Data, CustomError>) -> Void )
}

class ServiceConnector: ServiceProtocol {
    
    private var isConnectedToNetwork: Bool {
        Reachability.isConnectedToNetwork()
    }
    
    func makeRequest(with request: Constants.Request, completion: @escaping(Result<Data, CustomError>) -> Void ) {
        guard isConnectedToNetwork else {
            completion(.failure(.internetConnection))
            return
        }
        
        guard let finalRequest = URL(string: request.urlString) else {
            completion(.failure(.badUrl))
            return
        }

        let session = URLSession.shared
        var urlRequest = URLRequest(url: finalRequest)
        if request.requestType == "POST" {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: request.params, options: []) else {
                completion(.failure(.badRequest))
                return
            }

            urlRequest.httpBody = httpBody
        }

        urlRequest.httpMethod = request.requestType
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: urlRequest) { (data, response, error) in
            let response = response as? HTTPURLResponse
            
            if let someError = error {
                completion(.failure(.custom(code: response?.statusCode ?? 0, message: someError.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.parsing))
                return
            }
            
            if let result = String(data: data, encoding: .utf8) {
               print(result)
            }
            
            if response?.statusCode == 200 {
                completion(.success(data))
            } else {
                do {
                    let decoder = JSONDecoder()
                    let errorData = try decoder.decode(ErrorData.self, from: data)
                    completion(.failure(.custom(code: response?.statusCode ?? 0, message: errorData.statusMessage)))
                } catch {
                    completion(.failure(.custom(code: response?.statusCode ?? 0, message: "Bad request")))
                }
            }
        }.resume()
    }
}
