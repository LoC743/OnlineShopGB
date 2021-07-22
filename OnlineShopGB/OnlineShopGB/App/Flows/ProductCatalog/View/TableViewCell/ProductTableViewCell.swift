//
//  ProductTableViewCell.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import SnapKit

class ProductTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "productReuse"
    
    // MARK: - Subviews
    
    lazy var productTitle = UILabel()
    lazy var priceTitle = UILabel()
    
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
        static let topOffset: CGFloat = 10.0
        static let leftTitleOffset: CGFloat = 15.0
        static let rightPriceOffset: CGFloat = 15.0
        
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        self.backgroundColor = .white
        
        [productTitle, priceTitle].forEach { label in
            contentView.addSubview(label)
        }
        
        productTitle.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.topOffset)
            make.left.equalTo(self).offset(Constants.leftTitleOffset)
            make.bottom.equalTo(self).offset(-Constants.topOffset)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.topOffset)
            make.left.equalTo(productTitle)
            make.right.equalTo(self).offset(-Constants.rightPriceOffset)
            make.bottom.equalTo(self).offset(-Constants.topOffset)
        }
        
        priceTitle.textAlignment = .right
    }
    
    // MARK: - Public configure cell
    
    func configure(with product: ProductResult) {
        self.productTitle.text = product.name
        self.priceTitle.text = "\(product.price) ₽"
    }
}
