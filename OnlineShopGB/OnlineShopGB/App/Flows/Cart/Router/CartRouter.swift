//
//  CartRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import UIKit
import SwiftyBeaver

protocol CartRouterInput {
    func showNotEnoughMoneyAlert()
    func showSuccessFullPaymentAlert() 
}

class CartRouter: CartRouterInput {
    
    weak var viewController: UIViewController?
    
    enum Constants {
        static let waitFor: Double = 1.5
    }
    
    func showNotEnoughMoneyAlert() {
        SwiftyBeaver.info("Show alert -> not enough money")
        let title = NSLocalizedString("notEnoughMoneyAlertTitle", comment: "")
        let message = NSLocalizedString("notEnoughMoneyAlertMessage", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitFor){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showSuccessFullPaymentAlert() {
        SwiftyBeaver.info("Show alert -> successfull payment")
        let title = NSLocalizedString("successFullPaymentTitle", comment: "")
        let message = NSLocalizedString("successFullPaymentMessage", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitFor){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
