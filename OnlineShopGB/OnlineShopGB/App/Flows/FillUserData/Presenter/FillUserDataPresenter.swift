//
//  FillUserDataPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit

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
    
    func viewDidUpdateUserData(user: User) {
        interactor.updateUserData(user: user) { [weak self] response in
            switch response.result {
            case .success(let signUp):
                switch signUp.result {
                case 1:
                    UserSession.shared.userData = user
                    DispatchQueue.main.async {
                        self?.router.dismiss()
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
}
