//
//  CartBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import UIKit
import SwiftyBeaver

class CartBuilder {
    static func build() -> UIViewController {
        SwiftyBeaver.info("Creating Cart View Controller")
        let interactor = CartInteractor()
        let router = CartRouter()

        let presenter = CartPresenter(interactor: interactor, router: router)
        
        let viewController = CartViewController(presenter: presenter)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        return viewController
    }
}
