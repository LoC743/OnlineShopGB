//
//  AuthPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit
import SwiftyBeaver

protocol AuthViewInput: AnyObject { }

protocol AuthViewOutput {
    func viewDidSignIn(username: String, password: String)
    func viewHaveEmptyFields()
    func viewDidSignUp(username: String, password: String)
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
        SwiftyBeaver.info("Try to sign in..")
        interactor.signIn(username: username, password: password) { [weak self] response in
            switch response.result {
            case .success(let signIn):
                
                switch signIn.result {
                case 1:
                    SwiftyBeaver.info("Success sign in")
                    UserSession.shared.userData = signIn.user
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
                    }
                    break
                case 2:
                    SwiftyBeaver.info("user does not exit")
                    DispatchQueue.main.async {
                        self?.router.showUserDoesntExistError()
                    }
                    break
                default:
                    SwiftyBeaver.warning("Unexpected result: \(signIn.result) with error: \(String(describing: signIn.errorMessage))")
                    return
                }
                
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewHaveEmptyFields() {
        SwiftyBeaver.info("At least one field is empty -> Show Alert")
        router.showEmptyFieldsError()
    }
    
    func viewDidSignUp(username: String, password: String) {
        SwiftyBeaver.info("Moving to Sign Up")
        router.moveToSignUpViewController(username: username, password: password)
    }
}
