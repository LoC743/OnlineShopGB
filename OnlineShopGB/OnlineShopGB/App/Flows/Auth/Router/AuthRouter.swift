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
    func moveToSignUpViewController(username: String, password: String)
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
        let mainViewController = ViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        
        viewController?.present(mainViewController, animated: true, completion: nil)
    }
    
    func moveToSignUpViewController(username: String, password: String) {
        let signUpViewController = FillUserDataBuilder.buildSignUp(username: username, password: password)
        viewController?.present(signUpViewController, animated: true, completion: nil)
    }
}
