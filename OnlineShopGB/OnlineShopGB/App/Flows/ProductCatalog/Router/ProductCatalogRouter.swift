//
//  ProductCatalogRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import UIKit
import SwiftyBeaver

protocol  ProductCatalogRouterInput {
    func moveToReviews(productID: Int, productName: String)
}

class  ProductCatalogRouter:  ProductCatalogRouterInput {
    
    weak var viewController: UIViewController?
    
    func moveToReviews(productID: Int, productName: String) {
        let reviewsViewController = ReviewsBuilder.build(with: productID)
        reviewsViewController.title = productName
        viewController?.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
}
