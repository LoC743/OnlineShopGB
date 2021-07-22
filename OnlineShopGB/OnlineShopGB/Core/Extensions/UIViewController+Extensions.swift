//
//  UIViewController+Extensions.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import UIKit

// MARK: - Show alert

extension UIViewController {
    func showAlert(with title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSheet(with title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
