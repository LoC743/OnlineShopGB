//
//  GetCartResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 06.07.2021.
//

import Foundation

struct GetCartResult: Codable {
    let totalPrice: Int
    let count: Int
    let products: [CartProduct]
    
    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case count
        case products
    }
}

struct CartProduct: Codable {
    let productID: Int
    var quantity: Int
    let price: Int
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity
        case price
        case productName = "product_name"
    }
}
