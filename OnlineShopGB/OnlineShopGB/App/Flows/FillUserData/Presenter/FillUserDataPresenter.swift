//
//  FillUserDataPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit
import SwiftyBeaver

protocol FillUserDataViewInput: AnyObject {}

protocol FillUserDataViewOutput {
    func viewDidSignUp(user: User)
    func viewHaveEmptyFields()
    func viewDidUpdateUserData(user: User)
}

class FillUserDataPresenter {
    let interactor: FillUserDataInteractorInput
    let router: FillUserDataRouterInput
    
    weak var viewInput: (UIViewController & FillUserDataViewInput)?
    
    init(interactor: FillUserDataInteractorInput, router: FillUserDataRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension FillUserDataPresenter: FillUserDataViewOutput {
    func viewDidSignUp(user: User) {
        SwiftyBeaver.info("Trying to sign up..")
        interactor.signUp(user: user) { [weak self] response in
            switch response.result {
            case .success(let signUp):

                switch signUp.result {
                case 1:
                    SwiftyBeaver.info("Successfull sign up")
                    UserSession.shared.userData = user
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
                    }
                    break
                default:
                    SwiftyBeaver.warning(
                        "Unexpected result: \(signUp.result) with error: \(String(describing: signUp.errorMessage))"
                    )
                    return
                }

            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewHaveEmptyFields() {
        SwiftyBeaver.info("User forgot to fill at least one field -> Show Alert")
        router.showEmptyFieldsError()
    }
    
    func viewDidUpdateUserData(user: User) {
        SwiftyBeaver.info("Trying to update user data..")
        interactor.updateUserData(user: user) { [weak self] response in
            switch response.result {
            case .success(let update):
                switch update.result {
                case 1:
                    SwiftyBeaver.info("User data successfully updated")
                    UserSession.shared.userData = user
                    DispatchQueue.main.async {
                        self?.router.dismiss()
                    }
                    break
                default:
                    SwiftyBeaver.warning(
                        "Unexpected result: \(update.result) with error: \(String(describing: update.errorMessage))"
                    )
                    return
                }

            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
}
