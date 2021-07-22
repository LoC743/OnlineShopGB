//
//  User.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let password: String
    let firstname: String
    let lastname: String
    let email: String
    let gender: String
    let creditCard: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case username
        case password
        case firstname = "first_name"
        case lastname = "last_name"
        case email
        case gender
        case creditCard = "credit_card"
        case bio
    }
}
