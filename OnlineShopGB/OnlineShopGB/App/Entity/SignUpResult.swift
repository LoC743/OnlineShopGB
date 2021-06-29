//
//  SignUpResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Foundation

struct SignUpResult: Codable {
    let result: Int
    let userMessage: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case userMessage = "user_message"
    }
}
