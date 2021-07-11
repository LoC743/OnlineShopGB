//
//  SignUpBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit

class SignUpBuilder {
    static func build(username: String, password: String) -> (UIViewController & SignUpViewInput) {
        let interactor = SignUpInteractor()
        let router = SignUpRouter()

        let presenter = SignUpPresenter(interactor: interactor, router: router)
        
        let viewController = SignUpViewController(presenter: presenter)
        viewController.setupInitialFields(username: username, password: password)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        return viewController
    }
}
