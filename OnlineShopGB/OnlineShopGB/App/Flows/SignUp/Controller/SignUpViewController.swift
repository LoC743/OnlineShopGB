//
//  SignUpViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var signUpView: SignUpView {
        return self.view as! SignUpView
    }
    
    private let presenter: SignUpViewOutput
    
    private var genderArray: [String] {
        return [
            NSLocalizedString("maleGender", comment: ""),
            NSLocalizedString("femaleGender", comment: ""),
            NSLocalizedString("helicopterGender", comment: ""),
        ]
    }
    
    // MARK: - Lifecycle
    
    init(presenter: SignUpViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = SignUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.genderPickerView.delegate = self
        signUpView.genderPickerView.dataSource = self
        
        setupSignUpButton()
    }
    
    private func setupSignUpButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("signUpButtonTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(viewDidSignUp)
        )
    }
    
    @objc private func viewDidSignUp() {
        let username = signUpView.usernameTextField.text ?? ""
        let password = signUpView.passwordTextField.text ?? ""
        let firstname = signUpView.firstnameTextField.text ?? ""
        let lastname = signUpView.lastnameTextField.text ?? ""
        let email = signUpView.emailTextField.text ?? ""
        let creditCard = signUpView.creditCardTextField.text ?? ""
        let bio = signUpView.bioTextField.text ?? ""
        
        guard username != "" &&
              password != "" &&
              firstname != "" &&
              lastname != "" &&
              email != "" &&
              creditCard != "" &&
              bio != ""
        else {
            presenter.viewHaveEmptyFields()
            return
        }
        
        let user = UserData(
            id: UUID().hashValue,
            username: username,
            password: password,
            firstName: firstname,
            lastName: lastname,
            email: email,
            gender: genderArray[signUpView.genderPickerView.selectedRow(inComponent: 0)],
            creditCard: creditCard,
            bio: bio
        )
        presenter.viewDidSignUp(user: user)
    }
    
    func setupInitialFields(username: String, password: String) {
        signUpView.usernameTextField.text = username
        signUpView.passwordTextField.text = password
    }
}

extension SignUpViewController: SignUpViewInput { }

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
}
