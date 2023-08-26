//
//  NetworkManager.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadMainPage(completion: @escaping (Result<MainPageModel, Error>) -> Void)
    func loadDetails(id: String, completion: @escaping (Result<DetailsPageModel, Error>) -> Void)
}

final class NetworkManager {
    private lazy var session = URLSession(configuration: .default)
    private lazy var decoder = JSONDecoder()
    
    deinit {
        session.invalidateAndCancel()
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func loadMainPage(completion: @escaping (Result<MainPageModel, Error>) -> Void) {
        performRequest(.mainPage, completion: completion)
    }
    
    func loadDetails(id: String, completion: @escaping (Result<DetailsPageModel, Error>) -> Void) {
        performRequest(.details(id: id), completion: completion)
    }
}

private extension NetworkManager {
    
    func performRequest<U: Codable>(
        _ configuration: APIConfiguration,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        
        guard let requestUrl = URL(string: configuration.baseURL) else {
            return completion(.failure(NSError()))
        }
        
        var request = URLRequest(
            url: requestUrl.appendingPathComponent(configuration.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: configuration.timeout
        )
        
        request.httpMethod = configuration.httpMethod
        
        let task = session.dataTask(with: request) { [weak self] result in
            guard let self = self else { return completion(.failure(NSError())) }
            
            switch result {
            case let .success(data):
                let responce = self.decoder.parse(of: U.self, from: data)
                completion(responce)
            case let .failure(error):
                completion(.failure(error))
            }
        }
            
        task.resume()
    }
}

extension JSONDecoder {
    func parse<T: Decodable>(of type: T.Type, from data: Data) -> Result<T, Error> {
        do {
            return .success(try decode(T.self, from: data))
        } catch {
            return .failure(error)
        }
    }
}
