//
//  ProductCatalogPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import UIKit
import SwiftyBeaver

protocol ProductCatalogViewInput: AnyObject {
    var catalog: [ProductResult] { get set }
}

protocol ProductCatalogViewOutput {
    func viewDidLoadCatalog()
    func viewDidLoadProduct(by id: Int, completionHandler: @escaping (GoodResult) -> Void)
    func viewDidEnterReviews(for productID: Int)
}

class ProductCatalogPresenter {
    let interactor: ProductCatalogInteractorInput
    let router: ProductCatalogRouterInput
    
    weak var viewInput: (UIViewController & ProductCatalogViewInput)?
    
    init(interactor: ProductCatalogInteractorInput, router: ProductCatalogRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension ProductCatalogPresenter: ProductCatalogViewOutput {
    func viewDidLoadCatalog() {
        SwiftyBeaver.info("Trying to load product catalog..")
        interactor.loadCatalog { [weak self] response in
            switch response.result {
            case .success(let catalog):
                SwiftyBeaver.info("Catalog successfully loaded..")
                DispatchQueue.main.async {
                    self?.viewInput?.catalog = catalog
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
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
                    SwiftyBeaver.warning("Unexpected result: \(product.result) with error: \(String(describing: product.errorMessage))")
                    return
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidEnterReviews(for productID: Int) {
        self.router.moveToReviews(productID: productID)
    }
}
