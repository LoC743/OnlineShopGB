//
//  Product.swift
//  OnlineShopGB
//
//  Created by Alexey on 25.06.2021.
//

import Alamofire

class Product: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl: URL
    
    init(
        baseURL: URL,
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)
    ) {
        self.baseUrl = URL(string: baseURL.absoluteString + "product/")!
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Product: ProductRequestFactory {
    func catalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void) {
        let requestModel = Catalog(baseUrl: self.baseUrl)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func product(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void) {
        let requestModel = Good(baseUrl: self.baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Product {
    struct Catalog: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "catalog"
    
        var parameters: Parameters?
    }
    
    struct Good: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "good"
    
        let id: Int
        
        var parameters: Parameters? {
            return [
                "product_id": id
            ]
        }
    }
}

