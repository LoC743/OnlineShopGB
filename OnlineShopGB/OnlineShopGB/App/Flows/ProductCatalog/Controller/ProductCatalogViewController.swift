//
//  ProductCatalogViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 13.07.2021.
//

import UIKit
import SwiftyBeaver

class ProductCatalogViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var productCatalogView: ProductCatalogView {
        return self.view as! ProductCatalogView
    }
    
    private let presenter: ProductCatalogViewOutput
    
    // MARK: - Public Properties
    
    var catalog: [ProductResult] = [] {
        didSet {
            SwiftyBeaver.info("New catalog arrived. Reloading TableView.")
            productCatalogView.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    init(presenter: ProductCatalogViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = ProductCatalogView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCatalogView.tableView.register(
            ProductTableViewCell.self,
            forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier
        )
        productCatalogView.tableView.delegate = self
        productCatalogView.tableView.dataSource = self
        
        productCatalogView.popUpProductView.addToCartButton.addTarget(
            self,
            action: #selector(addToCart),
            for: .touchUpInside
        )
        productCatalogView.popUpProductView.reviewsButton.addTarget(
            self,
            action: #selector(openReviews),
            for: .touchUpInside
        )
        
        addTapGestureToBlur()
        
        loadCatalog()
    }
    
    private func loadCatalog() {
        presenter.viewDidLoadCatalog()
    }
    
    @objc private func addToCart() {
        SwiftyBeaver.info("Add to cart button pressed.")
        productCatalogView.hidePopUp()
    }
    
    private func addTapGestureToBlur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopUp))
        productCatalogView.blurPopUpBackground.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hidePopUp() {
        SwiftyBeaver.info("Hide popup view with product info.")
        productCatalogView.hidePopUp()
    }
    
    @objc private func openReviews() {
        SwiftyBeaver.info("Reviews button pressed.")
        guard let product = productCatalogView.popUpProductView.product,
              let productID = productCatalogView.popUpProductView.productID else {
            SwiftyBeaver.warning("Product data for reviews missing.")
            return
        }

        presenter.viewDidEnterReviews(for: productID, with: product.name ?? "")
    }
    
    private func showPopUp(for productID: Int) {
        presenter.viewDidLoadProduct(by: productID) { [weak self] product in
            DispatchQueue.main.async {
                self?.productCatalogView.showPopUp(with: product, id: productID)
            }
        }
    }
}

extension ProductCatalogViewController: ProductCatalogViewInput { }

// MAKR: - TableViewDelegate, TableViewDataSource

extension ProductCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ProductTableViewCell
        
        cell.configure(with: catalog[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id = catalog[indexPath.row].id
        showPopUp(for: id)
    }
}
