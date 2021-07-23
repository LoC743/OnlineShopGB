//
//  FillUserDataPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import FirebaseAnalytics

protocol FillUserDataViewInput: AnyObject {}

protocol FillUserDataViewOutput {
    func viewDidSignUp(user: User)
    func viewHaveEmptyFields()
    func viewDidUpdateUserData(user: User)
    func viewDidLogout()
}

class FillUserDataPresenter {
    let interactor: FillUserDataInteractorInput
    let router: FillUserDataRouterInput
    
    weak var viewInput: (UIViewController & FillUserDataViewInput)?
    
    init(interactor: FillUserDataInteractorInput, router: FillUserDataRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func logoutLog() {
        SwiftyBeaver.info("Logout")
        let title = "logout"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func updateUserDataLog() {
        SwiftyBeaver.info("User data successfully updated")
        let title = "user-data-update"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func signUpLog(user: User) {
        SwiftyBeaver.info("User successfully signed up")
        let title = "sign-up"
        Analytics.logEvent(title, parameters: [
            "id": user.id,
            "username": user.username,
            "email": user.email,
            "bio": user.bio
        ])
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
                    self?.signUpLog(user: user)
                    UserSession.shared.userData = user
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
                    }
                    break
                default:
                    let result = """
                        Unexpected result: \(signUp.result) with error: \(String(describing: signUp.errorMessage))
                        """
                    SwiftyBeaver.warning(result)
                    Crashlytics.crashlytics().log(result)
                    return
                }

            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log(error.localizedDescription)
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
                    self?.updateUserDataLog()
                    UserSession.shared.userData = user
                    DispatchQueue.main.async {
                        self?.router.dismiss()
                    }
                    break
                default:
                    let result = """
                    Unexpected result: \(update.result)
                     with error: \(String(describing: update.errorMessage))
                    """
                    SwiftyBeaver.warning(result)
                    Crashlytics.crashlytics().log(result)
                    return
                }

            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log(error.localizedDescription)
            }
        }
    }
    
    func viewDidLogout() {
        logoutLog()
        UserSession.shared.userData = nil
        router.moveToAuth()
    }
}
