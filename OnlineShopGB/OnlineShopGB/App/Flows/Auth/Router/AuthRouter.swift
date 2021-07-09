//
//  AuthRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit

protocol AuthRouterInput {
    func showUserDoesntExistError()
    func showEmptyFieldsError()
    func moveToMainViewController()
}

class AuthRouter: AuthRouterInput {
    
    weak var viewController: UIViewController?
    
    func showUserDoesntExistError() {
        
        let action: UIAlertAction = UIAlertAction(
            title: NSLocalizedString("okAlertAction", comment: ""),
            style: .default,
            handler: nil
        )
        
        viewController?.showAlert(
            with: NSLocalizedString("userDoesntExistAlertTitle", comment: ""),
            message: NSLocalizedString("userDoesntExistAlertMessage", comment: ""),
            actions: [action])
    }
    
    func showEmptyFieldsError() {
        
        let action: UIAlertAction = UIAlertAction(
            title: NSLocalizedString("okAlertAction", comment: ""),
            style: .default,
            handler: nil
        )
        
        viewController?.showAlert(
            with: NSLocalizedString("emptyFieldsAlertTitle", comment: ""),
            message: NSLocalizedString("emptyFieldsAlertMessage", comment: ""),
            actions: [action])
    }
    
    func moveToMainViewController() {
        viewController?.present(ViewController(), animated: true, completion: nil)
    }
}
