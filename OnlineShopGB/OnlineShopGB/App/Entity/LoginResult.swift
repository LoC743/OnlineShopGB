//
//  LoginResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Foundation

struct LoginResult: Codable {
    let result: Int
    let user: User?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case user
        case errorMessage = "error_message"
    }
}
