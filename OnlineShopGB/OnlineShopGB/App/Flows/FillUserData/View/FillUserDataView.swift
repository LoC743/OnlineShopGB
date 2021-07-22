//
//  SignUpView.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import SnapKit

final class FillUserDataView: UIView {
    
    // MARK: - Subviews
    
    lazy var scrollView = UIScrollView()
    lazy var fieldsStackView = UIStackView()
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var firstnameTextField = UITextField()
    lazy var lastnameTextField = UITextField()
    lazy var emailTextField = UITextField()
    lazy var creditCardTextField = UITextField()
    lazy var bioTextField = UITextField()
    
    lazy var genderPickerView = UIPickerView()
    
    lazy var textFieldArray: [UITextField] = {
       return [usernameTextField, passwordTextField,
               firstnameTextField, lastnameTextField,
               emailTextField, creditCardTextField, bioTextField]
    }()
    
    var activeField: UITextField?
    
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
        static let navigationBarHeight: CGFloat = 44.0
        
        static let topStackViewOffset = 15.0
        static let sideStackViewOffset = 15.0
        static let spacing: CGFloat = 15.0
        static let heightStackView: CGFloat = 330.0
        static let topGenderPickerOffset: CGFloat = 5.0
        static let sideGenderPickerOffset = 15.0
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addScrollView()
        self.addFieldsStackView()
        self.addGenderPickerView()
        self.setupTextFields()
    }
    
    private func addScrollView() {
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
    }
    
    private func addFieldsStackView() {
        textFieldArray.forEach { field in
            field.borderStyle = .roundedRect
            field.autocorrectionType = .no
            
            fieldsStackView.addArrangedSubview(field)
         }
        
        scrollView.addSubview(fieldsStackView)
        
        fieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(Constants.topStackViewOffset)
            make.left.equalTo(self).offset(Constants.sideStackViewOffset)
            make.right.equalTo(self).offset(-Constants.sideStackViewOffset)
            make.height.equalTo(Constants.heightStackView)
        }
        
        fieldsStackView.alignment = .fill
        fieldsStackView.distribution = .equalSpacing
        fieldsStackView.spacing = Constants.spacing
        fieldsStackView.axis = .vertical
    }
    
    private func addGenderPickerView() {
        scrollView.addSubview(genderPickerView)
        
        genderPickerView.snp.makeConstraints { make in
            make.top.equalTo(fieldsStackView.snp.bottom).offset(Constants.topGenderPickerOffset)
            make.left.equalTo(self).offset(Constants.sideGenderPickerOffset)
            make.right.equalTo(self).offset(-Constants.sideGenderPickerOffset)
            make.bottom.equalTo(scrollView).offset(-Constants.topGenderPickerOffset)
        }
    }
    
    private func setupTextFields() {
        usernameTextField.placeholder = NSLocalizedString("usernamePlaceholder", comment: "")
        passwordTextField.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
        firstnameTextField.placeholder = NSLocalizedString("firstnamePlaceholder", comment: "")
        lastnameTextField.placeholder = NSLocalizedString("lastnamePlaceholder", comment: "")
        emailTextField.placeholder = NSLocalizedString("emailPlaceholder", comment: "")
        creditCardTextField.placeholder = NSLocalizedString("creditCardPlaceholder", comment: "")
        bioTextField.placeholder = NSLocalizedString("bioPlaceholder", comment: "")
        
        firstnameTextField.textContentType = .name
        lastnameTextField.textContentType = .familyName
        creditCardTextField.textContentType = .creditCardNumber
        emailTextField.textContentType = .emailAddress
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }
    
    func restorePostion() {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }

    func moveViewToTextField(with keyboardFrame: CGRect) {
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height

        scrollView.contentInset = contentInset
        
        
        guard let activeField = activeField else { return }
        let frame = self.convert(activeField.frame, from: fieldsStackView)
        let keyboard = self.frame.maxY - Constants.safeArea.top -
            Constants.navigationBarHeight - keyboardFrame.height

        if self.frame.origin.y == 0  && frame.origin.y > keyboard {
            self.frame.origin.y -= frame.origin.y - keyboard
        }
    }
}
