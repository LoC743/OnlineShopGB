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
        fillUserDataView.genderPickerView.selectRow(genderArray.count - 1, inComponent: 0, animated: true)
        
        SwiftyBeaver.info("current mode: \(mode)")
        switch mode {
        case .signUp:
            setupSignUpButton()
        case .updateData:
            setupUpdateButton()
            fillFieldWithUserSession()
        }
        
        self.addTapGestureRecognizer()
        self.delegateTextFields()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        let keyboardFrame = self.view.convert(keyboardSize, from: nil)
        self.fillUserDataView.moveViewToTextField(with: keyboardFrame)
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.fillUserDataView.restorePostion()
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        fillUserDataView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        SwiftyBeaver.info("Keyboard dismissed")
        fillUserDataView.endEditing(true)
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
    
    // MARK: - deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FillUserDataViewController: FillUserDataViewInput { }

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

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

// MARK: - UITextFieldDelegate

extension FillUserDataViewController: UITextFieldDelegate {
    
    private func delegateTextFields() {
        fillUserDataView.textFieldArray.forEach { textField in
            textField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fillUserDataView.endEditing(true)
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        fillUserDataView.activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        fillUserDataView.activeField = nil
    }
}
