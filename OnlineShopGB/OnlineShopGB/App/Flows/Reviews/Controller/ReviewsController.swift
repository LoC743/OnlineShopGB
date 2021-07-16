//
//  ReviewsViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import UIKit
import SwiftyBeaver

class ReviewsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var reviewsView: ReviewsView {
        return self.view as! ReviewsView
    }
    
    private let presenter: ReviewsViewOutput
    
    // MARK: - Lifecycle
    
    init(presenter: ReviewsViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = ReviewsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
}

extension ReviewsViewController: ReviewsViewInput { }

