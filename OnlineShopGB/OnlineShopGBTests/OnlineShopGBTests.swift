//
//  OnlineShopGBTests.swift
//  OnlineShopGBTests
//
//  Created by Alexey on 18.06.2021.
//

import XCTest
@testable import OnlineShopGB

class OnlineShopGBTests: XCTestCase {
    
    let requestFactory = RequestFactory()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // MARK: - Auth Testing

    // MARK: Login
    func testA() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signIn = expectation(description: "login")
        
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                XCTAssertEqual(login.result, 1)
                XCTAssertEqual(login.user.id, 123)
                XCTAssertEqual(login.user.login, "geekbrains")
                XCTAssertEqual(login.user.name, "John")
                XCTAssertEqual(login.user.lastname, "Doe")
                signIn.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    // MARK: Logout
    func testB() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signOut = expectation(description: "logout")
        
        auth.logout(userID: 123) { response in
            switch response.result {
            case .success(let logout):
                XCTAssertEqual(logout.result, 1)
                signOut.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    // MARK: Sign Up
    func testC() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signUpExpect = expectation(description: "signup")
        
        let user = UserData(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        auth.signUp(userData: user) { response in
            switch response.result {
            case .success(let signUp):
                XCTAssertEqual(signUp.result, 1)
                XCTAssertEqual(signUp.userMessage, "Регистрация прошла успешно!")
                signUpExpect.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }

    // MARK: Update User Data
    func testD() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let updateUserData = expectation(description: "update")
        let user = UserData(
            id: 123,
            username: "Somebody",
            password: "OnceToldMe",
            email: "some@some.ru",
            gender: "m",
            creditCard: "9872389-2424-234224-234",
            bio: "This is good! I think I will switch to another language"
        )
        
        auth.updateUserData(userData: user) { response in
            switch response.result {
            case .success(let update):
                XCTAssertEqual(update.result, 1)
                updateUserData.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    
    // MARK: - Product Testing
    
    // MARK: Catalog Data
    func testE() throws {
        let product = requestFactory.makeProductRequestFatory()
        
        let catalogData = expectation(description: "catalog")
        
        product.catalog { response in
            switch response.result {
            case .success(let catalog):
                XCTAssertEqual(catalog.count, 2)
                
                let firstProduct = catalog[0]
                XCTAssertEqual(firstProduct.id, 123)
                XCTAssertEqual(firstProduct.name, "Ноутбук")
                XCTAssertEqual(firstProduct.price, 45600)
                
                let secondProduct = catalog[1]
                XCTAssertEqual(secondProduct.id, 456)
                XCTAssertEqual(secondProduct.name, "Мышка")
                XCTAssertEqual(secondProduct.price, 1000)
                
                catalogData.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    // MARK: Product By ID
    func testF() throws {
        let product = requestFactory.makeProductRequestFatory()
        
        let productByID = expectation(description: "productByID")
        
        product.product(by: 123) { response in
            switch response.result {
            case .success(let good):
                XCTAssertEqual(good.result, 1)
                XCTAssertEqual(good.name, "Ноутбук")
                XCTAssertEqual(good.price, 45600)
                XCTAssertEqual(good.description, "Мощный игровой ноутбук")
                
                productByID.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    
    // MARK: - Review Testing
    
    // MARK: Adding Review
    func testG() throws {
        let review = requestFactory.makeReviewRequestFatory()

        let addReview = expectation(description: "addReview")

        review.add(userID: 123, productID: 123, text: "Отзыв") { response in
            switch response.result {
            case .success(let add):
                XCTAssertEqual(add.errorMessage, nil);
                XCTAssertEqual(add.result, 1);
                XCTAssertEqual(add.userMessage, "Отзыв успешно добавлен.");

                addReview.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    // MARK: Getting Review
    func testH() throws {
        let review = requestFactory.makeReviewRequestFatory()

        let getReviews = expectation(description: "getReviews")

        review.get(productID: 123) { response in
            switch response.result {
            case .success(let reviews):
                guard let firstReview = reviews.first else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(firstReview.userID, 123)
                XCTAssertEqual(firstReview.productID, 123)
                XCTAssertNotNil(firstReview.commentID)
                XCTAssertEqual(firstReview.text, "Отзыв")
                
                getReviews.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    // MARK: Removing Review
    func testI() throws {
        let review = requestFactory.makeReviewRequestFatory()
        
        let removeReview = expectation(description: "removeReview")
        
        review.get(productID: 123) { response in
            switch response.result {
            case .success(let reviews):
                guard let firstReview = reviews.first else {
                    XCTFail()
                    return
                }
                
                review.remove(commentID: firstReview.commentID) { response in
                    switch response.result {
                    case .success(let remove):
                        XCTAssertEqual(remove.errorMessage, nil);
                        XCTAssertEqual(remove.result, 1);

                        removeReview.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    // MARK: Cart Testing
    
    // MARK: Add To Cart
    func testJ() throws {
        let cart = requestFactory.makeCartRequestFatory()

        let addToCart = expectation(description: "addToCart")

        cart.add(userID: 123, productID: 123, quantity: 1) { response in
            switch response.result {
            case .success(let add):
                XCTAssertEqual(add.errorMessage, nil);
                XCTAssertEqual(add.result, 1);

                addToCart.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    // MARK: Getting Cart
    func testK() throws {
        let cart = requestFactory.makeCartRequestFatory()

        let getCart = expectation(description: "getCart")

        cart.get(userID: 123) { response in
            switch response.result {
            case .success(let get):
                XCTAssertEqual(get.count, 1);
                XCTAssertEqual(get.totalPrice, 45600);

                getCart.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    // MARK: Removing From Cart
    func testL() throws {
        let cart = requestFactory.makeCartRequestFatory()

        let removeFromCart = expectation(description: "removeFromCart")

        cart.remove(userID: 123, productID: 123) { response in
            switch response.result {
            case .success(let remove):
                XCTAssertEqual(remove.result, 1);
                XCTAssertEqual(remove.errorMessage, nil);

                removeFromCart.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    //  MARK: Paying Cart
    func testM() throws {
        let cart = requestFactory.makeCartRequestFatory()

        let payCart = expectation(description: "payCart")
        
        cart.add(userID: 123, productID: 456, quantity: 1) { response in
            switch response.result {
            case .success(let add):
                XCTAssertEqual(add.errorMessage, nil);
                XCTAssertEqual(add.result, 1);

                cart.pay(userID: 123, money: 1000) { response in
                    switch response.result {
                    case .success(let pay):
                        XCTAssertEqual(pay.result, 1);
                        XCTAssertEqual(pay.errorMessage, nil);

                        payCart.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10)
    }
}
