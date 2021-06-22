//
//  AppDelegate.swift
//  OnlineShopGB
//
//  Created by Alexey on 18.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let requestFactory = RequestFactory()
    
    var token: String? // Auth token
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        authRequestFactory()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    func authRequestFactory() {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                print(login)
                self.token = login.authToken
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logoutRequestFactory() {
        guard let token = self.token else { return }
        
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(authToken: token) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
