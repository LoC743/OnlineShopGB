//
//  FillUserDataViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import UIKit
import SwiftyBeaver

class FillUserDataViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var fillUserDataView: FillUserDataView {
        return self.view as! FillUserDataView
    }
    
    private let presenter: FillUserDataViewOutput
    
    private let mode: UsageMode
    
    private var genderArray: [String] {
        return [
            NSLocalizedString("maleGender", comment: ""),
            NSLocalizedString("femaleGender", comment: ""),
            NSLocalizedString("helicopterGender", comment: ""),
        ]
    }
    
    // MARK: - Mode
    
    enum UsageMode {
        case signUp
        case updateData
    }
    
    // MARK: - Lifecycle
    
    init(presenter: FillUserDataViewOutput, mode: UsageMode) {
        self.presenter = presenter
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = FillUserDataView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillUserDataView.genderPickerView.delegate = self
        fillUserDataView.genderPickerView.dataSource = self
        
        SwiftyBeaver.info("current mode: \(mode)")
        switch mode {
        case .signUp:
            setupSignUpButton()
        case .updateData:
            setupUpdateButton()
            fillFieldWithUserSession()
        }
    }
    
    private func setupSignUpButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("signUpButtonTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(signUpTapped)
        )
    }
    
    private func setupUpdateButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("updateUserDataTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(updateUserDataTapped)
        )
    }
    
    private func getUserData() -> User? {
        SwiftyBeaver.info("Collecting user data from fields")
        let username = fillUserDataView.usernameTextField.text ?? ""
        let password = fillUserDataView.passwordTextField.text ?? ""
        let firstname = fillUserDataView.firstnameTextField.text ?? ""
        let lastname = fillUserDataView.lastnameTextField.text ?? ""
        let email = fillUserDataView.emailTextField.text ?? ""
        let creditCard = fillUserDataView.creditCardTextField.text ?? ""
        let bio = fillUserDataView.bioTextField.text ?? ""
        
        guard username != "" &&
              password != "" &&
              firstname != "" &&
              lastname != "" &&
              email != "" &&
              creditCard != "" &&
              bio != ""
        else {
            SwiftyBeaver.warning("At least one field is empty")
            return nil
        }
        
        let id: Int
        switch mode {
        case .signUp:
            id = UUID().hashValue
        case .updateData:
            id = UserSession.shared.userData?.id ?? UUID().hashValue
        }
        
        let user = User(
            id: id,
            username: username,
            password: password,
            firstname: firstname,
            lastname: lastname,
            email: email,
            gender: genderArray[fillUserDataView.genderPickerView.selectedRow(inComponent: 0)],
            creditCard: creditCard,
            bio: bio
        )
        
        return user
    }
    
    @objc private func signUpTapped() {
        SwiftyBeaver.info("User pressed sign up navBar button")
        guard let user = getUserData() else {
            presenter.viewHaveEmptyFields()
            return
        }
        presenter.viewDidSignUp(user: user)
    }
    
    @objc private func updateUserDataTapped() {
        SwiftyBeaver.info("User pressed update data navBar button")
        guard let user = getUserData() else {
            presenter.viewHaveEmptyFields()
            return
        }
        presenter.viewDidUpdateUserData(user: user)
    }
    
    private func fillFieldWithUserSession() {
        SwiftyBeaver.info("Filling user data fields with saved data")
        guard let userData = UserSession.shared.userData else {
            SwiftyBeaver.info("UserSesson does not have saved user data")
            return
        }
        
        fillUserDataView.usernameTextField.text = userData.username
        fillUserDataView.passwordTextField.text = userData.password
        fillUserDataView.firstnameTextField.text = userData.firstname
        fillUserDataView.lastnameTextField.text = userData.lastname
        fillUserDataView.emailTextField.text = userData.email
        fillUserDataView.creditCardTextField.text = userData.creditCard
        fillUserDataView.bioTextField.text = userData.bio
        fillUserDataView.genderPickerView.selectRow(
            genderArray.firstIndex(of: userData.gender) ?? 0,
            inComponent: 0,
            animated: true
        )
    }
    
    func setupInitialFields(username: String, password: String) {
        SwiftyBeaver.info("Setting username and password from previous view controller")
        fillUserDataView.usernameTextField.text = username
        fillUserDataView.passwordTextField.text = password
    }
}

extension FillUserDataViewController: FillUserDataViewInput { }

extension FillUserDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
