//
//  SignUpInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import Alamofire

protocol SignUpInteractorInput {
    func signUp(user: UserData, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void)
}

class SignUpInteractor: SignUpInteractorInput {
    
    private lazy var authService: AuthRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeAuthRequestFatory()
    }()
    
    func signUp(user: UserData, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void) {
        authService.signUp(userData: user, completionHandler: completionHandler)
    }
}
