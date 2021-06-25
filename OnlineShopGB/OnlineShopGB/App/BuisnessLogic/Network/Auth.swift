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
        baseURL: URL,
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)
    ) {
        self.baseUrl = baseURL
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
    
    func logout(authToken: String, completionHandler: @escaping (AFDataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, authToken: authToken)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func signUp(userName: String, password: String, completionHandler: @escaping (AFDataResponse<SignUpResult>) -> Void) {
        let requestModel = SignUp(baseUrl: baseUrl, login: userName, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func updateUserData(authToken: String, userName: String, password: String, completionHandler: @escaping (AFDataResponse<UpdateUserDataResult>) -> Void) {
        let requestModel = UpdateUserData(baseUrl: baseUrl, authToken: authToken, login: userName, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Auth {
    struct Login: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "login.json"
        
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
        let method: HTTPMethod = .get
        let path: String = "logout.json"
        
        let authToken: String
        var parameters: Parameters? {
            return [
                "authToken": authToken,
            ]
        }
    }
    
    struct SignUp: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get // .post
        let path: String = "registerUser.json"
        
        let login: String
        let password: String
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password
            ]
        }
    }
    
    struct UpdateUserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get // .put
        let path: String = "changeUserData.json"
        
        let authToken: String
        let login: String
        let password: String
        var parameters: Parameters? {
            return [
                "authToken": authToken,
                "username": login,
                "password": password
            ]
        }
    }
}

