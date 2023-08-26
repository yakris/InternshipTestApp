//
//  DetailsPageModel.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

/// Модель ячейки карточки товара
struct DetailsPageModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case location
        case imageUrl = "image_url"
        case createdDate = "created_date"
        case description
        case email
        case phoneNumber = "phone_number"
        case address
    }
    
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}
