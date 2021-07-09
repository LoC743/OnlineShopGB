//
//  RequestFactory.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Alamofire

class RequestFactory {
    
    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }
    
    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let manager = Session(configuration: configuration)
        
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeAuthRequestFatory() -> AuthRequestFactory {
        let errorParser = makeErrorParser()
        
        return Auth(baseURL: StringResources.baseURL, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeProductRequestFatory() -> ProductRequestFactory {
        let errorParser = makeErrorParser()
        
        return Product(baseURL: StringResources.baseURL, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeReviewRequestFatory() -> ReviewRequestFactory {
        let errorParser = makeErrorParser()
        
        return Review(baseURL: StringResources.baseURL, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeCartRequestFatory() -> CartRequestFactory {
        let errorParser = makeErrorParser()
        
        return Cart(baseURL: StringResources.baseURL, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
}
