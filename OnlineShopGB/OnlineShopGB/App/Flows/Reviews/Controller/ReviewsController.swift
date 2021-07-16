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
    
    private let productID: Int
    
    // MARK: - Public Properties
    
    var reviews: [ReviewResult] = [] {
        didSet {
            SwiftyBeaver.info("New reviews loaded")
            if reviews.isEmpty {
                reviewsView.setEmpty()
            } else {
                reviewsView.reloadTableViewData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(presenter: ReviewsViewOutput, productID: Int) {
        self.presenter = presenter
        self.productID = productID
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addNewReview))
        
        reviewsView.tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
        reviewsView.tableView.delegate = self
        reviewsView.tableView.dataSource = self
        
        loadReviews()
    }
    
    private func loadReviews() {
        presenter.viewDidLoadReviews(for: productID)
    }
    
    private func isUserOwns(_ review: ReviewResult) -> Bool {
        guard let user = UserSession.shared.userData else {
            return false
        }
        
        var isOwner: Bool = false
        if user.id == review.userID {
            isOwner = true
        }
        
        return isOwner
    }
    
    @objc private func addNewReview() {
        SwiftyBeaver.info("Add new review button pressed.")
        presenter.viewDidAddNewReview(productID: productID)
    }
}

extension ReviewsViewController: ReviewsViewInput { }


// MAKR: - TableViewDelegate, TableViewDataSource

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as! ReviewTableViewCell
        
        let review = reviews[indexPath.row]
        cell.configure(with: review, isOwner: isUserOwns(review))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let review = reviews[indexPath.row]
        if isUserOwns(review) {
            presenter.viewDidTapCell(productID: productID, commentID: review.commentID)
        }
    }
}

