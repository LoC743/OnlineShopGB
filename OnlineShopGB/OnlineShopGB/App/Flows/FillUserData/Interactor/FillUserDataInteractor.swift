//
//  FillUserDataInteractor.swift
//  OnlineShopGB
//
//  Created by Alexey on 11.07.2021.
//

import Alamofire

protocol FillUserDataInteractorInput {
    func signUp(user: User, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void)
    func updateUserData(user: User, completionHandler: @escaping (AFDataResponse<UpdateUserDataResult>) -> Void)
}

class FillUserDataInteractor: FillUserDataInteractorInput {
    
    private lazy var authService: AuthRequestFactory = {
        let requestFactory = RequestFactory()
        return requestFactory.makeAuthRequestFatory()
    }()
    
    func signUp(user: User, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void) {
        authService.signUp(userData: user, completionHandler: completionHandler)
    }
    
    func updateUserData(user: User, completionHandler: @escaping (AFDataResponse<UpdateUserDataResult>) -> Void) {
        authService.updateUserData(userData: user, completionHandler: completionHandler)
    }
}
