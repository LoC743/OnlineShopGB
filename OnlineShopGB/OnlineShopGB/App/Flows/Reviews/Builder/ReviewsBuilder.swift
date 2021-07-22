//
//  ReviewsBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver

class ReviewsBuilder {
    static func build(with productID: Int) -> UIViewController {
        SwiftyBeaver.info("Creating Review View Controller")
        let interactor = ReviewsInteractor()
        let router = ReviewsRouter()

        let presenter = ReviewsPresenter(interactor: interactor, router: router)
        
        let viewController = ReviewsViewController(presenter: presenter, productID: productID)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        return viewController
    }
}
