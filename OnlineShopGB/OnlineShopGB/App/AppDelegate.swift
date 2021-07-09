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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AuthBuilder.build()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
