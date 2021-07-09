//
//  AuthPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit

protocol AuthViewInput: AnyObject {
}

protocol AuthViewOutput {
    func viewDidSignIn(username: String, password: String)
    func viewHaveEmptyFields()
}

class AuthPresenter {
    let interactor: AuthInteractorInput
    let router: AuthRouterInput
    
    weak var viewInput: (UIViewController & AuthViewInput)?
    
    init(interactor: AuthInteractorInput, router: AuthRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension AuthPresenter: AuthViewOutput {
    func viewDidSignIn(username: String, password: String) {
        interactor.signIn(username: username, password: password) { [weak self] response in
            switch response.result {
            case .success(let signIn):
                
                switch signIn.result {
                case 1:
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
                    }
                    break
                case 2:
                    DispatchQueue.main.async {
                        self?.router.showUserDoesntExistError()
                    }
                    break
                default:
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func viewHaveEmptyFields() {
        router.showEmptyFieldsError()
    }
}
