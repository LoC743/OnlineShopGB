//
//  ProductRequestFactory.swift
//  OnlineShopGB
//
//  Created by Alexey on 25.06.2021.
//

import Alamofire

protocol ProductRequestFactory {
    func catalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void)
    func product(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void)
}
