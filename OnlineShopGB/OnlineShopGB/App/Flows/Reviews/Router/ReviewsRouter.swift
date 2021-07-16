//
//  ReviewsRouter.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver

protocol ReviewsRouterInput {
    func showNewReviewAlert(with callback: @escaping (String, Int) -> Void, for id: Int)
    func showReviewSettingAlert(with actions: [UIAlertAction])
}

class ReviewsRouter: ReviewsRouterInput {
    
    weak var viewController: UIViewController?
    
    func showNewReviewAlert(with callback: @escaping (String, Int) -> Void, for id: Int) {
        SwiftyBeaver.info("Showing alert with text field")
        let title = NSLocalizedString("addNewReviewTitle", comment: "")
        let message = NSLocalizedString("addNewReviewMessage", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("reviewTitle", comment: "")
        }
        
        let addReviewAction = UIAlertAction(
            title: NSLocalizedString("addButtonAlert", comment: ""),
            style: .default,
            handler: { [weak alert] _ in
                guard let textField = alert?.textFields![0] else { return }
                
                callback(textField.text ?? "", id)
            }
        )
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancelButtonAlert", comment: ""),
            style: .cancel,
            handler: nil
        )
        
        [addReviewAction, cancelAction].forEach { action in
            alert.addAction(action)
        }
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func showReviewSettingAlert(with actions: [UIAlertAction]) {
        SwiftyBeaver.info("Showing alert with action sheet")
        let title = NSLocalizedString("reviewAlertActionsTitle", comment: "")
        let message = NSLocalizedString("reviewAlertActionsMessage", comment: "")
        viewController?.showAlertSheet(with: title, message: message, actions: actions)
    }
}
