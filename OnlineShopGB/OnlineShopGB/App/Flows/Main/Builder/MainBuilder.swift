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
        let someMainController = ViewController()
        let productCatalogController = ProductCatalogBuilder.build()
        
        let mainNavigationController = UINavigationController(rootViewController: someMainController)
        let mainImage = UIImage(systemName: "circle.grid.3x3") ?? UIImage()
        let mainImageSelected = UIImage(systemName: "circle.grid.3x3.fill") ?? UIImage()
        mainNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("mainTabBar", comment: ""),
            image: mainImage,
            selectedImage: mainImageSelected
        )
        
        let productsImage = UIImage(systemName: "archivebox")
        let productsImageSelected = UIImage(systemName: "archivebox.fill")
        let productCatalogNavigationController = UINavigationController(rootViewController: productCatalogController)
        productCatalogNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("productTabBar", comment: ""),
            image: productsImage,
            selectedImage: productsImageSelected
        )
        
        tabBarController.viewControllers = [mainNavigationController, productCatalogNavigationController]
        
        return tabBarController
    }
}
