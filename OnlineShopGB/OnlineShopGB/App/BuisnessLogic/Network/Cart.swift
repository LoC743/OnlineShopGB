//
//  Cart.swift
//  OnlineShopGB
//
//  Created by Alexey on 06.07.2021.
//

import Alamofire

class Cart: AbstractRequestFactory {
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
        self.baseUrl = URL(string: baseURL.absoluteString + "cart/")!
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Cart: CartRequestFactory {
    func add(userID: Int, productID: Int, quantity: Int, completionHandler: @escaping (AFDataResponse<AddCartResult>) -> Void) {
        let requestModel = Add(baseUrl: self.baseUrl, userID: userID, productID: productID, quantity: quantity)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func get(userID: Int, completionHandler: @escaping (AFDataResponse<GetCartResult>) -> Void) {
        let requestModel = Get(baseUrl: self.baseUrl, userID: userID)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func remove(userID: Int, productID: Int, completionHandler: @escaping (AFDataResponse<RemoveCartResult>) -> Void) {
        let requestModel = Remove(baseUrl: self.baseUrl, userID: userID, productID: productID)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func pay(userID: Int, money: Int, completionHandler: @escaping (AFDataResponse<PayCartResult>) -> Void) {
        let requestModel = Pay(baseUrl: self.baseUrl, userID: userID, money: money)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Cart {
    struct Add: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "add"
    
        let userID: Int
        let productID: Int
        let quantity: Int
        
        var parameters: Parameters? {
            return [
                "user_id": userID,
                "product_id": productID,
                "quantity": quantity
            ]
        }
    }
    
    struct Get: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = ""
    
        let userID: Int
        
        var parameters: Parameters? {
            return [
                "user_id": userID
            ]
        }
    }
    
    struct Remove: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "remove"
    
        let userID: Int
        let productID: Int
        
        var parameters: Parameters? {
            return [
                "user_id": userID,
                "product_id": productID
            ]
        }
    }
    
    struct Pay: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "pay"
        
        let userID: Int
        let money: Int
        
        var parameters: Parameters? {
            return [
                "avaliable_money": money,
                "user_id": userID
            ]
        }
    }
}


