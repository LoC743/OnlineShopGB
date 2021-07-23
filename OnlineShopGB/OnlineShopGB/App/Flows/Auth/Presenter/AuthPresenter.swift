//
//  AuthPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import FirebaseAnalytics

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
    
    private func signInLog(user: User?) {
        SwiftyBeaver.info("Success sign in")
        let title = "sign-in"
        Analytics.logEvent(title, parameters: [
            "id": user?.id ?? -1,
            "username": user?.username ?? "Error",
            "email": user?.email ?? "Error",
            "bio": user?.bio ?? "Error",
        ])
    }
    
    private func signInErrorLog(username: String) {
        SwiftyBeaver.info("User does not exit")
        let title = "sign-in-error"
        Analytics.logEvent(title, parameters: [
            "username": username,
        ])
    }
    
    private func moveToSignUpLog() {
        SwiftyBeaver.info("Moving to Sign Up")
        let title = "move-to-sign-up"
        Analytics.logEvent(title, parameters: [:])
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
                    self?.signInLog(user: signIn.user)
                    UserSession.shared.userData = signIn.user
                    DispatchQueue.main.async {
                        self?.router.moveToMainViewController()
                    }
                    break
                case 2:
                    self?.signInErrorLog(username: username)
                    DispatchQueue.main.async {
                        self?.router.showUserDoesntExistError()
                    }
                    break
                default:
                    let result =
                        """
                        Unexpected result: \(signIn.result) with error: \(String(describing: signIn.errorMessage))
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
        SwiftyBeaver.info("At least one field is empty -> Show Alert")
        router.showEmptyFieldsError()
    }
    
    func viewDidSignUp(username: String, password: String) {
        moveToSignUpLog()
        router.moveToSignUpViewController(username: username, password: password)
    }
}
