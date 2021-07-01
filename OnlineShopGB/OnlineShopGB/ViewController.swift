//
//  ViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 18.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let requestFactory = RequestFactory()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .magenta
        
        self.logout()
        self.login()
        self.signUp()
        self.updateUserData()
        
        self.catalog()
        self.goodByID()
    }
    
    func login() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                print(login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(userID: 123) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        let auth = requestFactory.makeAuthRequestFatory()
        let user = UserData(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        auth.signUp(userData: user) { response in
            switch response.result {
            case .success(let signUp):
                print(signUp)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserData() {
        let auth = requestFactory.makeAuthRequestFatory()
        let user = UserData(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        
        auth.updateUserData(userData: user) { response in
            switch response.result {
            case .success(let update):
                print(update)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func catalog() {
        let product = requestFactory.makeProductRequestFatory()
        product.catalog { response in
            switch response.result {
            case .success(let catalog):
                print(catalog)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func goodByID() {
        let product = requestFactory.makeProductRequestFatory()
        product.product(by: 123) { response in
            switch response.result {
            case .success(let good):
                print(good)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

