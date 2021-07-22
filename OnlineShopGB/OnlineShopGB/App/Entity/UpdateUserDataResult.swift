//
//  UpdateUserDataResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Foundation

struct UpdateUserDataResult: Codable {
    let result: Int
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
    }
}
