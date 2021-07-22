//
//  PopUpProductView.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import SnapKit

final class PopUpProductView: UIView {
    
    // MARK: - Subviews
    
    lazy var productTitleLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var priceLabel = UILabel()
    
    lazy var addToCartButton = UIButton()
    lazy var reviewsButton = UIButton()
    
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
        
        static let cornerRadius: CGFloat = 15.0
        
        static let bigFontSize: CGFloat = 18.0
        static let regularFontSize: CGFloat = 15.0
        
        static let titleTopOffset: CFloat = 15.0
        static let titleSideOffset: CFloat = 15.0
        static let titleHeight: CGFloat = 25.0
        
        static let descriptionTopOffset: CFloat = 10.0
        static let descriptionSideOffset: CFloat = 15.0
        
        static let priceTopOffset: CFloat = 15.0
        static let priceSideOffset: CFloat = 15.0
        
        static let addToCartRightOffset: CFloat = 0.0
        static let buttonHeight: CFloat = 55.0
        static let buttonWidth: CFloat = 55.0
        static let reviewsButtonRightOffset: CGFloat = 0.0
    }
    
    var productID: Int?
    var product: GoodResult?
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        addProductTitleLabel()
        addProductDescriptionLabel()
        addPriceLabel()
        addCartButton()
        addReviewsButton()
    }
    
    private func addProductTitleLabel() {
        self.addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(Constants.titleSideOffset)
            make.right.equalTo(self).offset(-Constants.titleSideOffset)
            make.top.equalTo(self).offset(Constants.titleTopOffset)
            make.height.equalTo(Constants.titleHeight)
        }
        productTitleLabel.font = .systemFont(ofSize: Constants.bigFontSize, weight: .bold)
    }
    
    private func addProductDescriptionLabel() {
        self.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(Constants.descriptionTopOffset)
            make.left.equalTo(self).offset(Constants.descriptionSideOffset)
            make.right.equalTo(self).offset(-Constants.descriptionSideOffset)
        }
        descriptionLabel.font = .systemFont(ofSize: Constants.regularFontSize, weight: .regular)
        descriptionLabel.numberOfLines = 0
    }
    
    private func addPriceLabel() {
        self.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.priceTopOffset)
            make.left.equalTo(self).offset(Constants.priceSideOffset)
            make.bottom.equalTo(self).offset(-Constants.priceTopOffset)
        }
        priceLabel.font = .systemFont(ofSize: Constants.bigFontSize, weight: .bold)
    }
    
    private func addCartButton() {
        self.addSubview(addToCartButton)
        
        addToCartButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-Constants.addToCartRightOffset)
            make.height.equalTo(Constants.buttonHeight)
            make.width.equalTo(Constants.buttonHeight)
            make.centerY.equalTo(priceLabel)
        }
        
        let image = UIImage(systemName: "cart.badge.plus") ?? UIImage()
        addToCartButton.setImage(image, for: .normal)
    }
    
    private func addReviewsButton() {
        self.addSubview(reviewsButton)
        
        reviewsButton.snp.makeConstraints { make in
            make.right.equalTo(addToCartButton.snp.left).offset(Constants.reviewsButtonRightOffset)
            make.height.equalTo(Constants.buttonHeight)
            make.width.equalTo(Constants.buttonHeight)
            make.centerY.equalTo(priceLabel)
        }
        
        let image = UIImage(systemName: "bubble.left") ?? UIImage()
        reviewsButton.setImage(image, for: .normal)
    }
    
    // MARK: - Configure View Data
    
    func configure(with product: GoodResult, id: Int) {
        self.layer.cornerRadius = Constants.cornerRadius
        
        productTitleLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0) ₽"
        descriptionLabel.text = product.description
        self.productID = id
        self.product = product
    }
}

