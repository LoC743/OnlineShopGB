//
//  CartTableViewCell.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import SnapKit

final class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "cartReuse"
    
    // MARK: - Subviews
    
    lazy var productTitleLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var quantityLabel = UILabel()
    lazy var stepper = UIStepper()
    
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
        static let productTitleLeftOffset: CGFloat = 10.0
        static let productTitleTopOffset: CGFloat = 35.0
        
        static let priceRightOffset: CGFloat = 10.0
        static let priceWidth: CGFloat = 100.0
        
        static let quantityBottomOffset = 5.0
        static let stepperBottomOffset = 10.0
        
        static let fontSize: CGFloat = 18.0
        
        static let transitionDuration = 0.25
    }
    
    // MARK: - Private prorerties
    
    private var lastQuantity: Int?
    
    // MARK: - Configure UI
    
    private func configureUI() {
        self.backgroundColor = .white
        
        addProductTitleLabel()
        addPriceLabel()
        addStepper()
        addQuantityLabel()
    }
    
    private func addProductTitleLabel() {
        contentView.addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(Constants.productTitleTopOffset)
            make.left.equalTo(contentView).offset(Constants.productTitleLeftOffset)
            make.bottom.equalTo(contentView).offset(-Constants.productTitleTopOffset)
        }
        
        productTitleLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .regular)
    }
    
    private func addPriceLabel() {
        contentView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-Constants.priceRightOffset)
            make.width.equalTo(Constants.priceWidth)
            make.centerY.equalTo(productTitleLabel)
        }
        
        priceLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .bold)
        priceLabel.textAlignment = .right
    }

    private func addStepper() {
        contentView.addSubview(stepper)
        
        stepper.snp.makeConstraints { make in
            make.right.equalTo(priceLabel.snp.left)
            make.bottom.equalTo(contentView).offset(-Constants.stepperBottomOffset)
        }

        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = "\(sender.value)"
    }
    
    private func addQuantityLabel() {
        contentView.addSubview(quantityLabel)
        
        quantityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stepper)
            make.bottom.equalTo(stepper.snp.top).offset(-Constants.quantityBottomOffset)
        }
    }
    
    // MARK: - Public configure cell
    
    func configure(with product: CartProduct) {
        productTitleLabel.text = product.productName
        priceLabel.text = "\(product.price) ₽"
        quantityLabel.text = "\(product.quantity)"
        stepper.value = Double(product.quantity)
        lastQuantity = Int(product.quantity)
    }
}
