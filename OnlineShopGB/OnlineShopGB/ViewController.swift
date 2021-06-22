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
    }
    
    func logout() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.logoutRequestFactory()
    }
}

