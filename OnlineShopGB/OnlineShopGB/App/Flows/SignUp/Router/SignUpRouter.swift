//
//  SignUpRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit

protocol SignUpRouterInput {
    func showEmptyFieldsError()
    func moveToMainViewController()
}

class SignUpRouter: SignUpRouterInput {
    
    weak var viewController: UIViewController?
    
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
