//
//  AuthInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 09.07.2021.
//

import Alamofire
import SwiftyBeaver

protocol AuthInteractorInput {
    func signIn(username: String,
                password: String,
                completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void
    )
}

class AuthInteractor: AuthInteractorInput {
    
    private lazy var authService: AuthRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeAuthRequestFatory()
    }()
    
    func signIn(username: String,
                password: String,
                completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void
    ) {
        SwiftyBeaver.info("-> AuthRequestFactory.login")
        authService.login(userName: username, password: password, completionHandler: completionHandler)
    }
}
