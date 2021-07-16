//
//  ReviewsPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver

protocol ReviewsViewInput: AnyObject {
    var reviews: [ReviewResult] { get set }
}

protocol ReviewsViewOutput {
    func viewDidLoadReviews(for: Int)
    func viewDidAddNewReview(productID: Int)
    func viewDidTapCell(productID: Int, commentID: String)
}

class ReviewsPresenter {
    let interactor: ReviewsInteractorInput
    let router: ReviewsRouterInput
    
    weak var viewInput: (UIViewController & ReviewsViewInput)?
    
    init(interactor: ReviewsInteractorInput, router: ReviewsRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func addReview(_ reviewText: String, _ productID: Int) {
        SwiftyBeaver.info("Trying to add review..")
        guard let userID = UserSession.shared.userData?.id else {
            SwiftyBeaver.warning("Can not get user ID")
            return
        }
        interactor.addReview(userID: userID, productID: productID, reviewText: reviewText) { [weak self] response in
            switch response.result {
            case .success(_):
                SwiftyBeaver.info("Reviews successfully added..")
                self?.viewDidLoadReviews(for: productID)
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    private func removeReview(commentID: String, productID: Int) {
        SwiftyBeaver.info("Trying to remove review..")
        interactor.removeReview(commentID: commentID) { [weak self] response in
            switch response.result {
            case .success(_):
                SwiftyBeaver.info("Reviews successfully removed..")
                DispatchQueue.main.async {
                    self?.viewDidLoadReviews(for: productID)
                }
                
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
}

extension ReviewsPresenter: ReviewsViewOutput {
    
    func viewDidLoadReviews(for productID: Int) {
        SwiftyBeaver.info("Trying to load reviews..")
        interactor.loadReviews(for: productID) { [weak self] response in
            switch response.result {
            case .success(let reviews):
                SwiftyBeaver.info("Reviews successfully loaded..")
                DispatchQueue.main.async {
                    self?.viewInput?.reviews = reviews
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidAddNewReview(productID: Int) {
        SwiftyBeaver.info("Add new review")
        router.showNewReviewAlert(with: addReview, for: productID)
    }
    
    func viewDidTapCell(productID: Int, commentID: String) {
        SwiftyBeaver.info("Action sheet - remove")
        let removeAction = UIAlertAction(
            title: NSLocalizedString("removeButtonAlert", comment: ""),
            style: .destructive,
            handler: { [weak self] _ in
                self?.removeReview(commentID: commentID, productID: productID)
            }
        )
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancelButtonAlert", comment: ""),
            style: .cancel,
            handler: nil
        )
        router.showReviewSettingAlert(with: [removeAction, cancelAction])
    }
}
