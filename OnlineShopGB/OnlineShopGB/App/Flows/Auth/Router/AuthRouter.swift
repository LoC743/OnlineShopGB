//
//  AuthRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit
import SwiftyBeaver

protocol AuthRouterInput {
    func showUserDoesntExistError()
    func showEmptyFieldsError()
    func moveToMainViewController()
    func moveToSignUpViewController(username: String, password: String)
}

class AuthRouter: AuthRouterInput {
    
    weak var viewController: UIViewController?
    
    func showUserDoesntExistError() {
        SwiftyBeaver.info("Showing alert")
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
        SwiftyBeaver.info("Showing alert")
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
        SwiftyBeaver.info("Moving to main view controller after successfull sign in")
        let mainViewController = MainBuilder.build()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setRootViewController(mainViewController)
    }
    
    func moveToSignUpViewController(username: String, password: String) {
        SwiftyBeaver.info("Moving to Sign Up")
        let signUpViewController = FillUserDataBuilder.buildSignUp(username: username, password: password)
        viewController?.present(signUpViewController, animated: true, completion: nil)
    }
}
