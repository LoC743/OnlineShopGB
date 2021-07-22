//
//  AuthRequestFactory.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Alamofire

protocol AuthRequestFactory {
    func login(userName: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void)
    func logout(userID: Int, completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void)
    func signUp(userData: User, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void)
    func updateUserData(userData: User, completionHandler: @escaping (AFDataResponse<UpdateUserDataResult>) -> Void)
}
