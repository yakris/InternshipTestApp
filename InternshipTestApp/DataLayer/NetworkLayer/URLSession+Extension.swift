//
//  URLSession+Extension.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import Foundation

extension URLSession {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response, let data = data else {
                let error = URLError(.badServerResponse)
                return completion(.failure(error))
            }
            
            guard let statusCode: Int = (response as? HTTPURLResponse)?.statusCode else {
                let error = URLError(.badServerResponse)
                return completion(.failure(error))
            }
            
            if let error = self?.handleNetworkResponse(statusCode) {
                completion(.failure(error))
            }
            
            completion(.success(data))
        }
    }
}

// MARK: - Helpers

private extension URLSession {
    func handleNetworkResponse(_ statusCode: Int) -> Error? {
        switch statusCode {
        case 200...299:
            return nil
        default:
            return URLError(.badServerResponse)
        }
    }
}
