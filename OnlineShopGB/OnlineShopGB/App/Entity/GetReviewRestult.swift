//
//  GetReviewRestult.swift
//  OnlineShopGB
//
//  Created by Alexey on 02.07.2021.
//

import Foundation

struct ReviewResult: Codable {
    let userID: Int
    let productID: Int
    let commentID: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case commentID = "comment_id"
        case text
    }
}
