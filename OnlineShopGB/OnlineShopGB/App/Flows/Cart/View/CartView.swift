//
//  CartView.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import SnapKit
import SwiftyBeaver

final class CartView: UIView {
    
    // MARK: - Subviews
    
    lazy var tableView = UITableView()
    
    lazy var emptyCartLabel = UILabel()
    
    lazy var footerView = UIView()
    lazy var totalPriceLabel = UILabel()
    lazy var payButton = UIButton(type: .system)
    
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
    
        static let topTableViewOffset: CGFloat = safeArea.top + navigationBarHeight

        static let bottomFooterViewOffset: CGFloat = safeArea.bottom + tabBarHeight
        static let heightFooterView: CGFloat = 55.0
        
        static let totalPriceLeftOffset: CGFloat = 15.0
        static let payButtonRightOffset: CGFloat = 15.0
        static let payButtonWidth: CGFloat = 95.0
        static let payButtonHeight: CGFloat = 30.0
        
        static let emptyCartFontSize: CGFloat = 20.0
        static let totalPriceFontSize: CGFloat = 18.0
        
        static let animationDuration = 0.8
        static let transitionDuration = 0.25
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        addFooterView()
        addTotalPriceLabel()
        addPayButton()
        addTableView()
        addEmptyCartLabel()
    }
    
    private func addTableView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.topTableViewOffset)
            make.bottom.equalTo(footerView.snp.top)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        tableView.allowsSelection = false
    }
    
    private func addEmptyCartLabel() {
        addSubview(emptyCartLabel)
        
        emptyCartLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
        
        emptyCartLabel.text = NSLocalizedString("emptyCartLabel", comment: "")
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.textColor = .black
        emptyCartLabel.font = .systemFont(ofSize: Constants.emptyCartFontSize, weight: .bold)
        
        emptyCartLabel.isHidden = true
    }
    
    private func addFooterView() {
        addSubview(footerView)
        
        footerView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-Constants.bottomFooterViewOffset)
            make.height.equalTo(Constants.heightFooterView)
        }
    }
    
    private func addTotalPriceLabel() {
        footerView.addSubview(totalPriceLabel)
        
        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(footerView).offset(Constants.totalPriceLeftOffset)
            make.centerY.equalTo(footerView)
        }
        
        totalPriceLabel.font = .systemFont(ofSize: Constants.totalPriceFontSize, weight: .bold)
        
        setTotalPrice(with: 0)
    }
    
    private func addPayButton() {
        footerView.addSubview(payButton)
        
        payButton.snp.makeConstraints { make in
            make.right.equalTo(footerView).offset(-Constants.payButtonRightOffset)
            make.centerY.equalTo(totalPriceLabel)
            make.width.equalTo(Constants.payButtonWidth)
            make.height.equalTo(Constants.payButtonHeight)
        }
        
        payButton.setTitle(NSLocalizedString("payButtonTitle", comment: ""), for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.layer.cornerRadius = Constants.payButtonHeight / 2
    }
    
    // MARK: - Public methods
    
    func setTotalPrice(with total: Int) {
        UIView.transition(with: totalPriceLabel,
                          duration: Constants.transitionDuration,
                          options: .transitionCrossDissolve
        ) { [weak self] in
            self?.totalPriceLabel.text = NSLocalizedString("totalPriceTitle", comment: "") + "\(total) ₽"
        } completion: { (_) in }
    }

    func reloadTableViewData() {
        SwiftyBeaver.info("Showing table view")
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyCartLabel.layer.opacity = 0.0
            self.tableView.layer.opacity = 1.0
            self.footerView.layer.opacity = 1.0
        } completion: { isFinished in
            if isFinished {
                self.emptyCartLabel.isHidden = true
                self.tableView.isHidden = false
                self.footerView.isHidden = false
            }
        }
       
        tableView.reloadData()
    }
    
    func setEmpty() {
        SwiftyBeaver.info("Hiding table view -> No products in cart")
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyCartLabel.layer.opacity = 1.0
            self.tableView.layer.opacity = 0.0
            self.footerView.layer.opacity = 0.0
        } completion: { isFinished in
            if isFinished {
                self.emptyCartLabel.isHidden = false
                self.tableView.isHidden = true
                self.footerView.isHidden = true
            }
        }
    }
}
