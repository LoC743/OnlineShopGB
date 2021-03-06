//
//  AuthView.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import SnapKit

final class AuthView: UIView {
    
    // MARK: - Subviews
    
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    
    lazy var buttonsStackView = UIStackView()
    lazy var signInButton = UIButton(type: .system)
    lazy var signUpButton = UIButton(type: .system)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let safeArea = UIApplication.shared.windows[0].safeAreaInsets
        
        static let usernameTextFieldTopOffset = safeArea.top + 25
        static let textFieldSideOffset = 25
        static let passwordTextFiledTopOffset = 25
        static let buttonsTopOffset = 25
        static let buttonsSideOffset = 25
        static let buttonsHeight: CGFloat = 55.0
        static let buttonsSpacing: CGFloat = 15.0
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addUsernameTextField()
        self.addPasswordTextField()
        self.addButtonsStackView()
    }

    private func addUsernameTextField() {
        self.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.usernameTextFieldTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
        }
        
        usernameTextField.placeholder = NSLocalizedString("usernamePlaceholder", comment: "")
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.accessibilityIdentifier = StringResources.usernameTextFieldAccessibilityIdentifier
    }
    
    private func addPasswordTextField() {
        self.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(Constants.passwordTextFiledTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
        }
        
        passwordTextField.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.accessibilityIdentifier = StringResources.passwordTextFieldAccessibilityIdentifier
    }

    private func addButtonsStackView() {
        self.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.buttonsTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
            make.height.equalTo(Constants.buttonsHeight)
        }
        
        buttonsStackView.addArrangedSubview(signUpButton)
        buttonsStackView.addArrangedSubview(signInButton)
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = Constants.buttonsSpacing
        
        signUpButton.setTitle(NSLocalizedString("signUpButtonTitle", comment: ""), for: .normal)
        signInButton.setTitle(NSLocalizedString("signInButtonTitle", comment: ""), for: .normal)
        
        [signUpButton, signInButton].forEach { button in
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = Constants.buttonsHeight / 2
            button.setTitleColor(.white, for: .normal)
        }
        
        signInButton.accessibilityIdentifier = StringResources.signInButtonAccessibilityIdentifier
    }
}
