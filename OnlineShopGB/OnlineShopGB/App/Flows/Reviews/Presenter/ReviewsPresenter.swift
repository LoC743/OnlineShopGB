//
//  ReviewsPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver
import FirebaseCrashlytics
import FirebaseAnalytics

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
            userDataFatalError()
            return
        }
        interactor.addReview(userID: userID, productID: productID, reviewText: reviewText) { [weak self] response in
            switch response.result {
            case .success(_):
                SwiftyBeaver.info("Reviews successfully added..")
                self?.viewDidLoadReviews(for: productID)
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
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
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
    
    private func userDataFatalError() {
        SwiftyBeaver.error(StringResources.userError)
        Crashlytics.crashlytics().log(StringResources.userError)
        fatalError(StringResources.userError)
    }
    
    private func addReviewLog() {
        SwiftyBeaver.info("Add new review")
        let title = "review-add"
        Analytics.logEvent(title, parameters: [:])
    }
    
    private func removeReviewLog() {
        SwiftyBeaver.info("Remove review")
        let title = "review-remove"
        Analytics.logEvent(title, parameters: [:])
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
                Crashlytics.crashlytics().log("\(error.localizedDescription)")
            }
        }
    }
    
    func viewDidAddNewReview(productID: Int) {
        addReviewLog()
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
        removeReviewLog()
        router.showReviewSettingAlert(with: [removeAction, cancelAction])
    }
}
