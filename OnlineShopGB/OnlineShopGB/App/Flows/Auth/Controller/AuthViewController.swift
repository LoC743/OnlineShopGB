//
//  AuthViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit
import SwiftyBeaver

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
        
        self.addTapGestureRecognizer()
        
        self.addCrashButton()
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        authView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        authView.endEditing(true)
    }
    
    @objc private func signInButtonTapped() {        
        SwiftyBeaver.info("Sign In button pressed")
        let username: String = authView.usernameTextField.text ?? ""
        let password: String = authView.passwordTextField.text ?? ""
        
        guard username != "" && password != "" else {
            presenter.viewHaveEmptyFields()
            return
        }
        
        presenter.viewDidSignIn(username: username, password: password)
    }
    
    @objc private func signUpButtonTapped() {
        SwiftyBeaver.info("Sign Up button pressed")
        let username: String = authView.usernameTextField.text ?? ""
        let password: String = authView.passwordTextField.text ?? ""
        
        presenter.viewDidSignUp(username: username, password: password)
    }
    
    private func addCrashButton() {
        let button = UIButton(type: .system)
        authView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(authView).offset(-20.0)
            make.centerX.equalTo(authView)
        }
        
        button.setTitle("Crash", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(crash), for: .touchUpInside)
    }
    
    @objc private func crash() {
        let nillValue: Int? = nil
        let _ = nillValue!
    }
}

extension AuthViewController: AuthViewInput { }
