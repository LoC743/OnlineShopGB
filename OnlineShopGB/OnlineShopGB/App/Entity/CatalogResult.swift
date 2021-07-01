//
//  CatalogResult.swift
//  OnlineShopGB
//
//  Created by Alexey on 25.06.2021.
//

import Foundation


struct ProductResult: Codable {
    let id: Int
    let name: String
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name = "product_name"
        case price
    }
}
