//
//  OnlineShopGBUITests.swift
//  OnlineShopGBUITests
//
//  Created by Alexey on 18.06.2021.
//

import XCTest

class OnlineShopGBUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Auth test
    
    // User must me signed up
    func authTest() throws {
        let app = XCUIApplication()
        let loginTextField = app.textFields["usernameTextField"]
        loginTextField.tap()
        loginTextField.typeText("John")

        let secureTextField = app.secureTextFields["passwordTextField"]
        secureTextField.tap()
        secureTextField.typeText("Qwerty")

        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["signInButton"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
