//
//  ReviewsView.swift
//  OnlineShopGB
//
//  Created by Alexey on 16.07.2021.
//

import SnapKit

final class ReviewsView: UIView {
    
    // MARK: - Subviews
    
    
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
        
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .red
    }
    
}
