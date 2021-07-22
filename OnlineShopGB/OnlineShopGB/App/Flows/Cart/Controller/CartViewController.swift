//
//  CartViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 19.07.2021.
//

import UIKit
import SwiftyBeaver

class CartViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var cartView: CartView {
        return self.view as! CartView
    }
    
    private let presenter: CartViewOutput
    
    // MARK: - Public Properties
    
    var totalPrice: Int = 0 {
        didSet {
            cartView.setTotalPrice(with: totalPrice)
        }
    }

    var products: [CartProduct] = [] {
        didSet {
            SwiftyBeaver.info("Cart products loaded")
            if products.isEmpty {
                cartView.setEmpty()
                cartView.tableView.reloadData()
            } else {
                cartView.reloadTableViewData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(presenter: CartViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = CartView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartView.tableView.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: CartTableViewCell.reuseIdentifier
        )
        cartView.tableView.delegate = self
        cartView.tableView.dataSource = self
        
        cartView.payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
        setBalance()
        addUserSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCart()
    }
    
    private func loadCart() {
        presenter.viewDidLoadCart()
    }
    
    private func addToCart(productID: Int) {
        presenter.viewDidAddToCart(productID: productID)
    }
    
    private func removeFromCart(productID: Int) {
        presenter.viewDidRemoveFromCart(productID: productID)
    }
    
    private func calculateTotalPrice() -> Int {
        var sum = 0
        for product in products {
            sum += product.price * product.quantity
        }
        
        return sum
    }
    
    @objc private func payButtonTapped() {
        presenter.viewDidPayCart()
    }
    
    private func addUserSettings() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle") ?? UIImage(),
            style: .plain,
            target: self,
            action: #selector(userSettingsButtonTapped)
        )
    }
    
    @objc private func userSettingsButtonTapped() {
        presenter.viewDidOpenUpdateUserSettings()
    }
}

extension CartViewController: CartViewInput {
    func setBalance() {
        let balanceTitle = NSLocalizedString("balanceTitle", comment: "") + "\(UserSession.shared.money) ₽"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: balanceTitle,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}

// MARK: - TableViewDelegate, TableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! CartTableViewCell
        
        let product = products[indexPath.row]
        cell.configure(with: product)
        cell.stepper.tag = indexPath.row
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        return cell
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let product = products[sender.tag]
        
        if product.quantity < Int(sender.value) {
            addToCart(productID: product.productID)
        } else {
            removeFromCart(productID: product.productID)
        }
        products[sender.tag].quantity = Int(sender.value)
        totalPrice = calculateTotalPrice()
        
        if sender.value == 0 {
            products.remove(at: sender.tag)
        }
    }
}

