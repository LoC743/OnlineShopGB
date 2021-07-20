//
//  CartPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import UIKit
import SwiftyBeaver

protocol CartViewInput: AnyObject {
    var products: [CartProduct] { get set }
    var totalPrice: Int { get set }
    
    func setBalance()
}

protocol CartViewOutput {
    func viewDidLoadCart()
    func viewDidAddToCart(productID: Int)
    func viewDidRemoveFromCart(productID: Int)
    func viewDidPayCart()
}

class CartPresenter {
    let interactor: CartInteractorInput
    let router: CartRouterInput
    
    weak var viewInput: (UIViewController & CartViewInput)?
    
    init(interactor: CartInteractorInput, router: CartRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension CartPresenter: CartViewOutput {

    func viewDidLoadCart() {
        guard let userID = UserSession.shared.userData?.id else {
            SwiftyBeaver.warning("Can't get user id from UserSession")
            return
        }
        
        interactor.getCart(userID: userID) { [weak self] response in
            switch response.result {
            case .success(let cart):
                SwiftyBeaver.info("Cart successfully loaded..")
                DispatchQueue.main.async {
                    self?.viewInput?.products = cart.products
                    self?.viewInput?.totalPrice = cart.totalPrice
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidAddToCart(productID: Int) {
        guard let userID = UserSession.shared.userData?.id else {
            SwiftyBeaver.warning("Can't get user id from UserSession")
            return
        }
        
        interactor.addToCart(userID: userID, productID: productID) { response in
            switch response.result {
            case .success(_):
                SwiftyBeaver.info("Product id = \(productID) added successfully..")
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidRemoveFromCart(productID: Int) {
        guard let userID = UserSession.shared.userData?.id else {
            SwiftyBeaver.warning("Can't get user id from UserSession")
            return
        }
        
        interactor.removeFromCart(userID: userID, productID: productID) { response in
            switch response.result {
            case .success(_):
                SwiftyBeaver.info("Product id = \(productID) removed successfully..")
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidPayCart() {
        guard let user = UserSession.shared.userData else {
            SwiftyBeaver.warning("Can't get user id from UserSession")
            return
        }
        
        interactor.payCart(userID: user.id, money: UserSession.shared.money) { response in
            switch response.result {
            case .success(let pay):
                switch pay.result {
                case -1:
                    SwiftyBeaver.warning("Not enough money to pay")
                    DispatchQueue.main.async { [weak self] in
                        self?.router.showNotEnoughMoneyAlert()
                    }
                case 1:
                    SwiftyBeaver.warning("Payed successfully")
                    DispatchQueue.main.async { [weak self] in
                        UserSession.shared.money -= self?.viewInput?.totalPrice ?? 0
                        self?.viewInput?.setBalance()
                        self?.viewInput?.products = []
                        self?.router.showSuccessFullPaymentAlert() 
                    }
                default:
                    SwiftyBeaver.warning(
                        "Unexpected result: \(pay.result) with error: \(String(describing: pay.errorMessage))"
                    )
                    return
                }
                SwiftyBeaver.info("")
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
}
