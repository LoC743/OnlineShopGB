//
//  ReviewsView.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import SnapKit
import SwiftyBeaver

final class ReviewsView: UIView {
    
    // MARK: - Subviews
    
    lazy var tableView = UITableView()
    
    lazy var noReviews = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let safeArea = UIApplication.shared.windows[0].safeAreaInsets
        static let navigationBarHeight: CGFloat = 44.0
        static let tabBarHeight: CGFloat = 49.0
        
        static let topTableViewOffset = safeArea.top + navigationBarHeight
        static let bottomTableViewOffset = safeArea.bottom + tabBarHeight
        
        static let noReviewFontSize: CGFloat = 20.0
        
        static let animationDuration = 0.8
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        
        addTableView()
        addNoReviewsLabel()
    }
    
    
    private func addTableView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.topTableViewOffset)
            make.bottom.equalTo(self).offset(-Constants.bottomTableViewOffset)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
    }
    
    private func addNoReviewsLabel() {
        addSubview(noReviews)
        
        noReviews.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
        
        noReviews.text = NSLocalizedString("noReviewsLabel", comment: "")
        noReviews.textAlignment = .center
        noReviews.textColor = .black
        noReviews.font = .systemFont(ofSize: Constants.noReviewFontSize, weight: .bold)
        
        noReviews.isHidden = true
    }
    
    // MARK: - Public methods
    
    func reloadTableViewData() {
        SwiftyBeaver.info("Showing table view")
        UIView.animate(withDuration: Constants.animationDuration) {
            self.tableView.layer.opacity = 1.0
            self.noReviews.layer.opacity = 0.0
        } completion: { isFinished in
            if isFinished {
                self.noReviews.isHidden = true
                self.tableView.isHidden = false
            }
        }
       
        tableView.reloadData()
    }
    
    func setEmpty() {
        SwiftyBeaver.info("Hiding table view -> No reviews")
        UIView.animate(withDuration: Constants.animationDuration) {
            self.tableView.layer.opacity = 0.0
            self.noReviews.layer.opacity = 1.0
        } completion: { isFinished in
            if isFinished {
                self.noReviews.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
}
