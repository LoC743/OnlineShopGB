//
//  MainBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//


import UIKit
import SwiftyBeaver

class MainBuilder {
    static func build() -> UIViewController {
        SwiftyBeaver.info("Creating Main View Controller")
        
        let tabBarController = UITabBarController()
        let cartViewController = CartBuilder.build()
        let productCatalogController = ProductCatalogBuilder.build()
        
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)
        let cartImage = UIImage(systemName: "cart") ?? UIImage()
        let cartImageSelected = UIImage(systemName: "cart.fill") ?? UIImage()
        cartNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("cartTabBar", comment: ""),
            image: cartImage,
            selectedImage: cartImageSelected
        )
        
        let productsImage = UIImage(systemName: "archivebox")
        let productsImageSelected = UIImage(systemName: "archivebox.fill")
        let productCatalogNavigationController = UINavigationController(rootViewController: productCatalogController)
        productCatalogNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("productTabBar", comment: ""),
            image: productsImage,
            selectedImage: productsImageSelected
        )
        
        tabBarController.viewControllers = [productCatalogNavigationController, cartNavigationController]
        
        return tabBarController
    }
}
