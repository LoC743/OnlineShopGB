//
//  ProductCatalogBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import UIKit
import SwiftyBeaver

class ProductCatalogBuilder {
    static func build() -> UIViewController {
        SwiftyBeaver.info("Creating Product Catalog View Controller")
        let interactor = ProductCatalogInteractor()
        let router = ProductCatalogRouter()

        let presenter = ProductCatalogPresenter(interactor: interactor, router: router)
        
        let viewController = ProductCatalogViewController(presenter: presenter)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        return viewController
    }
}
