//
//  ReviewsInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import Alamofire
import SwiftyBeaver

protocol ReviewsInteractorInput {
    func loadReviews(for productID: Int, completionHandler: @escaping (AFDataResponse<[ReviewResult]>) -> Void)
    func addReview(userID: Int, productID: Int, reviewText: String, completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void)
    func removeReview(commentID: String, completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void)
}

class ReviewsInteractor: ReviewsInteractorInput {

    private lazy var reviewService: ReviewRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeReviewRequestFatory()
    }()

    func loadReviews(for productID: Int, completionHandler: @escaping (AFDataResponse<[ReviewResult]>) -> Void) {
        SwiftyBeaver.info("ReviewRequestFactory.loadReviews")
        reviewService.get(productID: productID, completionHandler: completionHandler)
    }
    
    func addReview(userID: Int, productID: Int, reviewText: String, completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void) {
        SwiftyBeaver.info("ReviewRequestFactory.addReview")
        reviewService.add(userID: userID, productID: productID, text: reviewText, completionHandler: completionHandler)
    }
    
    func removeReview(commentID: String, completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void) {
        SwiftyBeaver.info("ReviewRequestFactory.removeReview")
        reviewService.remove(commentID: commentID, completionHandler: completionHandler)
    }
}
