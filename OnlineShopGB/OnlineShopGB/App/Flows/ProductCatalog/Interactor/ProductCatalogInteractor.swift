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
}

class ProductCatalogInteractor: ProductCatalogInteractorInput {
    
    private lazy var productService: ProductRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeProductRequestFatory()
    }()
    
    func loadCatalog(completionHandler: @escaping (AFDataResponse<[ProductResult]>) -> Void) {
        SwiftyBeaver.info("ProductRequestFactory.catalog")
        productService.catalog(completionHandler: completionHandler)
    }
    
    func loadProduct(by id: Int, completionHandler: @escaping (AFDataResponse<GoodResult>) -> Void) {
        SwiftyBeaver.info("ProductRequestFactory.product")
        productService.product(by: id, completionHandler: completionHandler)
    }
}
