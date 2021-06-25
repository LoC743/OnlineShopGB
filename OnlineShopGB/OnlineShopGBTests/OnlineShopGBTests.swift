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

    // ******************************
    // ******* Auth Testing *********
    // ******************************

    func testAuthLogin() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signIn = expectation(description: "login")
        
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                XCTAssertEqual(login.result, 1)
                XCTAssertEqual(login.authToken, "some_authorizaion_token")
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
    
    func testAuthLogout() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signOut = expectation(description: "logout")
        
        auth.logout(authToken: "some_authorizaion_token") { response in
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
    
    func testSignUpLogout() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let signUpExpect = expectation(description: "signup")
        
        auth.signUp(userName: "Somebody", password: "mypassword") { response in
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

    func testUpdateUserData() throws {
        let auth = requestFactory.makeAuthRequestFatory()
        
        let updateUserData = expectation(description: "update")
        
        auth.updateUserData(authToken: "some_authorizaion_token", userName: "Somebody", password: "mypassword") { response in
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
    
    // ******************************
    // ***** Product Testing ********
    // ******************************

    func testCatalogData() throws {
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
    
    func testProductByID() throws {
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
}
