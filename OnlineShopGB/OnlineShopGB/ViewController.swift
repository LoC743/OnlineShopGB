//
//  ViewController.swift
//  OnlineShopGB
//
//  Created by Alexey on 18.06.2021.
//

import SnapKit

class ViewController: UIViewController {
    
    let requestFactory = RequestFactory()
    
    let changeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupChangeButton()
        
//        self.logout()
//        self.login()
//        self.signUp()
//        self.updateUserData()
//        
//        self.catalog()
//        self.goodByID()
//        
//        self.addReview()
//        self.getReview()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.removeReview()
//        }
//        
//        self.addToCart()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.getCart()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
//            self.removeFromCart()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.payCart()
//        }
    }
    
    func setupChangeButton() {
        self.view.addSubview(changeButton)
        
        let buttonHeight: CGFloat = 55.0
        let buttonWidth: CGFloat = 120.0
        
        changeButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonWidth)
        }
        
        changeButton.layer.cornerRadius = buttonHeight / 2

        changeButton.backgroundColor = .systemBlue
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.setTitle(NSLocalizedString("updateUserDataTitle", comment: ""), for: .normal)
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    @objc func changeButtonTapped() {
        let updateUserDataViewController = FillUserDataBuilder.buildUpdateUserData()
        self.present(updateUserDataViewController, animated: true, completion: nil)
    }
    
    func login() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                print(login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(userID: 123) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        let auth = requestFactory.makeAuthRequestFatory()

        let user = User(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            firstname: "QWERTY",
            lastname: "qwerty",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        auth.signUp(userData: user) { response in
            switch response.result {
            case .success(let signUp):
                print(signUp)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserData() {
        let auth = requestFactory.makeAuthRequestFatory()
        let user = User(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            firstname: "QWERTY",
            lastname: "qwerty",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        
        auth.updateUserData(userData: user) { response in
            switch response.result {
            case .success(let update):
                print(update)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func catalog() {
        let product = requestFactory.makeProductRequestFatory()
        product.catalog { response in
            switch response.result {
            case .success(let catalog):
                print(catalog)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func goodByID() {
        let product = requestFactory.makeProductRequestFatory()
        product.product(by: 123) { response in
            switch response.result {
            case .success(let good):
                print(good)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addReview() {
        let review = requestFactory.makeReviewRequestFatory()
        review.add(userID: 123, productID: 456, text: "Review"){ response in
            switch response.result {
            case .success(let add):
                print(add)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var commentID: String?
    
    func getReview() {
        let review = requestFactory.makeReviewRequestFatory()
        review.get(productID: 456) { response in
            switch response.result {
            case .success(let reviews):
                print(reviews)
                self.commentID = reviews.first?.commentID
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeReview() {
        guard let commentID = self.commentID else { return }
        
        let review = requestFactory.makeReviewRequestFatory()
        
        review.remove(commentID: commentID) { response in
            switch response.result {
            case .success(let remove):
                print(remove)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addToCart() {
        let cart = requestFactory.makeCartRequestFatory()

        cart.add(userID: 123, productID: 123, quantity: 1) { response in
            switch response.result {
            case .success(let add):
                print(add)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        cart.add(userID: 123, productID: 456, quantity: 1) { response in
            switch response.result {
            case .success(let add):
                print(add)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCart() {
        let cart = requestFactory.makeCartRequestFatory()

        cart.get(userID: 123) { response in
            switch response.result {
            case .success(let get):
                print(get)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeFromCart() {
        let cart = requestFactory.makeCartRequestFatory()

        cart.remove(userID: 123, productID: 123) { response in
            switch response.result {
            case .success(let remove):
                print(remove)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func payCart() {
        let cart = requestFactory.makeCartRequestFatory()

        cart.pay(userID: 123, money: 1000) { response in
            switch response.result {
            case .success(let pay):
                print(pay)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

