//
//  CartPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import FirebaseAnalytics

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
    func viewDidOpenUpdateUserSettings()
}

class CartPresenter {
    let interactor: CartInteractorInput
    let router: CartRouterInput
    
    weak var viewInput: (UIViewController & CartViewInput)?
    
    init(interactor: CartInteractorInput, router: CartRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func userDataFatalError() {
        SwiftyBeaver.error(StringResources.userError)
        Crashlytics.crashlytics().log(StringResources.userError)
        fatalError(StringResources.userError)
    }
    
    private func cartSuccessfullyLoadedLog() {
        SwiftyBeaver.info("Cart successfully loaded..")
        let title = "cart-load-success"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func addToCartLog(id: Int) {
        SwiftyBeaver.info("Product id = \(id) added successfully..")
        let title = "cart-add"
        Analytics.logEvent(title, parameters: [
            "productID": id
        ])
    }
    
    private func removeFromCartLog(id: Int) {
        SwiftyBeaver.info("Product id = \(id) removed successfully..")
        let title = "cart-remove"
        Analytics.logEvent(title, parameters: [
            "productID": id
        ])
    }
    
    private func payCartLog(isSuccess: Bool) {
        if isSuccess {
            SwiftyBeaver.warning("Payed successfully")
        } else {
            SwiftyBeaver.warning("Not enough money to pay")
        }
        let title = "cart-pay"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func userOpenSettigsLog() {
        SwiftyBeaver.info("User open user settings")
        let title = "user-settings"
        Analytics.logEvent(title, parameters: [:])
    }
}

extension CartPresenter: CartViewOutput {

    func viewDidLoadCart() {
        guard let userID = UserSession.shared.userData?.id else {
            userDataFatalError()
            return
        }
        
        interactor.getCart(userID: userID) { [weak self] response in
            switch response.result {
            case .success(let cart):
                self?.cartSuccessfullyLoadedLog()
                DispatchQueue.main.async {
                    self?.viewInput?.products = cart.products
                    self?.viewInput?.totalPrice = cart.totalPrice
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
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
    
    func viewDidRemoveFromCart(productID: Int) {
        guard let userID = UserSession.shared.userData?.id else {
            userDataFatalError()
            return
        }
        
        interactor.removeFromCart(userID: userID, productID: productID) { [weak self] response in
            switch response.result {
            case .success(_):
                self?.removeFromCartLog(id: productID)
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidPayCart() {
        guard let user = UserSession.shared.userData else {
            userDataFatalError()
            return
        }
        
        interactor.payCart(userID: user.id, money: UserSession.shared.money) { [weak self] response in
            switch response.result {
            case .success(let pay):
                switch pay.result {
                case -1:
                    self?.payCartLog(isSuccess: false)
                    DispatchQueue.main.async {
                        self?.router.showNotEnoughMoneyAlert()
                    }
                case 1:
                    self?.payCartLog(isSuccess: true)
                    DispatchQueue.main.async {
                        UserSession.shared.money -= self?.viewInput?.totalPrice ?? 0
                        self?.viewInput?.setBalance()
                        self?.viewInput?.products = []
                        self?.router.showSuccessFullPaymentAlert() 
                    }
                default:
                    let result = "Unexpected result: \(pay.result) with error: \(String(describing: pay.errorMessage))"
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
    
    func viewDidOpenUpdateUserSettings() {
        userOpenSettigsLog()
        router.openUpateUserSettings()
    }
}
