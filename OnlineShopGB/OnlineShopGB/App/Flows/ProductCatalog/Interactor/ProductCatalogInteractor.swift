//
//  ProductCatalogInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//


import Alamofire
import SwiftyBeaver

protocol ProductCatalogInteractorInput {
    func loadCatalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void)
    func loadProduct(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void)
    func addToCart(userID: Int, productID: Int, completionHandler: @escaping (AFDataResponse<AddCartResult>) -> Void)
}

class ProductCatalogInteractor: ProductCatalogInteractorInput {
    
    private lazy var productService: ProductRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeProductRequestFatory()
    }()
    
    private lazy var cartService: CartRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeCartRequestFatory()
    }()
    
    func loadCatalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void) {
        SwiftyBeaver.info("ProductRequestFactory.catalog")
        productService.catalog(completionHandler: completionHandler)
    }
    
    func loadProduct(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void) {
        SwiftyBeaver.info("ProductRequestFactory.product")
        productService.product(by: id, completionHandler: completionHandler)
    }
    
    func addToCart(userID: Int, productID: Int, completionHandler: @escaping (AFDataResponse<AddCartResult>) -> Void) {
        SwiftyBeaver.info("CartRequestFactory.add")
        cartService.add(userID: userID, productID: productID, quantity: 1, completionHandler: completionHandler)
    }
}
