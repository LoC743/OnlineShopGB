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
    
    var userData: User?
}
