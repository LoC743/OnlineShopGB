//
//  AuthRequestFactory.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Alamofire

protocol AuthRequestFactory {
    func login(userName: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void)
    func logout(authToken: String, completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void)
}
