//
//  APIConfiguration.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import Foundation

/// Конфигурация для API
enum APIConfiguration {

    /// Получение главной страницы
    case mainPage
    
    /// Получение деталей товара
    case details(id: String)
}

extension APIConfiguration {
    var baseURL: String {
        "https://www.avito.st"
    }
    
    var path: String {
        let base = "s/interns-ios"
        
        switch self {
        case .mainPage:
            return base + "/main-page.json"
        case let .details(id):
            return base + "/details/\(id).json"
        }
    }
    
    var httpMethod: String {
        "GET"
    }
    
    var timeout: TimeInterval {
        15
    }
}
