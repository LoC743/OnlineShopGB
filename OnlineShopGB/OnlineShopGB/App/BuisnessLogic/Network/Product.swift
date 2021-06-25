//
//  Product.swift
//  OnlineShopGB
//
//  Created by Alexey on 25.06.2021.
//

import Alamofire

class Product {

}

extension Product: ProductRequestFactory {
    func catalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void) {
        let catalog = [
            ProductResult(id: 123, name: "Ноутбук", price: 45600),
            ProductResult(id: 456, name: "Мышка", price: 1000),
        ]
        let result = Result<[ProductResult], AFError>.success(catalog)
        let response = AFDataResponse<[ProductResult]>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        completionHandler(response)
    }
    
    func product(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void) {
        let good = GoodResult(result: 1, name: "Ноутбук", price: 45600, description: "Мощный игровой ноутбук")
        let result = Result<GoodResult, AFError>.success(good)
        let response = AFDataResponse<GoodResult>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        completionHandler(response)
    }
}
