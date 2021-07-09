//
//  AuthViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var authView: AuthView {
        return self.view as! AuthView
    }
    
    private let presenter: AuthViewOutput
    
    // MARK: - Lifecycle
    
    init(presenter: AuthViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = AuthView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.authView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc func signInButtonTapped() {
        let username = authView.usernameTextField.text ?? ""
        let password = authView.passwordTextField.text ?? ""
        
        guard username != "" && password != "" else {
            presenter.viewHaveEmptyFields()
            return
        }
        
        presenter.viewDidSignIn(username: username, password: password)
    }
    
    @objc func signUpButtonTapped() {
        
    }
}

extension AuthViewController: AuthViewInput { }
