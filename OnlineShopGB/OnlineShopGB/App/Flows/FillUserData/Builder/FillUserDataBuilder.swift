//
//  FillUserDataBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit
import SwiftyBeaver

class FillUserDataBuilder {
    static func buildSignUp(username: String, password: String) -> UIViewController {
        SwiftyBeaver.info("Creating Sign Up Controller(navigation)")
        let interactor = FillUserDataInteractor()
        let router = FillUserDataRouter()

        let presenter = FillUserDataPresenter(interactor: interactor, router: router)
        
        let viewController = FillUserDataViewController(presenter: presenter, mode: .signUp)
        viewController.setupInitialFields(username: username, password: password)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
    static func buildUpdateUserData() -> UIViewController {
        SwiftyBeaver.info("Creating Update User Data Controller(navigation)")
        let interactor = FillUserDataInteractor()
        let router = FillUserDataRouter()

        let presenter = FillUserDataPresenter(interactor: interactor, router: router)
        
        let viewController = FillUserDataViewController(presenter: presenter, mode: .updateData)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
}
