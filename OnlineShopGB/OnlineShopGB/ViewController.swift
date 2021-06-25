//
//  ViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 18.06.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .magenta
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logout()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.signUp()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateUserData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.catalogData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.goodByID()
        }
    }
    
    func logout() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.logoutRequestFactory()
    }
    
    func signUp() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.signUpRequestFactory()
    }
    
    func updateUserData() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.updateUserDataRequestFactory()
    }
    
    func catalogData() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.catalogDataRequestFactory()
    }
    
    func goodByID() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.goodByIDRequestFactory()
    }
}

