//
//  UserSession.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import Foundation

final class UserSession {
    static let shared = UserSession()
    
    private init() { }
    
    private let defaultMoney = 100000
    
    var userData: User? {
        didSet {
            money = defaultMoney
        }
    }
    lazy var money: Int = {
       return defaultMoney
    }()
}
