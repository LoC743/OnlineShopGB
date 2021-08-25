//
//  CartInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import Alamofire
import SwiftyBeaver

protocol CartInteractorInput {
    func getCart(userID: Int, completionHandler: @escaping (AFDataResponse<GetCartResult>) -> Void)
    func addToCart(userID: Int, productID: Int, completionHandler: @escaping (AFDataResponse<AddCartResult>) -> Void)
    func removeFromCart(userID: Int,
                        productID: Int,
                        completionHandler: @escaping (AFDataResponse<RemoveCartResult>) -> Void)
    func payCart(userID: Int, money: Int, completionHandler: @escaping (AFDataResponse<PayCartResult>) -> Void)
}

class CartInteractor: CartInteractorInput {

    private lazy var cartService: CartRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeCartRequestFatory()
    }()
    
    
    func getCart(userID: Int, completionHandler: @escaping (AFDataResponse<GetCartResult>) -> Void) {
        SwiftyBeaver.info("CartRequestFactory.get")
        cartService.get(userID: userID, completionHandler: completionHandler)
    }
    
    func addToCart(userID: Int, productID: Int, completionHandler: @escaping (AFDataResponse<AddCartResult>) -> Void) {
        SwiftyBeaver.info("CartRequestFactory.add")
        cartService.add(userID: userID, productID: productID, quantity: 1, completionHandler: completionHandler)
    }

    func removeFromCart(userID: Int,
                        productID: Int,
                        completionHandler: @escaping (AFDataResponse<RemoveCartResult>) -> Void
                        ) {
        SwiftyBeaver.info("CartRequestFactory.remove")
        cartService.remove(userID: userID, productID: productID, completionHandler: completionHandler)
    }
    
    func payCart(userID: Int, money: Int, completionHandler: @escaping (AFDataResponse<PayCartResult>) -> Void) {
        SwiftyBeaver.info("CartRequestFactory.pay")
        cartService.pay(userID: userID, money: money, completionHandler: completionHandler)
    }
}
