//
//  MainPageModel.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

/// Модель главного экрана
struct MainPageModel: Codable {
    let advertisements: [AdvertisementModel]
}

/// Модель ячейки главного экрана
struct AdvertisementModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case location
        case imageUrl = "image_url"
        case createdDate = "created_date"
    }
    
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
}
