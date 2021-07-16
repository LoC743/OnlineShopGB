//
//  ReviewsPresenter.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver

protocol ReviewsViewInput: AnyObject {}

protocol ReviewsViewOutput {
    
}

class ReviewsPresenter {
    let interactor: ReviewsInteractorInput
    let router: ReviewsRouterInput
    
    weak var viewInput: (UIViewController & ReviewsViewInput)?
    
    init(interactor: ReviewsInteractorInput, router: ReviewsRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension ReviewsPresenter: ReviewsViewOutput {
    
}
