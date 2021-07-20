//
//  FillUserDataRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit
import SwiftyBeaver

protocol FillUserDataRouterInput {
    func showEmptyFieldsError()
    func moveToMainViewController()
    func dismiss()
    func moveToAuth()
}

class FillUserDataRouter: FillUserDataRouterInput {
    
    weak var viewController: UIViewController?
    
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
        SwiftyBeaver.info("Moving to main view controller")
        let mainViewController = MainBuilder.build()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setRootViewController(mainViewController)
    }
    
    func dismiss() {
        SwiftyBeaver.info("Close this view controller")
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func moveToAuth() {
        SwiftyBeaver.info("Moving to auth view controller")
        let authViewController = AuthBuilder.build()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setRootViewController(authViewController)
    }
}
