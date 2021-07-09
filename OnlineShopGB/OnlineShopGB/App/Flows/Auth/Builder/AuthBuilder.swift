//
//  AuthBuilder.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit

class AuthBuilder {
    static func build() -> (UIViewController & AuthViewInput) {
        let interactor = AuthInteractor()
        let router = AuthRouter()

        let presenter = AuthPresenter(interactor: interactor, router: router)
        
        let viewController = AuthViewController(presenter: presenter)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        return viewController
    }
}
