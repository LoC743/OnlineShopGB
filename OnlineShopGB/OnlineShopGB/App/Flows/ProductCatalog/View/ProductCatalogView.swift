//
//  ProductCatalogView.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import SnapKit

final class ProductCatalogView: UIView {
    
    // MARK: - Subviews
    
    lazy var tableView = UITableView()
    lazy var popUpProductView = PopUpProductView()
    lazy var blurPopUpBackground = UIView()
    lazy var blurView: UIVisualEffectView = UIVisualEffectView()
    lazy var vibrancyView: UIVisualEffectView = UIVisualEffectView()
    
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
        
        static let popUpHeight: CGFloat = 350
        static let popUpWidth: CGFloat = 240
        
        static let animationTime = 0.7
        static let animationDelay = 0.35
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        addTableView()
        configurePopUpBackground()
        addPopUpProductView()
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
    
    private func configurePopUpBackground() {
        addSubview(blurPopUpBackground)
        blurPopUpBackground.backgroundColor = .clear
        addBackgroundImageView()

        blurPopUpBackground.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.topTableViewOffset)
            make.bottom.equalTo(self).offset(-Constants.bottomTableViewOffset)
            make.right.equalTo(self)
            make.left.equalTo(self)
        }

        let blurEffect = setupBlurView()
        setupVibrancyView(blurEffect: blurEffect)
        
        blurPopUpBackground.isHidden = true
        blurPopUpBackground.layer.opacity = 0.0
    }
    
    private func addBackgroundImageView() {
        let image = UIImage(named: "productBackground")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        blurPopUpBackground.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(blurPopUpBackground)
            make.bottom.equalTo(blurPopUpBackground)
            make.left.equalTo(blurPopUpBackground)
            make.right.equalTo(blurPopUpBackground)
        }
    }
    
    private func setupBlurView() -> UIBlurEffect {
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurPopUpBackground.addSubview(blurView)
        
        blurView.snp.makeConstraints { make in
            make.top.equalTo(blurPopUpBackground)
            make.bottom.equalTo(blurPopUpBackground)
            make.left.equalTo(blurPopUpBackground)
            make.right.equalTo(blurPopUpBackground)
        }
        
        return blurEffect
    }
    
    private func setupVibrancyView(blurEffect: UIBlurEffect) {
        vibrancyView = UIVisualEffectView(frame: blurPopUpBackground.bounds)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryLabel)
        vibrancyView.effect = vibrancyEffect
        blurView.contentView.addSubview(vibrancyView)
        
        vibrancyView.snp.makeConstraints { make in
            make.top.equalTo(blurView)
            make.bottom.equalTo(blurView)
            make.left.equalTo(blurView)
            make.right.equalTo(blurView)
        }
    }
    
    private func addPopUpProductView() {
        addSubview(popUpProductView)
        
        popUpProductView.snp.makeConstraints { make in
            make.centerX.equalTo(blurPopUpBackground)
            make.centerY.equalTo(blurPopUpBackground)
            make.height.equalTo(Constants.popUpHeight)
            make.width.equalTo(Constants.popUpWidth)
        }
        
        popUpProductView.isHidden = true
        popUpProductView.layer.opacity = 0.0
    }
    
    func showPopUp(with product: GoodResult, id: Int) {
        UIView.animate(withDuration: Constants.animationTime, delay: 0.0, options: .curveEaseInOut) {
            self.blurPopUpBackground.layer.opacity = 0.95
            self.blurPopUpBackground.isHidden = false
        }
        
        UIView.animate(withDuration: Constants.animationTime, delay: Constants.animationDelay, options: .curveEaseInOut) {
            self.popUpProductView.layer.opacity = 1.0
            self.popUpProductView.isHidden = false
            self.popUpProductView.configure(with: product, id: id)
        }
    }
    
    func hidePopUp() {
        UIView.animate(withDuration: Constants.animationTime, delay: 0.0, options: .curveEaseInOut) {
            self.popUpProductView.layer.opacity = 0.0
        } completion: { finished in
            self.popUpProductView.isHidden = false
        }
        
        UIView.animate(withDuration: Constants.animationTime, delay: Constants.animationDelay, options: .curveEaseInOut) {
            self.blurPopUpBackground.layer.opacity = 0.0
        } completion: { finished in
            self.blurPopUpBackground.isHidden = true
        }
    }
}
