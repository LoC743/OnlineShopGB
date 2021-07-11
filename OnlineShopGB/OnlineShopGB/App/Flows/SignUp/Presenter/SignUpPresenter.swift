//
//  SignUpPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit

protocol SignUpViewInput: AnyObject { }

protocol SignUpViewOutput {
    func viewDidSignUp(user: UserData)
    func viewHaveEmptyFields()
}

class SignUpPresenter {
    let interactor: SignUpInteractorInput
    let router: SignUpRouterInput
    
    weak var viewInput: (UIViewController & SignUpViewInput)?
    
    init(interactor: SignUpInteractorInput, router: SignUpRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension SignUpPresenter: SignUpViewOutput {
    func viewDidSignUp(user: UserData) {
        interactor.signUp(user: user) { [weak self] response in
            switch response.result {
            case .success(let signUp):

                switch signUp.result {
                case 1:
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
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
