//
//  ReviewTableViewCell.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import SnapKit

final class ReviewTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "reviewReuse"
    
    // MARK: - Subviews
    
    lazy var usernameLabel = UILabel()
    lazy var reviewTextLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let usernameTopOffset: CGFloat = 10.0
        static let leftOffset: CGFloat = 10.0
        static let rightOffset: CGFloat = 10.0
        static let reviewTextTopOffset: CGFloat = 7.0
        static let reviewTextBottomOffset: CGFloat = 10.0
        
        static let usernameFontSize: CGFloat = 18.0
        static let reviewTextFontSize: CGFloat = 18.0
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        self.backgroundColor = .white
        
        [usernameLabel, reviewTextLabel].forEach { label in
            addSubview(label)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.usernameTopOffset)
            make.left.equalTo(self).offset(Constants.leftOffset)
            make.right.equalTo(self).offset(-Constants.rightOffset)
        }
        
        usernameLabel.font = .systemFont(ofSize: Constants.usernameFontSize, weight: .light)
        
        reviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(Constants.reviewTextTopOffset)
            make.left.equalTo(self).offset(Constants.leftOffset)
            make.right.equalTo(self).offset(-Constants.rightOffset)
            make.bottom.equalTo(self).offset(-Constants.reviewTextBottomOffset)
        }
        
        reviewTextLabel.font = .systemFont(ofSize: Constants.reviewTextFontSize, weight: .regular)
        reviewTextLabel.numberOfLines = 0
    }
    
    // MARK: - Public configure cell
    
    func configure(with review: ReviewResult, isOwner: Bool) {
        if isOwner {
            self.usernameLabel.text = NSLocalizedString("ownerLabel", comment: "")
        } else {
            self.usernameLabel.text = NSLocalizedString("anonOwnerLabel", comment: "")
        }
        
        self.reviewTextLabel.text = review.text
    }
}
