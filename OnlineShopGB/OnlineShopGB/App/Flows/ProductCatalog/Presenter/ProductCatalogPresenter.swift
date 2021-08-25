//
//  ProductCatalogPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import FirebaseAnalytics

protocol ProductCatalogViewInput: AnyObject {
    var catalog: [ProductResult] { get set }
}

protocol ProductCatalogViewOutput {
    func viewDidLoadCatalog()
    func viewDidLoadProduct(by id: Int, completionHandler: @escaping (GoodResult) -> Void)
    func viewDidEnterReviews(for productID: Int, with productName: String)
    func viewDidAddToCart(productID: Int)
}

class ProductCatalogPresenter {
    let interactor: ProductCatalogInteractorInput
    let router: ProductCatalogRouterInput
    
    weak var viewInput: (UIViewController & ProductCatalogViewInput)?
    
    init(interactor: ProductCatalogInteractorInput, router: ProductCatalogRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func userDataFatalError() {
        SwiftyBeaver.error(StringResources.userError)
        Crashlytics.crashlytics().log(StringResources.userError)
        fatalError(StringResources.userError)
    }
    
    private func loadProductCatalogLog() {
        SwiftyBeaver.info("Catalog successfully loaded..")
        let title = "product-catalog-load"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func addToCartLog(id: Int) {
        SwiftyBeaver.info("Product = \(id) added to cart.")
        let title = "cart-add"
        Analytics.logEvent(title, parameters: [
            "id": id
        ])
    }
    
    private func moveToReviewsLog(id: Int) {
        SwiftyBeaver.info("Moving to Reviews.")
        let title = "move-to-reviews"
        Analytics.logEvent(title, parameters: [
            "id": id
        ])
    }
}

extension ProductCatalogPresenter: ProductCatalogViewOutput {
    func viewDidLoadCatalog() {
        SwiftyBeaver.info("Trying to load product catalog..")
        interactor.loadCatalog { [weak self] response in
            switch response.result {
            case .success(let catalog):
                self?.loadProductCatalogLog()
                DispatchQueue.main.async {
                    self?.viewInput?.catalog = catalog
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidLoadProduct(by id: Int, completionHandler: @escaping (GoodResult) -> Void) {
        SwiftyBeaver.info("Trying to load product by id..")
        interactor.loadProduct(by: id) { response in
            switch response.result {
            case .success(let product):
                switch product.result {
                case 1:
                    SwiftyBeaver.info("Product with id \(id) successfully loaded.")
                    completionHandler(product)
                case 0:
                    SwiftyBeaver.warning("Product with id \(id) doesn't found.")
                    let errorProduct = GoodResult(
                        result: 0,
                        name: NSLocalizedString("errorTitle", comment: ""),
                        price: 0,
                        description: NSLocalizedString("errorMessageProductNotFound", comment: ""),
                        errorMessage: nil
                    )
                    completionHandler(errorProduct)
                default:
                    let result = """
                        Unexpected result: \(product.result)
                        with error: \(String(describing: product.errorMessage))
                        """
                    SwiftyBeaver.warning(result)
                    Crashlytics.crashlytics().log(result)
                    return
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidEnterReviews(for productID: Int, with productName: String) {
        self.moveToReviewsLog(id: productID)
        self.router.moveToReviews(productID: productID, productName: productName)
    }
    
    func viewDidAddToCart(productID: Int) {
        guard let userID = UserSession.shared.userData?.id else {
            userDataFatalError()
            return
        }
        interactor.addToCart(userID: userID, productID: productID) { [weak self] response in
            switch response.result {
            case .success(_):
                self?.addToCartLog(id: productID)
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
}
