//
//  Auth.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Alamofire

class Auth: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl: URL
    
    init(
        baseURL: String,
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)
    ) {
        self.baseUrl = URL(string: baseURL)!
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Auth: AuthRequestFactory {
    
    func login(userName: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResult>) -> Void) {
        let requestModel = Login(baseUrl: baseUrl, login: userName, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func logout(userID: Int, completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, userID: userID)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func signUp(userData: UserData, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void) {
        let requestModel = SignUp(baseUrl: baseUrl, userData: userData)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func updateUserData(userData: UserData, completionHandler: @escaping (AFDataResponse<UpdateUserDataResult>) -> Void) {
        let requestModel = UpdateUserData(baseUrl: baseUrl, userData: userData)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Auth {
    struct Login: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "signin"
        
        let login: String
        let password: String
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password
            ]
        }
    }
    
    struct Logout: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "signout"
        
        let userID: Int
        var parameters: Parameters? {
            return [
                "user_id": userID,
            ]
        }
    }
    
    struct SignUp: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "register"
        
        let userData: UserData
        var parameters: Parameters? {
            return [
                "id_user": userData.id,
                "username": userData.username,
                "password": userData.password,
                "email": userData.email,
                "gender": userData.gender,
                "credit_card": userData.creditCard,
                "bio": userData.bio
            ]
        }
    }
    
    struct UpdateUserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .put
        let path: String = "updateUserData"
        
        let userData: UserData
        var parameters: Parameters? {
            return [
                "id_user": userData.id,
                "username": userData.username,
                "password": userData.password,
                "email": userData.email,
                "gender": userData.gender,
                "credit_card": userData.creditCard,
                "bio": userData.bio
            ]
        }
    }
}

