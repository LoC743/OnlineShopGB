//
//  RemoveCartResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 06.07.2021.
//

import Foundation

struct RemoveCartResult: Codable {
    let result: Int
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
    }
}
